`timescale 1ns/1ps
module pid(
	input				      clk,
	input				      nRst,
	input       [31:0]   target,
   input       [31:0]   process,
   input       [31:0]   Kp,
   input       [31:0]   Ki,
   input       [31:0]   Kd,
	output reg  [31:0]   drive
);

   wire  [31:0]   error;
   wire  [31:0]   i_error;
   wire  [31:0]   d_error;

   assign error = target - process;

   
	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
	      drive <= 32'd0;	
		end else begin
         drive = (Kp*error) + (Ki*i_error) + (Kd*d_error);  
		end
	end
endmodule
