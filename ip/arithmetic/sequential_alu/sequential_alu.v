`timescale 1ns/1ps
module sequential_alu(
	input    wire                             i_clk, 
   input    wire                             i_nrst,
   input    wire  signed   [DATA_WIDTH-1:0]  i_a,   
   input    wire  signed   [DATA_WIDTH-1:0]  i_b,   
   input    wire                             i_add, 
   input    wire                             i_sub, 
   input    wire                             i_mul, 
   input    wire                             i_div, 
   output   reg   signed   [DATA_WIDTH-1:0]  o_q,   
   output   reg                              o_ovf,
   output   reg                              o_zero,
   output   reg                              o_accept 
);

   parameter      DATA_WIDTH  = 0;
   parameter      SM_IDLE     = 'd0; 
   parameter      SM_MUL      = 'd1; 
   parameter      SM_MUL_DONE = 'd2;
   parameter      SM_DIV_R    = 'd3;
   parameter      SM_DIV_CMP  = 'd4; 
   
   reg   [DATA_WIDTH-1:0]           adder_a;
   reg   [DATA_WIDTH-1:0]           adder_b;
   reg   [DATA_WIDTH-1:0]           a;
   reg   [DATA_WIDTH-1:0]           r;
   reg   [$clog2(DATA_WIDTH)-1:0]   i;
   wire  [DATA_WIDTH-1:0]           adder_q;
   wire  [DATA_WIDTH-1:0]           add_q;
   wire  [DATA_WIDTH-1:0]           sub_q;
   wire  [DATA_WIDTH-1:0]           div_q;
   wire  [DATA_WIDTH-1:0]           div_next;
   wire                             add_ovf;
   wire                             sub_ovf;
   wire                             adder_ovf;
   wire                             div_ovf;
   reg   [2:0]                      state;

   wire                             a_top;
   wire                             b_top;
   wire  [DATA_WIDTH-1:0]           m_i_a;
   wire  [DATA_WIDTH-1:0]           m_i_b;
   wire                             a_flip;
   wire                             b_flip;
   wire                             a_zero;
   wire                             b_zero;
   wire                             a_sign_ovf;
   wire                             b_sign_ovf;

   assign a_top         = i_a[DATA_WIDTH-1];
   assign b_top         = i_b[DATA_WIDTH-1];
   assign m_i_a         = -i_a;
   assign m_i_b         = -i_b;
   assign a_flip        = (i_a == m_i_a);
   assign b_flip        = (i_b == m_i_b);
   assign a_zero        = (i_a == 'd0);
   assign b_zero        = (i_b == 'd0);
   assign a_sign_ovf    = a_flip & ~a_zero;
   assign b_sign_ovf    = b_flip & ~b_zero;
   assign n_div_q_top   = ~div_q[DATA_WIDTH-1];    
   assign neg           = a_top ^ b_top;
   assign div_next      = {o_q[DATA_WIDTH-2:0], n_div_q_top};

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         state    <= SM_IDLE;
         adder_a  <= 'd0;
         adder_b  <= 'd0;
         o_q      <= 'd0;
         o_ovf    <= 'd0;
         o_accept <= 'd0;
         a        <= 'd0;
         r        <= 'd0;
      end else begin
         o_accept <= 1'b0;
         case(state)
            SM_IDLE:       case(1'b1)
                              i_add:   begin
                                          o_q      <= add_q;
                                          o_ovf    <= add_ovf; 
                                          o_accept <= 1'b1;   
                                       end
                              i_sub:   begin 
                                          o_accept <= 1'b1;
                                          o_q      <= sub_q;
                                          o_ovf    <= b_sign_ovf | sub_ovf;                                     
                                       end 
                              i_div,
                              i_mul:   begin
                                          i           <= 'd0;
                                          r           <= 'd0;   
                                          o_q         <= 'd0;
                                          adder_a     <= 'd0;
                                          if(a_sign_ovf | b_sign_ovf) begin
                                             o_accept <= 1'b1;
                                             o_ovf    <= 1'b1;
                                             state    <= SM_IDLE;
                                          end else begin
                                             if(i_mul)
                                                state <= SM_MUL;
                                             else
                                                state <= SM_DIV_R;
                                          end
                                          if(a_top)
                                             a        <= m_i_a;
                                          else
                                             a        <= i_a;
                                          if(b_top)
                                             adder_b  <= m_i_b;
                                          else
                                             adder_b  <= i_b;
                                       end                        
                           endcase 
            SM_MUL:        begin
                              a              <= a >> 1;
                              adder_b        <= adder_b << 1; 
                              if(a[0])
                                 adder_a     <= adder_q; 
                              if(a == 0)
                                 state       <= SM_MUL_DONE; 
                              else 
                                 if(adder_ovf | adder_b[DATA_WIDTH-1]) begin
                                    o_accept <= 1'b1;
                                    o_ovf    <= 1'b1;
                                    state    <= SM_IDLE;
                                 end
                      
                           end 
            SM_MUL_DONE:   begin
                              state <= SM_IDLE;
                              o_accept <= 1'b1;      
                              if(neg) 
                                 o_q   <= -adder_a;
                              else
                                 o_q   <= adder_a;
                           end
            SM_DIV_R:      begin
                              r     <= {r[DATA_WIDTH-2:0],a[DATA_WIDTH-1]}; 
                              a     <= a << 1;
                              state <= SM_DIV_CMP;
                           end
            SM_DIV_CMP:    begin
                              i <= i + 1;
                              if(n_div_q_top) 
                                 r     <= div_q;   
                              o_q   <= div_next;
                              if(i == DATA_WIDTH-1) begin
                                 o_accept <= 1'b1;
                                 state    <= SM_IDLE;
                                 if(neg) 
                                    o_q      <= -div_next;                              
                              end else begin
                                 state    <= SM_DIV_R; 
                              end
                           end  
         endcase
      end 
   end
   
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) adder (
      .i_a        (adder_a    ),
      .i_b        (adder_b    ),
      .o_q        (adder_q    ),
      .o_ovf      (adder_ovf  )
   );
 
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) add (
      .i_a        (i_a    ),
      .i_b        (i_b    ),
      .o_q        (add_q    ),
      .o_ovf      (add_ovf  )
   );

   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) sub (
      .i_a        (i_a      ),
      .i_b        (m_i_b    ),
      .o_q        (sub_q    ),
      .o_ovf      (sub_ovf  )
   );

   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) div (
      .i_a        (r),
      .i_b        (-adder_b),
      .o_q        (div_q    ),
      .o_ovf      (div_ovf  )
   );
     
endmodule
