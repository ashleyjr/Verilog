`timescale 1ns/1ps
module blink(
	input				clk,
	input				nRst,
	input				rx,
	input				sw2,
	input				sw1,
	input				sw0,
	output	reg	tx,
	output	reg	led4,
	output	reg	led3,
	output	reg	led2,
	output	reg	led1,
	output	reg	led0
);

   reg   [33:0]   count;
   
   // 12 Mhz clock
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         count <= 34'd0;
         led4  <= 1'b0;
         led3  <= 1'b0;
         led2  <= 1'b0;
         led1  <= 1'b0;
         led0  <= 1'b0;
         tx    <= 1'b1;
      end else begin
         count <= count + 1;
         case(count)
            34'd12000000:  begin
                              led4  <= ~led4;
                              led0  <= 1'b0;
                              led1  <= 1'b1;
                              count <= 0;
                           end
            34'd3000000:   begin
                              led1  <= 1'b0;
                              led2  <= 1'b1;
                           end
             34'd6000000:  begin
                              led2  <= 1'b0;
                              led3  <= 1'b1;
                           end
            34'd9000000:   begin
                              led3  <= 1'b0;
                              led0  <= 1'b1;
                           end

         endcase
      end
   end
endmodule
