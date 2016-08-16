`timescale 1ns/1ps
module pid(
	input				                  clk,
	input				                  nRst,
	input    wire  signed   [31:0]   target,
   input    wire  signed   [31:0]   process,
   input    wire  signed   [31:0]   Kp,
   input    wire  signed   [31:0]   Ki,
   input    wire  signed   [31:0]   Kd,
	output   reg   signed   [31:0]   drive
);

   wire  signed   [31:0]   error;

   assign error = target - process;
 
	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	      drive <= 32'd0;	
		end else begin
         drive = (Kp*error);  
		end
	end
endmodule
