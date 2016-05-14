module prng32(
	input	                  clk,
	input	                  nRst,
   input                   reseed,
   input          [31:0]   seed,
   output   reg   [31:0]   rand
);
   parameter   BLOCKS = 5,
               WIDTH = 8;
  
   wire  [((WIDTH*BLOCKS)-1):0]     seed_long;
   wire  [((WIDTH*BLOCKS)-1):0]     rand_long;
   wire  [WIDTH-1:0]                mux_in;

   assign   seed_long   = {seed[7:0],seed};
   assign   mux_in      = seed_long[39:32]; 

   genvar i;
   generate
      for(i=0; i<BLOCKS; i=i+1) begin:prng8
         prng8 prng8(
            .clk     (clk                                         ),
            .nRst    (nRst                                        ),
            .reseed  (reseed                                      ), 
            .seed    (seed_long[((i*WIDTH)+(WIDTH-1)):(i*WIDTH)]  ),
            .rand    (rand_long[((i*WIDTH)+(WIDTH-1)):(i*WIDTH)]  ) 
         );
      end
   endgenerate

   always@(*) begin
      case(mux_in[1:0])
         2'b00:   rand[7:0] = rand_long[7:0];
         2'b01:   rand[7:0] = rand_long[15:8];
         2'b10:   rand[7:0] = rand_long[23:16];
         2'b11:   rand[7:0] = rand_long[31:24];
      endcase
      case(mux_in[3:2])
         2'b00:   rand[15:8] = rand_long[7:0];
         2'b01:   rand[15:8] = rand_long[15:8];
         2'b10:   rand[15:8] = rand_long[23:16];
         2'b11:   rand[15:8] = rand_long[31:24];
      endcase
      case(mux_in[5:4])
         2'b00:   rand[23:16] = rand_long[7:0];
         2'b01:   rand[23:16] = rand_long[15:8];
         2'b10:   rand[23:16] = rand_long[23:16];
         2'b11:   rand[23:16] = rand_long[31:24];
      endcase
      case(mux_in[7:6])
         2'b00:   rand[31:24] = rand_long[7:0];
         2'b01:   rand[31:24] = rand_long[15:8];
         2'b10:   rand[31:24] = rand_long[23:16];
         2'b11:   rand[31:24] = rand_long[31:24];
      endcase

   
   end
endmodule
