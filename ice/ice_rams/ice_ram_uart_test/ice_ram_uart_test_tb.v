`timescale 1ns/1ps
module ice_ram_uart_test_tb;

	parameter CLK_PERIOD    = 20;
   parameter BAUD_PERIOD   = 100;

	reg   clk;
	reg   nrst;
   reg   tx;
   wire  rx;
  	
   ice_ram_uart_test 
   ice_ram_uart_test(	
	   .i_clk   (clk     ),
      .i_nrst  (nrst    ),
      .i_rx    (tx      ),
      .o_tx    (rx      )	
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin	
		$dumpfile("ice_ram_uart_test.vcd");
		$dumpvars(0,ice_ram_uart_test_tb);
		$display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,nrst);	
   end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin    
            #BAUD_PERIOD tx = send[i];
         end 
         #BAUD_PERIOD tx = 1;
      end
   endtask


   reg   [3:0] a,b,c,d;
	
   initial begin
					nrst = 1;
		         tx   = 1;
      #100		nrst = 0;
		#100		nrst = 1;
    
      // Test unused
      repeat(5) begin
      #5000    uart_send({4'hx, 4'h2});
      #5000    uart_send({4'hx, 4'h3});
		#5000    uart_send({4'hx, 4'h4});
      #5000    uart_send({4'hx, 4'h5});
      #5000    uart_send({4'hx, 4'h6});
      #5000    uart_send({4'hx, 4'h7});
      #5000    uart_send({4'hx, 4'h8});
      #5000    uart_send({4'hx, 4'h9});
      #5000    uart_send({4'hx, 4'hA});
      #5000    uart_send({4'hx, 4'hB});
      #5000    uart_send({4'hx, 4'hC});
      #5000    uart_send({4'hx, 4'hD});
      #5000    uart_send({4'hx, 4'hE});
      end

      // Reset ptr
      #5000    uart_send({4'hx, 4'h0});

      // Write address to data
      {a,b,c,d} = 'd0;
      repeat(2048) begin
      #100    uart_send({d, 4'h1});
      #100    uart_send({c, 4'h1});
      #100    uart_send({b, 4'h1});
      #100    uart_send({a, 4'h1});
      {a,b,c,d} = {a,b,c,d} + 'd1;
      end
      
      // Dump the memory
      #100    uart_send({4'hx, 4'hF});
      #10000000
		$finish;
	end

endmodule
