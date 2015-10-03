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
   output   reg   [3:0] ir,
   output   wire        z
);

   reg   [7:0]    sp;
   reg   [7:0]    pc;
   reg   [7:0]    r0;
   reg   [7:0]    r1;
   reg   [7:0]    r2;
   reg   [7:0]    r3;  

   assign z = (r1 == r2) ? 1'b1 : 1'b0;
   
   assign   data_out =
               (op == 5'b00000   )        ? r1 + r2            :
               (op == 5'b00001   )        ? r1 - r2            :
               (op == 5'b00010   )        ? r1 * r2            :
               (op == 5'b00011   )        ? r1 ~& r2           :
               (op == 5'b00100   )        ? r0 ^ r1            :
               (op == 5'b00101   )        ? r1 ^ r2            :
               (op == 5'b00110   )        ? r2 ^ r3            : 
               (op == 5'b10000   )        ? 8'h00              :
               (op == 5'b10001   )        ? 8'h01              :
               (op == 5'b10010   )        ? 8'h02              :
               (op == 5'b10011   )        ? 8'h03              :
               (op == 5'b10100   )        ? pc >> 1            :
               (op == 5'b10101   )        ? pc + 1             :
               (op == 5'b10110   )        ? r3                 :
               (op == 5'b10111   )        ? sp + 1             :
               (op == 5'b11001   )        ? sp                 :
               (op == 5'b11010   )        ? sp - 1             :
               (op == 5'b11011   )        ? pc                 :
               (op == 5'b11100   )        ? r2                 :
                                            data_in            ;  

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         pc <= 8'h08;
         sp <= 8'hFF;
         ir <= 4'h0;
         r0 <= 8'h00;
         r1 <= 8'h00;
         r2 <= 8'h00;
         r3 <= 8'h00;
      end else begin 
         if(sp_we)      sp <= data_out;
         if(pc_we)      pc <= data_out;
         case({ir_we,pc[0]})
            2'b11:      ir <= data_in[3:0];
            2'b10:      ir <= data_in[7:4];
         endcase
         case({rb_we,rb_sel_in}) 
            4'b1000:    r0 <= data_in;       // SEL_I0
            4'b1001:    r1 <= data_in;       // SEL_I1
            4'b1010:    r2 <= data_in;       // SEL_I2
            4'b1011:    r3 <= data_in;       // SEL_I3
            4'b1100:    r0 <= data_out;      // SEL_00
            4'b1101:    r1 <= data_out;      // SEL_01
            4'b1110:    r2 <= data_out;      // SEL_02
            4'b1111:    r3 <= data_out;      // SEL_03
         endcase
      end
   end
endmodule
