`timescale 1ns/1ps

// Add, Subtract, Multiply, Divide 
// - Raise only one request line high at a time
// - o_accept raised high when finished
// - if o_ovf high with except the overflow error or i_b is divide by zero
// - Data width kept the same so multiplies restricted to half width at input

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
   output   reg                              o_accept 
);

   parameter      DATA_WIDTH  = 0;
   parameter      SM_IDLE     = 'd0; 
   parameter      SM_MUL      = 'd1;  
   parameter      SM_DIV_R    = 'd2;
   parameter      SM_DIV_CMP  = 'd3; 
    
   reg   [DATA_WIDTH-1:0]           div_mul_b;
   reg   [DATA_WIDTH-1:0]           a;
   reg   [DATA_WIDTH-1:0]           r;
   reg   [DATA_WIDTH-1:0]           i;
   wire  [DATA_WIDTH-1:0]           mul_q;
   wire  [DATA_WIDTH-1:0]           add_sub_q; 
   wire  [DATA_WIDTH-1:0]           div_q;
   wire  [DATA_WIDTH-1:0]           div_next;
   wire  [DATA_WIDTH-1:0]           add_sub_b;  
   wire                             mul_ovf;
   wire                             div_ovf;
   wire                             add_sub_ovf;

   reg   [1:0]                      state;

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
   assign a_flip        = a_top & m_i_a[DATA_WIDTH-1];
   assign b_flip        = b_top & m_i_b[DATA_WIDTH-1];
   assign a_zero        = ~(|i_a);
   assign b_zero        = ~(|i_b);
   assign a_sign_ovf    = a_flip & ~a_zero;
   assign b_sign_ovf    = b_flip & ~b_zero;
   assign n_div_q_top   = ~div_q[DATA_WIDTH-1];    
   assign neg           = a_top ^ b_top;
   assign div_next      = {o_q[DATA_WIDTH-2:0], n_div_q_top};
   assign add_sub_b     = (i_add) ? i_b : m_i_b; 

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         state    <= SM_IDLE;   
         o_ovf    <= 'd0;
         o_accept <= 'd0; 
      end else begin
         o_accept <= 1'b0;
         case(state)
            SM_IDLE:       case(1'b1)
                              // Simple signed adder for both
                              i_add,
                              i_sub:   begin 
                                          o_accept <= 1'b1;
                                          o_q      <= add_sub_q;
                                          o_ovf    <= add_sub_ovf | (b_sign_ovf & i_sub);                          
                                       end 
                              i_div,
                              i_mul:   begin
                                          i           <= 'd1;
                                          r           <= 'd0;   
                                          o_q         <= 'd0;
                                          if(a_sign_ovf | b_sign_ovf | (b_zero & i_div)) begin
                                             o_accept <= 1'b1;
                                             o_ovf    <= 1'b1; 
                                          end else begin
                                             if(i_mul)   state    <= SM_MUL;
                                             else        state    <= SM_DIV_R;
                                          end
                                          
                                          // Flip the signs when negative
                                          // Flipped back when finished
                                          if(a_top)   a           <= m_i_a;
                                          else        a           <= i_a;
                                          if(b_top)   div_mul_b   <= m_i_b;
                                          else        div_mul_b   <= i_b;
                                       end                        
                           endcase 
            // Shift and add unsigned multiplication https://en.wikipedia.org/wiki/Multiplication_algorithm
            SM_MUL:        begin
                              a           <= a >> 1;
                              div_mul_b   <= div_mul_b << 1;  
                              if(a[0]) 
                                 o_q      <= mul_q;  
                              if(~(|a[DATA_WIDTH-1:1])) begin
                                 state    <= SM_IDLE;
                                 o_accept <= 1'b1; 
                                 if(a[0] & neg) o_q <= -mul_q;
                              end  
                              if(mul_ovf | div_mul_b[DATA_WIDTH-1]) begin
                                 o_accept <= 1'b1;
                                 o_ovf    <= 1'b1;
                                 state    <= SM_IDLE; 
                              end
                           end  
            // Unisgned integer division  https://en.wikipedia.org/wiki/Division_algorithm
            SM_DIV_R:      begin
                              r     <= r << 1;                              
                              r[0]  <= a[DATA_WIDTH-1];
                              a     <= a << 1;
                              state <= SM_DIV_CMP;
                           end
            SM_DIV_CMP:    begin
                              // Shift register as counts synths better 
                              i     <= i << 1;
                              o_q   <= div_next;
                              if(n_div_q_top) 
                                 r  <= div_q;    
                              if(i[DATA_WIDTH-1]) begin
                                 o_accept <= 1'b1;
                                 state    <= SM_IDLE;
                                 if(neg) 
                                    o_q   <= -div_next;                              
                              end else begin
                                 state    <= SM_DIV_R; 
                              end
                           end  
         endcase
      end 
   end
   
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) add_sub (
      .i_a        (i_a        ),
      .i_b        (add_sub_b  ),
      .o_q        (add_sub_q  ),
      .o_ovf      (add_sub_ovf)
   );
   
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) mul (
      .i_a        (o_q        ),
      .i_b        (div_mul_b  ),
      .o_q        (mul_q      ),
      .o_ovf      (mul_ovf    )
   );
 
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) div (
      .i_a        (r          ),
      .i_b        (-div_mul_b ),
      .o_q        (div_q      ),
      .o_ovf      (div_ovf    )
   );
     
endmodule
