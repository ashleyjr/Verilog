module fir_filter_tb;

	parameter CLK_PERIOD = 20;
	parameter BAUD_PERIOD = 100;

	reg 			clk;
	reg 			nRst;
	reg 	[31:0]	fir_in;
	reg 			rx;
	wire	[31:0]	fir_out;
	wire 			tx;

	fir_filter fir_filter(
		.clk		(clk 		),
		.nRst		(nRst		),
		.fir_in		(fir_in		),
		.rx			(rx			),
		.fir_out	(fir_out	),
		.tx 		(tx 		)
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end	end

	initial begin
		$dumpfile("fir_filter.vcd");
		$dumpvars(0,fir_filter_tb);
	end

	task uart_send_1;
      input [7:0] send;
      integer i;
      begin
         rx = 0;
         for(i=0;i<=7;i=i+1) begin   
            #BAUD_PERIOD rx = send[i];
         end
         #BAUD_PERIOD rx = 1;
      end
   endtask

	initial begin
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;
		#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h0A);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
     	#10000		uart_send_1(8'h11);
      	#10000		uart_send_1(8'hAA);
      	#10000		uart_send_1(8'h11);
     	#10000 		uart_send_1(8'hAA);
		#10000
		$finish;
	end

endmodule
