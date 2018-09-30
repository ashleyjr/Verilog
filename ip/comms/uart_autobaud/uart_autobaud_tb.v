
module uart_autobaud_tb;
   parameter CLK_PERIOD = 20;          // 50MHz clock - 20ns period  
   parameter BAUD_PERIOD_1 = 8700;
   parameter BAUD_PERIOD_2 = 100;

   reg            clk;
   reg            nrst;
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
      .i_clk         (clk        ),
      .i_nrst        (nrst       ),
      .i_transmit    (recieved   ),
      .i_data_tx     (data_rx    ),
      .i_rx          (tx         ),
      .o_busy_rx     (busy_rx    ),
      .o_busy_tx     (busy_tx    ),
      .o_recieved    (recieved   ),
      .o_data_rx     (data_rx    ),
      .o_tx          (rx         )
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
      $display("                  TIME    nrst");		
      $monitor("%tps       %d",$time,nrst);

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
               sample_tx   = 0;
               sample_rx   = 0;
      #100     nrst        = 1;
               tx          = 1;
      #100     nrst        = 0;
      #50      nrst        = 1;

 
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

