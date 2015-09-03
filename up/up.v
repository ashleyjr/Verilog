module up(
	input	   wire        clk,
	input	   wire        nRst,
   input    wire [1:0]  sel_out_a,
   input    wire [1:0]  sel_out_b,
   input    wire [2:0]  sel_write,
   input    wire [7:0]  data_in,
   output   wire [7:0]  data_out_a,
   output   wire [7:0]  data_out_b

);

   parameter   SEL_WRITE_ALL  = 3'b100,
               SEL_WRITE_0    = 3'b000,
               SEL_WRITE_1    = 3'b001,
               SEL_WRITE_2    = 3'b010,
               SEL_WRITE_3    = 3'b011;

   parameter   SEL_OUT_0      = 2'b00,
               SEL_OUT_1      = 2'b01,
               SEL_OUT_2      = 2'b10,
               SEL_OUT_3      = 2'b11;

   reg [7:0]   r0;
   reg [7:0]   r1;
   reg [7:0]   r2;
   reg [7:0]   r3;   

   assign   data_out_a = 
               (sel_out_a == SEL_OUT_0) ? r0:
               (sel_out_a == SEL_OUT_1) ? r1:
               (sel_out_a == SEL_OUT_2) ? r2:
               (sel_out_a == SEL_OUT_3) ? r3: 8'h00;

   assign   data_out_b = 
               (sel_out_b == SEL_OUT_0) ? r0:
               (sel_out_b == SEL_OUT_1) ? r1:
               (sel_out_b == SEL_OUT_2) ? r2:
               (sel_out_b == SEL_OUT_3) ? r3: 8'h00;

 
   always@(posedge clk) begin 
      case(sel_write)
         SEL_WRITE_ALL: begin
                           r0 <= data_in;
                           r1 <= data_in;
                           r2 <= data_in;
                           r3 <= data_in;
                        end
         SEL_WRITE_0:   r0 <= data_in;
         SEL_WRITE_1:   r1 <= data_in;
         SEL_WRITE_2:   r2 <= data_in;
         SEL_WRITE_3:   r3 <= data_in;
      endcase
   end     


endmodule
