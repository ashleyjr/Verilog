`timescale 1ns/1ps
module sequential_alu_tb;

	parameter   CLK_PERIOD = 20;
   parameter   DATA_WIDTH = 5;

   reg                     i_clk;
   reg                     i_nrst;
   reg   [DATA_WIDTH-1:0]  i_a;
   reg   [DATA_WIDTH-1:0]  i_b;
   reg                     i_add;
   reg                     i_sub;
   reg                     i_mul;
   reg                     i_div;
   wire  [DATA_WIDTH-1:0]  o_q;
   wire                    o_ovf;
   wire                    o_zero;
   wire                    o_accept;

	sequential_alu #(
      .DATA_WIDTH (DATA_WIDTH ) 
   ) sequential_alu (
		.i_clk	   (i_clk      ),
		.i_nrst	   (i_nrst     ),
		.i_a        (i_a        ),
      .i_b        (i_b        ),
      .i_add      (i_add      ),
      .i_sub      (i_sub      ),
      .i_mul      (i_mul      ),
      .i_div      (i_div      ),
      .o_q        (o_q        ),
      .o_ovf      (o_ovf      ),
      .o_accept   (o_accept   )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
			$dumpfile("sequential_alu.vcd");
			$dumpvars(0,sequential_alu_tb);	
	end

   reg signed [(2*DATA_WIDTH):0]   test;
   reg signed [DATA_WIDTH:0]   top;
   reg signed [DATA_WIDTH:0]   bot;

   task add;
      input [DATA_WIDTH-1:0] a;
      input [DATA_WIDTH-1:0] b;
      begin 
               i_a         = a;
               i_b         = b;
               i_add       = 1;
               i_sub       = 0;
               i_mul       = 0;
               i_div       = 0;
               @(negedge i_clk);
               while(!o_accept)
                  @(negedge i_clk);    
               test = $signed(i_a) + $signed(i_b);
               if((test > top) || (bot > test)) begin
                  if(!o_ovf) begin
                     $display("Add overflow error"); 
                     #1
                     $finish;  
                  end
               end else begin
                  if(test[DATA_WIDTH-1:0] != o_q) begin
                     $display("Add error");
                     #1
                     $finish;
                  end
               end
      end
   endtask

   task sub;
      input [DATA_WIDTH-1:0] a;
      input [DATA_WIDTH-1:0] b;
      begin 
               i_a         = a;
               i_b         = b;
               i_add       = 0;
               i_sub       = 1;
               i_mul       = 0;
               i_div       = 0;
               @(negedge i_clk);
               while(!o_accept)
                  @(negedge i_clk);    
               test = $signed(i_a) - $signed(i_b);
               if(   (test > top) || (bot > test) || 
                     ((i_b == bot[DATA_WIDTH-1:0]) && (i_b != 0))) begin
                  if(!o_ovf) begin
                     $display("Sub overflow error"); 
                     #1
                     $finish;  
                  end
               end else begin
                  if(test[DATA_WIDTH-1:0] != o_q) begin
                     $display("Sub error");
                     #1
                     $finish;
                  end 
               end
      end
   endtask
   
   task mul;
      input [DATA_WIDTH-1:0] a;
      input [DATA_WIDTH-1:0] b;
      begin 
               i_a         = a;
               i_b         = b;
               i_add       = 0;
               i_sub       = 0;
               i_mul       = 1;
               i_div       = 0;
               @(negedge i_clk);
               while(!o_accept)
                  @(negedge i_clk);    
               test = $signed(i_a) * $signed(i_b);
               if((test > top) || (bot > test) || (test == bot)) begin
                  if(!o_ovf) begin
                     $display("Mul overflow error");
                     #1
                     $finish;  
                  end
               end else begin
                  if(test[DATA_WIDTH-1:0] != o_q) begin
                     $display("Mul error");
                     #1
                     $finish;
                  end 
               end
      end
   endtask
   
   task div;
      input [DATA_WIDTH-1:0] a;
      input [DATA_WIDTH-1:0] b;
      begin 
               i_a         = a;
               i_b         = b;
               i_add       = 0;
               i_sub       = 0;
               i_mul       = 0;
               i_div       = 1;
               @(negedge i_clk);
               while(!o_accept)
                  @(negedge i_clk);    
               test = $signed(i_a) / $signed(i_b);
               if(   (test > top)                  || 
                     (bot > test)                  || 
                     (i_a == bot[DATA_WIDTH-1:0])  || 
                     (i_b == bot[DATA_WIDTH-1:0])) begin
                  if(!o_ovf) begin
                     $display("Div overflow error"); 
                     #1
                     $finish;  
                  end
               end else begin
                  if(test[DATA_WIDTH-1:0] != o_q) begin
                     $display("Div error");
                     #1
                     $finish;
                  end 
               end

      end
   endtask
   
   task none;
      begin
               i_add       = 0;
               i_sub       = 0;
               i_mul       = 0;
               i_div       = 0;
      end
   endtask

   integer sel;
	initial begin
               top         = {(DATA_WIDTH-1){1'b1}}; 
               bot         = -top-1;
               i_a         = 0;
               i_b         = 0;
               i_sub       = 0;
               i_add       = 0;
               i_mul       = 0;
               i_div       = 0;
               i_nrst		= 1;	
		#17		i_nrst		= 0;
		#17		i_nrst		= 1;
	
     
      @(negedge i_clk);  
      add(1,1);
      add(2,1);
      sub(1,1);
      mul(1,1);
      mul(7,7);
      mul(-7,7);
      mul(7,-7);
      mul(-7,-7); 
      div(10,2); 
      div(10,10);  
      div(-10,10); 
      div(10,-10); 
      div(-10,-10); 
      div(10,0);
      none();
      repeat(50000) begin
         sel = $urandom % 5;
         case(sel)
            0: add($urandom, $urandom);
            1: sub($urandom, $urandom);
            2: mul($urandom, $urandom); 
            3: div($urandom, $urandom); 
            4  : begin
                  none();
                  @(negedge i_clk);
               end
         endcase
      end 
      #50
		$display("PASS");
      $finish;
	end

endmodule
