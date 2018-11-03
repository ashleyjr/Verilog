`timescale 1ns/1ps
module ice_fm_tx_tb;

	parameter CLK_PERIOD    = 83; // 12Mhz
   parameter BAUD_PERIOD   = 1000;

	reg	         clk;
	reg	         nrst; 
   reg            tx;
	wire	         fm;
   wire           rx;

	ice_fm_tx  ice_fm_tx(
		.i_clk	   (clk           ),
		.i_nrst	   (nrst          ),
      .i_rx       (tx            ),
      .o_fm       (fm            ),
      .o_tx       (rx            )
   );

   integer  period,
            freq_hz,
            samples,
            period_acc,
            avg_freq_hz;
   reg      fm_last;

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("ice_fm_tx.vcd");
		$dumpvars(0,ice_fm_tx_tb);
		$display("                  TIME                 freq (hz)       Avg freq (hz)");		 
      $monitor("%tps       %d\t%d",$time, freq_hz, avg_freq_hz); 
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
   
      //// Sync
      #5000    uart_send(8'hAA);
      #5000    uart_send(8'h55);


      // Write data
      #5000    uart_send(8'hA0);
      #5000    uart_send(8'hA1);
      #5000    uart_send(8'hA2);
      #5000    uart_send(8'hA3);
     
      // Write address
      #5000    uart_send(8'h14);
      #5000    uart_send(8'h15);
      #5000    uart_send(8'h16); 
    
      //// Do a write
      #5000    uart_send(8'h08);

      //// Do a read
      #5000    uart_send(8'h07);

      //// Upload
      #5000    uart_send(8'h0E);
      #5000    uart_send(8'h0F);



      #5000 

      $finish;
	end
endmodule

