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

	reg [31:0] file_in [255:0];
   	reg [7:0] i; 
   	reg [7:0] j;
   	reg [7:0] k;
	initial begin
					$readmemh("sine.hex",file_in);
					nRst = 1;
		#100		nRst = 0;
		#100		nRst = 1;

		// Test clk div and pipe
		#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
     	#10000 		uart_send_1(8'h01);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
     	#10000 		uart_send_1(8'h01);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
     	#10000 		uart_send_1(8'h01);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
     	#10000 		uart_send_1(8'h01);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h01);
     	#10000 		uart_send_1(8'h01);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h07);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h05);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h03);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h11);


     	// Setup filter to test
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h01);
      	#10000		uart_send_1(8'h00);
      	#10000		uart_send_1(8'h00);
     	#10000 		uart_send_1(8'h00);
     	#10000		uart_send_1(8'h31);





               for(i=0;i<50;i=i+1) begin
                  for(j=0;j<255;j=j+1) begin
                     for(k=0;k<i;k=k+1) begin
                        #1;
                     end
                     fir_in = file_in[j];
                  end
               end
		$finish;
	end

endmodule
