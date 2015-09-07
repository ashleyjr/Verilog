module up_reg_block(
	input	   wire        clk,
	input	   wire        nRst,
   input    wire [1:0]  sel_out_a,
   input    wire [1:0]  sel_out_b,
   input    wire [1:0]  sel_in,
   input    wire [7:0]  data_in,
   input    wire        we,
   output   wire [7:0]  data_out_a,
   output   wire [7:0]  data_out_b

);

   parameter   REG_ON_RES_0   = 8'h01,
               REG_ON_RES_1   = 8'h02,
               REG_ON_RES_2   = 8'h03,
               REG_ON_RES_3   = 8'h04;

   parameter   SEL_0          = 2'b00,
               SEL_1          = 2'b01,
               SEL_2          = 2'b10,
               SEL_3          = 2'b11;

   reg [7:0]   r0;
   reg [7:0]   r1;
   reg [7:0]   r2;
   reg [7:0]   r3;   

   assign   data_out_a = 
               (sel_out_a == SEL_0) ? r0:
               (sel_out_a == SEL_1) ? r1:
               (sel_out_a == SEL_2) ? r2: r3;

   assign   data_out_b = 
               (sel_out_b == SEL_0) ? r0:
               (sel_out_b == SEL_1) ? r1:
               (sel_out_b == SEL_2) ? r2: r3;

 
   always@(posedge clk or negedge nRst) begin 
      if(!nRst) begin
         r0 <= REG_ON_RES_0;
         r1 <= REG_ON_RES_1;
         r2 <= REG_ON_RES_2;
         r3 <= REG_ON_RES_3;
      end else begin
         if(we) 
            case(sel_in) 
               SEL_0:   r0 <= data_in;  
               SEL_1:   r1 <= data_in;
               SEL_2:   r2 <= data_in;
               SEL_3:   r3 <= data_in;
            endcase
      end
   end     
endmodule
