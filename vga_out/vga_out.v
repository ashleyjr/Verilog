`timescale 1ns/1ps
module vga_out(
	input	   clk,
	input	   nRst,
	output	vga_h_sync,
	output	vga_v_sync,
	output	R,	  
	output	G,	  
	output	B	  
);

	reg		      vga_HS;
	reg		      vga_VS;
	reg 	[9:0] 	CounterX;
	reg 	[8:0] 	CounterY;
	wire 		      CounterXmaxed 	= (CounterX==767);
	
	assign 		vga_h_sync 	= ~vga_HS;
	assign 		vga_v_sync 	= ~vga_VS;
	assign 		R 		      = CounterY[3] | (CounterX==256);
	assign 		G 		      = (CounterX[5] ^ CounterX[6]) | (CounterX==256);
	assign 		B 		      = CounterX[4] | (CounterX==256);


	always @(posedge clk or negedge nRst) begin
      if(!nRst) begin
         vga_HS   <= 'b0;
         vga_VS   <= 'b0;
         CounterX <= 'b0;
         CounterY <= 'b0;
      end else begin
         if(CounterXmaxed)
	  	   	CounterX <= 0;
		   else
	  	   	CounterX <= CounterX + 1;	
		   if(CounterXmaxed)
		       	CounterY <= CounterY + 1;
	  	   vga_HS <= (CounterX[9:4]==0);  	// active for 16 clocks
	  	   vga_VS <= (CounterY==0);   	   // active for 768 clocks
	   end
   end
endmodule
