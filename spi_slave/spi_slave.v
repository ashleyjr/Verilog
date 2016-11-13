`timescale 1ns/1ps
module spi_slave(
	input				      clk,
	input				      nRst,
	input				      nCs,
	input				      sclk,
	input				      mosi,
   input          [7:0] txData,                    // Write to shift reg
   input                tx,                        // Raise high to latch data
   output               miso, 
   output         [7:0] rxData,                    // Read shift reg
   output               rx                         // nCs pass through
);

   reg         sclk_last;
   reg         catch;
   reg   [7:0] data;

   assign miso    = (nCs) ? 1'b0    : data[7];     // Show top of shift reg when selected
   assign rxData  = (nCs) ? data    : 8'h00;       // Keep output low when shifting
   assign rx      = nCs;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         sclk_last   <= 1'b0;
         catch       <= 1'b0;
         data        <= 8'd0;
      end else begin
         sclk_last   <= sclk;                      // watch for edges
         if(tx) begin                              // tx high
            data     <= txData;                    // latch in data to send
         end else begin 
            if(!nCs) begin                         // nCs low, chip selected 
               if(sclk != sclk_last) begin
                  if(sclk) begin                   // sclk rising edge
                     catch <= mosi;                // catch data on rising edge
                  end else begin                   // sclk falling edge
                     data  <= {data[6:0],catch};   // shift data on falling edge
                  end
               end
            end
         end
		end
	end
endmodule
