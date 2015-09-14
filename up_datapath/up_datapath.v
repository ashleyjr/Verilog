module up_datapath(
	input	   wire        clk,
	input	   wire        nRst,
   input    wire  [7:0] data_in,
   input    wire  [4:0] op,
   input    wire        ir_we,
   input    wire        pc_we,
   input    wire  [2:0] rb_sel_in,
   input    wire        rb_we,
   input    wire        sp_we,
   output   wire  [7:0] data_out,
   output   reg   [3:0] ir
   
);

   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  

   assign   data_out =
               (op == 5'b00000   )        ? r1 +  r2           :     // Group add, sub, mul and div
               (op == 5'b00001   )        ? r1 -  r2           :
               (op == 5'b00010   )        ? r1 *  r2           :
               (op == 5'b00011   )        ? r1 /  r2           :

               (op == 5'b00100   )        ? r0 ^ r1            :     // Group all the non-mem swaps
               (op == 5'b00101   )        ? r1 ^ r2            :
               (op == 5'b00110   )        ? r2 ^ r3            :
               (op == 5'b00111   )        ? (pc + 1) ^ r3      :

               (op == 5'b11010   )        ? sp + 8'h01         :
               (op == 5'b11011   )        ? sp - 8'h01         :
               (op == 5'b11100   )        ? pc                 :
               (op == 5'b11101   )        ? (pc >> 1 & 8'h7F)  : 
               (op == 5'b11110   )        ? (pc >> 1 | 8'h80)  :
               (op == 5'b11111   )        ? pc + 1             :
                                            data_in            ;  

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc <= 8'h00;
         sp <= 8'hFF;
         ir <= 4'h0;
         r0 <= 8'h01;
         r1 <= 8'h02;
         r2 <= 8'h03;
         r3 <= 8'h04;
      end else begin
         if(ir_we)
            if(pc[0])   ir <= data_in[3:0];
            else        ir <= data_in[7:4];
         if(sp_we)      sp <= data_out;
         if(pc_we)      pc <= data_out;
         if(rb_we) 
            case(rb_sel_in) 
               3'b000:  r0 <= data_in;       // SEL_I0
               3'b001:  r1 <= data_in;       // SEL_I1
               3'b010:  r2 <= data_in;       // SEL_I2
               3'b011:  r3 <= data_in;       // SEL_I3
               3'b100:  r0 <= data_out;      // SEL_00
               3'b101:  r1 <= data_out;      // SEL_01
               3'b110:  r2 <= data_out;      // SEL_02
               3'b111:  r3 <= data_out;      // SEL_03
            endcase
      end
   end
endmodule
