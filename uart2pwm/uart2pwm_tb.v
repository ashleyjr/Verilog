`timescale 1ns/1ps
module uart2pwm_tb;

	parameter CLK_PERIOD = 20;
   parameter CLK_DIV_PERIOD = 200;

	reg	         clk;
	reg	         nRst;
   reg            tx;
	wire  [4:0]    pwm;
   wire           rx;
	
   reg            sample_tx;

   uart2pwm uart2pwm(
		.clk	            (clk           ),
			.nRst	            (nRst          ),
			.rx               (tx            ),
         .pwm              (pwm           ),
         .tx               (rx            )
  	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end
  

	initial begin
		`ifdef POST_SYNTHESIS
			$dumpfile("uart2pwm_syn.vcd");
			$dumpvars(0,uart2pwm_tb);
		`else
			$dumpfile("uart2pwm.vcd");
			$dumpvars(0,uart2pwm_tb);
		`endif
		$display("                  TIME    nRst");		$monitor("%tps       %d",$time,nRst);
	end

   task uart_send;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            sample_tx = !sample_tx;
            #2000  tx = send[i];
         end
         sample_tx = !sample_tx;
         #2000  tx = 1;
      end
   endtask


	initial begin
			      sample_tx      = 0;
               nRst		      = 1;
	   #100     nRst           = 0;
      #100     nRst           = 1;

      #10000   uart_send(8'h88);
      #10000   uart_send(8'h88);
      #10000   uart_send(8'h88);
      
      
      #10000   uart_send(8'h00);
      #10000   uart_send(8'h00);
      #10000   uart_send(8'h00);
     

      
      #1000000   uart_send(8'hBB);
      #1000000   uart_send(8'h00);
      #1000000   uart_send(8'h80);
       
      #1000000   uart_send(8'hBB);
      #1000000   uart_send(8'h01);
      #1000000   uart_send(8'h40);
       
      #100000   uart_send(8'hBB);
      #100000   uart_send(8'h02);
      #100000   uart_send(8'hA0);
       
      #100000   uart_send(8'hBB);
      #100000   uart_send(8'h00);
      #100000   uart_send(8'h80);
       
      #100000   uart_send(8'hBB);
      #100000   uart_send(8'h00);
      #100000   uart_send(8'h80);
      




      #10000 
      $finish;
	end

endmodule
