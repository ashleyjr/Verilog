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
   parameter      SM_ADD      = 'd1; 
   parameter      SM_SUB      = 'd2; 
   parameter      SM_DIV      = 'd3; 
   parameter      SM_MUL      = 'd4; 
   parameter      SM_MUL_DONE = 'd5;

   reg   [DATA_WIDTH-1:0]           adder_a;
   reg   [DATA_WIDTH-1:0]           adder_b;
   reg   [DATA_WIDTH-1:0]           a;
   wire  [DATA_WIDTH-1:0]           adder_q;
   wire                             adder_ovf;
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

   assign a_top      = i_a[DATA_WIDTH-1];
   assign b_top      = i_b[DATA_WIDTH-1];
   assign m_i_a      = -i_a;
   assign m_i_b      = -i_b;
   assign a_flip     = (i_a == m_i_a);
   assign b_flip     = (i_b == m_i_b);
   assign a_zero     = (i_a == 'd0);
   assign b_zero     = (i_b == 'd0);
   assign a_sign_ovf = a_flip & ~a_zero;
   assign b_sign_ovf = b_flip & ~b_zero;


   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         state    <= SM_IDLE;
         adder_a  <= 'd0;
         adder_b  <= 'd0;
         o_q      <= 'd0;
         o_ovf    <= 'd0;
         o_accept <= 'd0;
      end else begin
         o_accept <= 1'b0;
         case(state)
            SM_IDLE:       case(1'b1)
                              i_add:   begin
                                          adder_a  <= i_a;
                                          adder_b  <= i_b;
                                          state    <= SM_ADD;
                                       end
                              i_sub:   begin
                                          adder_a  <= i_a;
                                          if(b_sign_ovf) begin
                                             o_ovf    <= 1'b1;
                                             o_accept <= 1'b1;
                                          end else begin
                                             state    <= SM_SUB;
                                             adder_b  <= m_i_b;
                                          end                                     
                                       end 
                              i_mul:   begin
                                          o_q      <= 'd0;
                                          adder_a  <= 'd0;
                                          state    <= SM_MUL;
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
            SM_ADD:        begin
                              state    <= SM_IDLE;
                              o_q      <= adder_q;
                              o_ovf    <= adder_ovf;
                              o_accept <= 1'b1;
                           end 
            SM_SUB:        begin
                              state    <= SM_IDLE;
                              o_q      <= adder_q;
                              o_ovf    <= adder_ovf;
                              o_accept <= 1'b1;
                           end 
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
                              if(a_top ^ b_top) 
                                 o_q   <= -adder_a;
                              else
                                 o_q   <= adder_a;
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
 
   //parameter   DATA_WIDTH  = 0;
   //parameter   SM_IDLE     = 3'd0; 
   //parameter   SM_SIGN_B   = 3'd1;
   //parameter   SM_SIGN_Q   = 3'd2;
   //parameter   SM_MUL      = 3'd3;
   //parameter   SM_DIV_R    = 3'd4;
   //parameter   SM_DIV_CMP  = 3'd5;
   //parameter   SM_DIV_CNT  = 3'd6;

   //reg   [DATA_WIDTH-1:0]           adder_a;
   //reg   [DATA_WIDTH-1:0]           adder_b;
   //reg   [DATA_WIDTH-1:0]           r;
   //reg   [$clog2(DATA_WIDTH)-1:0]   i;
   //wire                             a_top;
   //wire                             b_top;
   //wire                             sm_idle;
   //wire                             sm_mul;
   //wire                             mul_neg;
   //wire                             az;
   //wire                             zero;
   //reg   [2:0]                      state;
   //wire  [2:0]                      sm_mul_div_next;


   //assign   a_top             = i_a[DATA_WIDTH-1];
   //assign   b_top             = i_b[DATA_WIDTH-1];
   //assign   n_adder_q_top     = ~adder_q[DATA_WIDTH-1];
   //assign   mul_neg           = a_top ^ b_top; 
   //assign   sm_mul            = (state == SM_MUL);
   //assign   sm_idle           = (state == SM_IDLE);
   //assign   sm_sign_b         = (state == SM_SIGN_B);
   //assign   sm_sign_q         = (state == SM_SIGN_Q);
   //assign   sm_div_cnt        = (state == SM_DIV_CNT);
   //assign   sm_div_cmp        = (state == SM_DIV_CMP);
   //assign   sm_idle_mul       = (sm_idle & i_mul);
   //assign   sm_idle_mul_a     = (sm_idle_mul & a_top);
   //assign   sm_idle_mul_b     = (sm_idle_mul & ~a_top & b_top);
   //assign   sm_idle_div       = (sm_idle & i_div);
   //assign   sm_idle_div_a     = (sm_idle_div & a_top);
   //assign   sm_idle_div_b     = (sm_idle_div & ~a_top & b_top);
   //assign   sm_mul_div_next   = (i_mul)   ? SM_MUL : SM_DIV_R;
   //assign   az                = (a[DATA_WIDTH-1:1] == 'd0);
   //assign   zero              = i_div & (i_b == 'd0);

   //always@(posedge i_clk or negedge i_nrst) begin
   //   if(!i_nrst) begin
   //      o_q      <= 'd0;
   //      a        <= 'd0;
   //      b        <= 'd0;
   //      i        <= 'd0;
   //      r        <= 'd0;
   //      o_accept <= 1'b0;
   //      state    <= SM_IDLE;
   //   end else begin
   //      o_accept <= 1'b0;
   //      o_ovf    <= 1'b0;
   //      o_zero   <= 1'b0;
   //      case(state)
   //         SM_IDLE:    case(1'b1)
   //                        i_add:   begin     
   //                                    o_q      <= adder_q;
   //                                    o_accept <= 1'b1;
   //                                    o_ovf    <= adder_ovf;
   //                                 end
   //                        i_sub:   begin
   //                                    if((adder_b == i_b) && (i_b != 0)) begin
   //                                       o_accept <= 1'b1;
   //                                       o_ovf    <= 1'b1;
   //                                    end else begin
   //                                       o_q      <= adder_q;
   //                                       o_accept <= 1'b1;
   //                                       o_ovf    <= adder_ovf;
   //                                    end
   //                                 end
   //                        i_mul,
   //                        i_div:   begin
   //                                    r     <= 'd0;
   //                                    o_q   <= 'd0;
   //                                    a     <= i_a;
   //                                    b     <= i_b;
   //                                    state <= sm_mul_div_next; 
   //                                    case({a_top, b_top}) 
   //                                       2'b01:   b <= adder_q;
   //                                       2'b10:   a <= adder_q;    
   //                                       2'b11:   begin
   //                                                   a     <= adder_q;
   //                                                   state <= SM_SIGN_B;
   //                                                end
   //                                    endcase
   //                                    if(adder_ovf | zero) begin
   //                                       o_accept <= 1'b1;
   //                                       o_zero   <= 1'b1;
   //                                       o_ovf    <= 1'b1;
   //                                       state    <= SM_IDLE;
   //                                    end 
   //                                 end
   //                           
   //                     endcase
   //         SM_SIGN_B:  begin
   //                        b     <= adder_q;
   //                        state <= sm_mul_div_next;
   //                        if(adder_ovf) begin
   //                           o_accept <= 1'b1;
   //                           o_ovf    <= 1'b1;
   //                           state    <= SM_IDLE;
   //                        end
   //                     end
   //         SM_SIGN_Q:  begin
   //                        o_q      <= adder_q;
   //                        o_accept <= 1'b1;
   //                        state    <= SM_IDLE;
   //                     end
   //         SM_MUL:     begin
   //                        a <= a >> 1;
   //                        b <= b << 1;
   //                        if(adder_ovf | b[DATA_WIDTH-1]) begin
   //                           o_accept <= 1'b1;
   //                           o_ovf    <= 1'b1;
   //                           state    <= SM_IDLE;
   //                        end else begin
   //                           if(a[0])
   //                              o_q   <= adder_q; 
   //                           if(az) begin
   //                              if(mul_neg) begin
   //                                 state    <= SM_SIGN_Q;
   //                              end else begin
   //                                 o_accept <= 1'b1;
   //                                 state    <= SM_IDLE;
   //                              end
   //                           end
   //                        end
   //                        
   //                     end
   //         SM_DIV_R:   begin
   //                        r     <= {r[DATA_WIDTH-2:0],a[DATA_WIDTH-1]}; 
   //                        a     <= a << 1;
   //                        state <= SM_DIV_CMP;
   //                     end
   //         SM_DIV_CMP: begin
   //                        if(n_adder_q_top) 
   //                           r     <= adder_q; 
   //                        o_q      <= {o_q[DATA_WIDTH-2:0], n_adder_q_top};
   //                        state    <= SM_DIV_CNT;
   //                     end 
   //         SM_DIV_CNT: if(i == DATA_WIDTH-1) begin 
   //                        i <= 'd0;
   //                        if(mul_neg)
   //                           state    <= SM_SIGN_Q;
   //                        else begin
   //                           state    <= SM_IDLE;
   //                           o_accept <= 1'b1;
   //                        end
   //                     end else begin
   //                        i     <= adder_q;
   //                        state <= SM_DIV_R;
   //                     end 
   //      endcase
   //   end
   //end 
  


   /////////////////////////////////////////////////////////////////////////
   // Adder
   //reg   signed   [DATA_WIDTH-1:0]  p_adder_a;
   //wire  signed   [DATA_WIDTH-1:0]  n_adder_a;
   //wire  signed   [DATA_WIDTH-1:0]  adder_a;
   //reg   signed   [DATA_WIDTH-1:0]  p_adder_b;
   //wire  signed   [DATA_WIDTH-1:0]  n_adder_b;
   //wire  signed   [DATA_WIDTH-1:0]  adder_b;
   //wire  signed   [DATA_WIDTH-1:0]  adder_q; 
   //wire                             adder_ovf;

   //always@(*) begin
   //   case(1'b1)
   //      sm_sign_q,    
   //      sm_mul:           p_adder_a = o_q;
   //      sm_div_cmp:       p_adder_a = r;
   //      sm_div_cnt:       p_adder_a = i; 
   //      sm_sign_b,    
   //      sm_idle_div_b,
   //      sm_idle_mul_b:    p_adder_a  = 'd1;
   //      sm_idle_div_a,
   //      sm_idle_mul_a,
   //      sm_idle_mul,
   //      sm_idle_div,
   //      i_add,
   //      i_sub:            p_adder_a = i_a;
   //      default:          p_adder_a = 'd0;
   //   endcase

   //   case(1'b1) 
   //      sm_sign_b,
   //      i_add:            p_adder_b = i_b;
   //      sm_div_cmp:       p_adder_b = -b;
   //      sm_idle_div_a,
   //      sm_div_cnt,
   //      sm_idle_mul_a,
   //      sm_sign_q:        p_adder_b = 'd1; 
   //      i_sub:            p_adder_b = -i_b;
   //      sm_mul:           p_adder_b = b;
   //      sm_idle_div_b,
   //      sm_idle_mul_b,
   //      sm_idle_mul,
   //      sm_idle_div:      p_adder_b = ~i_b;
   //   endcase
   //end
   //
   //assign n_adder_a  = ~p_adder_a; 
   //assign n_adder_b  = ~p_adder_b;
   //assign adder_a    = (   sm_sign_q      | 
   //                        sm_idle_div_a  |
   //                        sm_idle_mul_a  ) ?   n_adder_a:
   //                                             p_adder_a;
   //assign adder_b    = (   sm_sign_b      ) ?   n_adder_b: 
   //                                             p_adder_b;
   
   //adder #(
   //   .DATA_WIDTH (DATA_WIDTH )
   //) adder (
   //   .i_a        (adder_a    ),
   //   .i_b        (adder_b    ),
   //   .o_q        (adder_q    ),
   //   .o_ovf      (adder_ovf  )
   //);
   
endmodule
