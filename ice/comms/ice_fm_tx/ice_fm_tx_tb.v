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
   
      // Sync
      #5000    uart_send(8'hAA);
      #5000    uart_send(8'h55);

      // Test unused
      repeat(5) begin 	
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

      // Set sample 
      #5000    uart_send({4'hF, 4'h3});
      #5000    uart_send({4'hF, 4'h2});

      // Reset ptr
      #5000    uart_send(8'h00);

      // Write address to data
      //{a,b,c,d} = 'd0;
      repeat(12) begin
      {a,b,c,d} = 16'h8000;
      #5000    uart_send({d, 4'h1});
      #5000    uart_send({c, 4'h1});
      #5000    uart_send({b, 4'h1});
      #5000    uart_send({a, 4'h1}); 
      end
      repeat(4) begin
      #5000    uart_send({4'h0, 4'h1});
      end
      // Set the phase acc
      #5000    uart_send({4'h0, 4'h4});
      // Dump the memory
      #5000    uart_send({4'hx, 4'hF});
      #2000000
		// Dump the memory
      #5000    uart_send({4'hx, 4'hF});
      #2000000

      $finish;
	end
endmodule

