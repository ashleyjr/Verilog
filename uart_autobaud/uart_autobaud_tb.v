
module uart_autobaud_tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD_1 = 8700;
   parameter BAUD_PERIOD_2 = 100;

   reg            clk;
   reg            nRst;
   reg            tx;
   wire           rx;
   wire           recieved;
   wire           busy_rx;
   wire           busy_tx;
   wire  [7:0]    data_tx;
   wire  [7:0]    data_rx;

   integer i,j;

   reg sample_rx;
   reg sample_tx;


   uart_autobaud uart_autobaud(
      `ifdef POST_SYNTHESIS
         .clk           (clk        ),
         .nRst          (nRst       ),
         .transmit      (recieved   ),
         . \data_tx[0]  (data_rx[0] ),
         . \data_tx[1]  (data_rx[1] ),
         . \data_tx[2]  (data_rx[2] ),
         . \data_tx[3]  (data_rx[3] ),
         . \data_tx[4]  (data_rx[4] ),
         . \data_tx[5]  (data_rx[5] ),
         . \data_tx[6]  (data_rx[6] ),
         . \data_tx[7]  (data_rx[7] ),
         .rx            (tx         ),
         .busy_rx       (busy_rx    ),
         .busy_tx       (busy_tx    ),
         .recieved      (recieved   ),
         . \data_rx[0]  (data_rx[0] ),
         . \data_rx[1]  (data_rx[1] ),
         . \data_rx[2]  (data_rx[2] ),
         . \data_rx[3]  (data_rx[3] ),
         . \data_rx[4]  (data_rx[4] ),
         . \data_rx[5]  (data_rx[5] ),
         . \data_rx[6]  (data_rx[6] ),
         . \data_rx[7]  (data_rx[7] ),
         .tx            (rx         ) 
      `else
         .clk           (clk        ),
         .nRst          (nRst       ),
         .transmit      (recieved   ),
         .data_tx       (data_rx    ),
         .rx            (tx         ),
         .busy_rx       (busy_rx    ),
         .busy_tx       (busy_tx    ),
         .recieved      (recieved   ),
         .data_rx       (data_rx    ),
         .tx            (rx         )
      `endif
   );

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
      $dumpfile("uart_autobaud.vcd");
      $dumpvars(0,uart_autobaud_tb);
   end

   task uart_send_1;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            sample_tx = !sample_tx;
            #BAUD_PERIOD_1 tx = send[i];
         end
         sample_tx = !sample_tx;
         #BAUD_PERIOD_1 tx = 1;
      end
   endtask

   task uart_send_2;
      input [7:0] send;
      integer i;
      begin
         tx = 0;
         for(i=0;i<=7;i=i+1) begin   
            sample_tx = !sample_tx;
            #BAUD_PERIOD_2 tx = send[i];
         end
         sample_tx = !sample_tx;
         #BAUD_PERIOD_2 tx = 1;
      end
   endtask


	
   initial begin
               sample_tx = 0;
               sample_rx = 0;
      #100     nRst = 1;
               tx = 1;
      #100     nRst = 0;
      #50     nRst = 1;

      //for(i=1000;i>0;i=i-1) begin
      //   for(j=0;j<i;j=j+1) begin
      //      #1 tx = 1;
      //   end
      //
      //for(j=0;j<i;j=j+1) begin
      //      #1 tx = 0;
      //   end
      //end
      #100000
      uart_send_1(8'h11);
      #100000
      uart_send_1(8'hAA);
      #100000
      uart_send_1(8'h11);
      #100000
      uart_send_1(8'hAA);


      #100000
      uart_send_2(8'h11);
      #100000
      uart_send_2(8'hAA);
      #100000
      uart_send_2(8'h11);
      #100000
      uart_send_2(8'hAA);

      
      #100000
      uart_send_1(8'h11);
      #100000
      uart_send_1(8'hAA);
      #100000
      uart_send_1(8'h11);
      #100000
      uart_send_1(8'hAA);




      #300000
	   $finish;
	end





endmodule

