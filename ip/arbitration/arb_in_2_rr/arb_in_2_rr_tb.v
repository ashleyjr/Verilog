`timescale 1ns/1ps
module arb_in_2_rr_tb;

	parameter CLK_PERIOD = 20;
   parameter p_width = 8;

	reg	               i_clk;
	reg	               i_nrst; 
   reg                  i_req0;
   reg                  i_req1;
   reg   [p_width-1:0]  i_data0,
                        i_data1;
   reg                  i_acc;
   wire                 o_acc0;
   wire                 o_acc1;
   wire                 o_req;
   wire  [p_width-1:0]  o_data;

	arb_in_2_rr #(
      .p_width    (p_width ) 
   ) arb_in_2_rr(
      .i_clk      (i_clk   ),
      .i_nrst     (i_nrst  ),
      .i_req0     (i_req0  ),
      .i_req1     (i_req1  ),
      .i_data0    (i_data0 ),
      .i_data1    (i_data1 ),
      .i_acc      (i_acc   ),
      .o_acc0     (o_acc0  ),
      .o_acc1     (o_acc1  ),
      .o_req      (o_req   ),
      .o_data     (o_data  )
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) i_clk = 0;
			#(CLK_PERIOD/2) i_clk = 1;
		end
	end

	initial begin
			$dumpfile("arb_in_2_rr.vcd");
			$dumpvars(0,arb_in_2_rr_tb);
		   $display("                  TIME    nrst");		
         $monitor("%tps       %d",$time,i_nrst);
	end

   reg   [(p_width/2)-1:0] mem [(2 ** (p_width/2))-1:0];
   
   initial begin
      while(1)
         @(posedge i_clk) mem[o_data[p_width-1:(p_width/2)]] <= o_data[(p_width/2)-1:0]; 
   end
	
   initial begin
		         i_req0 = 0;
               i_req1 = 0;
               i_acc  = 0;
               i_nrst = 1;
      #17      i_nrst = 0;
      #17      i_nrst = 1;
            
      repeat(100) begin
         @(posedge i_clk); 
         if(o_req)
            i_acc = $urandom;
         
         if(~i_req0 | o_acc0) begin
            i_req0               = $urandom; 
            i_data0              = $urandom;
            i_data0[p_width-1]   = 0;
         end   

         if(~i_req1 | o_acc1) begin
            i_req1               = $urandom; 
            i_data1              = $urandom;
            i_data1[p_width-1]   = 1;

         end   

         if(i_req0 | o_acc0)
            i_req0 = $urandom;
         if(~i_req1 | o_acc1)
            i_req1 = $urandom;
      
         // Checking
         if(o_data[p_width-1] & o_acc0)
            $error("Error: 0");
         if(~o_data[p_width-1] & o_acc1)
            $error("Error: 1");
      end
      #10
		$finish;
	end

endmodule
