`timescale 1ns/1ps
module spi_sram_23k256(
	input				         i_clk,
	input				         i_nrst,
   // App side
	input    wire  [14:0]   i_addr,
	input	   wire  [7:0]    i_data,
   output   wire  [7:0]    o_data,
   input    wire           i_rnw,
   input    wire           i_valid,
   output                  o_accept,
   // Component side
   output   reg            o_sck,
   output                  o_ncs,
   output   wire           o_s,
   input                   i_s
);
   parameter   CLK_DIV     = 7;

   parameter   SM_START = 'd0;
   parameter   SM_IDLE  = 'd1;
   parameter   SM_INSTR = 'd2;
   parameter   SM_ADDR  = 'd3;
   parameter   SM_DATA  = 'd4;
   parameter   SM_DATA0 = 'd5;
   parameter   SM_END   = 'd6;

   reg   [3:0]                   c;
   wire  [3:0]                   c_next;
   wire                          c_0;  
   wire                          c_6;  
   wire                          c_7;
   wire                          c_9;
   wire                          c_15;
   reg   [7:0]                   s_data;
   reg   [7:0]                   s_data_next;
   reg   [14:0]                  s_addr;
   reg   [14:0]                  s_addr_next;
   reg   [5:0]                   state;
   reg   [5:0]                   next_state;
   reg   [$clog2(CLK_DIV)-1:0]   count;
   wire  [$clog2(CLK_DIV)-1:0]   next_count;
   wire                          sck_edge;
   wire                          n_sck;
   wire                          plus_one;

   // Clock generator
   
   assign next_count = ((state == SM_IDLE) | sck_edge) ? 'd0 : count + 'd1;
   
   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)    count <= 1'b0;
      else           count <= next_count; 
   end

   assign sck_edge = (count == CLK_DIV);

   assign n_sck = ~o_sck;

   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)       o_sck <= 1'b0;
      else if(sck_edge) o_sck <= n_sck; 
   end

   assign sck_fall = o_sck & ~n_sck & sck_edge;

   // Shift regs 
   always @(*) begin
      s_data_next = s_data;
      case(state)
         SM_IDLE:    if(i_valid)             s_data_next = i_data;
         SM_DATA:    if(sck_fall)            s_data_next = {s_data[6:0],i_s};
         SM_DATA0:   if(sck_fall & i_valid)  s_data_next = i_data;
      endcase
   end

   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) s_data <= 'd0;
      else        s_data <= s_data_next; 
   end

   always @(*) begin
      s_addr_next = s_addr;
      case(state)
         SM_IDLE:    if(i_valid)             s_addr_next = i_addr;
         SM_ADDR:    if(sck_fall & ~c_0)     s_addr_next = {s_addr[13:0],s_addr[14]};
         SM_DATA0:   if(sck_fall & i_valid)  s_addr_next = i_addr;
      endcase
   end

   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) s_addr <= 'd0;
      else        s_addr <= s_addr_next; 
   end

   assign plus_one = ((s_addr + 'd1) == i_addr);

   // Counter
   assign c_0  =  (c == 'd0); 
   assign c_6  =  (c == 'd6); 
   assign c_7  =  (c == 'd7);
   assign c_9  =  (c == 'd9);
   assign c_15 =  (c == 'd15);

   assign c_next = ( ((state == SM_INSTR) & c_7)  |  
                     ((state == SM_ADDR)  & c_15) |
                      (state == SM_DATA0)         |
                      (state == SM_END)           |
                      (state == SM_IDLE)
                   ) ? 'd0 : (c + 'd1); 
                                              
   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)       c <= 'd0;
      else if(sck_fall) c <= c_next; 
   end


   // State machine
   always @(*) begin
      next_state = state;
      case(state)
         SM_START:   if(c_15)    next_state = SM_END;
         SM_IDLE:    if(i_valid) next_state = SM_INSTR;
         SM_INSTR:   if(c_7)     next_state = SM_ADDR;
         SM_ADDR:    if(c_15)    next_state = SM_DATA;
         SM_DATA:    if(c_6)     next_state = SM_DATA0;
         SM_DATA0:   if(i_valid & plus_one)
                        next_state = SM_DATA;
                     else
                        next_state = SM_END;
         SM_END:     next_state = SM_IDLE;
      endcase
   end

   always @(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst)                            state <= SM_START;
      else if(sck_fall | (state == SM_IDLE)) state <= next_state; 
   end

   // Drive SPI
   assign o_ncs      =  (state == SM_IDLE) |
                        (state == SM_END)  |
                        ((state == SM_START) & c_0);

   assign o_s        =  ((state == SM_START) & c_7) | 
                        ((state == SM_START) & c_9) | 
                        ((state == SM_INSTR) & c_6) | 
                        ((state == SM_INSTR) & c_7 & i_rnw) | 
                        (
                           ((state == SM_ADDR) & ~c_0)   ?  s_addr[14]  :
                           (state == SM_DATA)            ?  s_data[7]   :
                                                            1'b0
                        );
   // Drive APP
   assign o_accept   = (state == SM_IDLE) & i_valid;

   assign o_data     = s_data;

endmodule
