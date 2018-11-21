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
   output   wire                             o_zero,
   output   reg                              o_accept 
);

   parameter   DATA_WIDTH  = 0;
   parameter   SM_IDLE     = 3'd0; 
   parameter   SM_SIGN_B   = 3'd1;
   parameter   SM_SIGN_Q   = 3'd2;
   parameter   SM_MUL      = 3'd3;
   parameter   SM_DIV_R    = 3'd4;
   parameter   SM_DIV_CMP  = 3'd5;
   parameter   SM_DIV_CNT  = 3'd6;

   reg   [DATA_WIDTH-1:0]           a;
   reg   [DATA_WIDTH-1:0]           b;
   reg   [DATA_WIDTH-1:0]           r;
   reg   [$clog2(DATA_WIDTH)-1:0]   i;
   wire                             a_top;
   wire                             b_top;
   wire                             sm_idle;
   wire                             sm_mul;
   wire                             mul_neg;
   wire                             az;
   reg   [2:0]                      state;
   wire  [2:0]                      sm_mul_div_next;


   assign   a_top             = i_a[DATA_WIDTH-1];
   assign   b_top             = i_b[DATA_WIDTH-1];
   assign   n_adder_q_top     = ~adder_q[DATA_WIDTH-1];
   assign   mul_neg           = a_top ^ b_top; 
   assign   sm_mul            = (state == SM_MUL);
   assign   sm_idle           = (state == SM_IDLE);
   assign   sm_idle_mul       = (sm_idle & i_mul);
   assign   sm_mul_div_next   = (i_mul)   ? SM_MUL : SM_DIV_R;
   assign   az                = (a[DATA_WIDTH-1:1] == 'd0);
   assign   o_zero            = i_div & (i_b == 'd0);

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         o_q      <= 'd0;
         a        <= 'd0;
         b        <= 'd0;
         i        <= 'd0;
         r        <= 'd0;
         o_accept <= 1'b0;
         state    <= SM_IDLE;
      end else begin
         o_accept <= 1'b0;
         o_ovf    <= 1'b0;
         case(state)
            SM_IDLE:    case(1'b1)
                           i_add:   begin     
                                       o_q      <= adder_q;
                                       o_accept <= 1'b1;
                                       o_ovf    <= adder_ovf;
                                    end
                           i_sub:   begin
                                       if((adder_b == i_b) && (i_b != 0)) begin
                                          o_accept <= 1'b1;
                                          o_ovf    <= 1'b1;
                                       end else begin
                                          o_q      <= adder_q;
                                          o_accept <= 1'b1;
                                          o_ovf    <= adder_ovf;
                                       end
                                    end
                           i_mul,
                           i_div:   begin
                                       r     <= 'd0;
                                       o_q   <= 'd0;
                                       a     <= i_a;
                                       b     <= i_b;
                                       state <= sm_mul_div_next;
                                       i     <= DATA_WIDTH-1;
                                       case({a_top, b_top}) 
                                          2'b01:   b <= adder_q;
                                          2'b10:   a <= adder_q;    
                                          2'b11:   begin
                                                      a     <= adder_q;
                                                      state <= SM_SIGN_B;
                                                   end
                                       endcase
                                       if(adder_ovf) begin
                                          o_accept <= 1'b1;
                                          o_ovf    <= 1'b1;
                                          state    <= SM_IDLE;
                                       end
                                    end
                              
                        endcase
            SM_SIGN_B:  begin
                           b     <= adder_q;
                           state <= sm_mul_div_next;
                           if(adder_ovf) begin
                              o_accept <= 1'b1;
                              o_ovf    <= 1'b1;
                              state    <= SM_IDLE;
                           end
                        end
            SM_SIGN_Q:  begin
                           o_q      <= adder_q;
                           o_accept <= 1'b1;
                           state    <= SM_IDLE;
                        end
            SM_MUL:     begin
                           a <= a >> 1;
                           b <= b << 1;
                           if(adder_ovf | b[DATA_WIDTH-1]) begin
                              o_accept <= 1'b1;
                              o_ovf    <= 1'b1;
                              state    <= SM_IDLE;
                           end else begin
                              if(a[0])
                                 o_q   <= adder_q; 
                              if(az) begin
                                 if(mul_neg) begin
                                    state    <= SM_SIGN_Q;
                                 end else begin
                                    o_accept <= 1'b1;
                                    state    <= SM_IDLE;
                                 end
                              end
                           end
                           
                        end
            SM_DIV_R:   begin
                           r     <= {r[DATA_WIDTH-2:0],a[i]}; 
                           state <= SM_DIV_CMP;
                        end
            SM_DIV_CMP: begin
                           if(n_adder_q_top) begin
                              r        <= adder_q;
                              o_q[i]   <= 1'b1;
                           end
                           state    <= SM_DIV_CNT;
                        end 
            SM_DIV_CNT: if(i == 'd0) begin
                           i        <= 'd0; 
                           if(mul_neg)
                              state    <= SM_SIGN_Q;
                           else begin
                              state    <= SM_IDLE;
                              o_accept <= 1'b1;
                           end
                        end else begin
                           i     <= adder_q;
                           state <= SM_DIV_R;
                        end 
         endcase
      end
   end 
  


   /////////////////////////////////////////////////////////////////////////
   // Adder
   wire  signed   [DATA_WIDTH-1:0]  adder_a;
   wire  signed   [DATA_WIDTH-1:0]  adder_b;
   wire  signed   [DATA_WIDTH-1:0]  adder_q; 
   wire                             adder_ovf;

   assign adder_a =  (state == SM_SIGN_B)             ? 'd1 :
                     (state == SM_SIGN_Q)             ?  ~o_q  :
                     (state == SM_DIV_CMP)             ?  r  :
                     (sm_idle & i_div & a_top)        ?  ~i_a  : 
                     (sm_idle & i_div & b_top)        ?  'd1  : 
                     (state == SM_DIV_CNT)            ?  i   :
                     (sm_idle_mul & a_top)            ?  ~i_a  : 
                     (sm_idle_mul & b_top)            ?  'd1   :
                     (sm_idle)                        ?  i_a   :
                     (sm_mul)                         ?  o_q   :
                                                         'd1; 
   
   assign adder_b =  (state == SM_SIGN_B)          ? ~i_b :
                     (state == SM_DIV_CMP)             ?  -b  :
                     (sm_idle & i_div & a_top)        ?  'd1   : 
                     (sm_idle & i_div & b_top)        ?  ~i_b   :
                     (state == SM_DIV_CNT)            ?  -'d1   :
                     (i_add)                          ?  i_b   :
                     (i_sub)                          ?  -i_b  : 
                     ((sm_idle_mul & a_top) || (state == SM_SIGN_Q) )            ?  'd1   :
                     (sm_mul)                         ? b      :
                                                         ~i_b;
   adder #(
      .DATA_WIDTH (DATA_WIDTH )
   ) adder (
      .i_a        (adder_a    ),
      .i_b        (adder_b    ),
      .o_q        (adder_q    ),
      .o_ovf      (adder_ovf  )
   );
   
endmodule
