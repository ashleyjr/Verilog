`timescale 1ns/1ps
module ice_i2c(
	input	   wire        i_clk,
	input	   wire        i_nrst,
   // i2c side
	output   reg         o_scl,
	input	   wire        i_scl,
	output   wire        o_sda,
	input	   wire	      i_sda,
   // app side
   input    wire  [6:0] i_addr,
   input    wire  [7:0] i_data,
   output   wire  [7:0] o_data,
   input    wire        i_rnw,
   input    wire        i_valid,
   output   wire        o_accept
);

   parameter   TOP_COUNT   = 'd128;
   parameter   SM_IDLE     = 'd0;
   parameter   SM_START    = 'd1;
   parameter   SM_STOP_0   = 'd2;
   parameter   SM_ADDR_A   = 'd3;
   parameter   SM_DATA_A   = 'd4;
   parameter   SM_RW       = 'd5;
   parameter   SM_ADDR_6   = 'd6;
   parameter   SM_ADDR_5   = 'd7;
   parameter   SM_ADDR_4   = 'd8;
   parameter   SM_ADDR_3   = 'd9;
   parameter   SM_ADDR_2   = 'd10;
   parameter   SM_ADDR_1   = 'd11;
   parameter   SM_ADDR_0   = 'd12;
   parameter   SM_WDATA_7  = 'd13;
   parameter   SM_WDATA_6  = 'd14;
   parameter   SM_WDATA_5  = 'd15;
   parameter   SM_WDATA_4  = 'd16;
   parameter   SM_WDATA_3  = 'd17;
   parameter   SM_WDATA_2  = 'd18;
   parameter   SM_WDATA_1  = 'd19;
   parameter   SM_WDATA_0  = 'd20; 
   parameter   SM_RDATA_7  = 'd21;
   parameter   SM_RDATA_6  = 'd22;
   parameter   SM_RDATA_5  = 'd23;
   parameter   SM_RDATA_4  = 'd24;
   parameter   SM_RDATA_3  = 'd25;
   parameter   SM_RDATA_2  = 'd26;
   parameter   SM_RDATA_1  = 'd27;
   parameter   SM_RDATA_0  = 'd28;
   parameter   SM_STOP_1   = 'd29;
   
   
   reg   [5:0]                   state;
   reg   [5:0]                   next_state;
   
   reg   [$clog2(TOP_COUNT)-1:0] count;
   wire  [$clog2(TOP_COUNT)-1:0] next_count;
   wire                          clk_count;

   ///////////////////////////////////////////////////
   // State
  
   assign o_accept = top & (state == SM_STOP_1);

   assign o_sda = ~n_sda;

   assign n_sda = (state == SM_ADDR_6)  ? i_addr[6]:
                  (state == SM_ADDR_5)  ? i_addr[5]:
                  (state == SM_ADDR_4)  ? i_addr[4]:
                  (state == SM_ADDR_3)  ? i_addr[3]:
                  (state == SM_ADDR_2)  ? i_addr[2]:
                  (state == SM_ADDR_1)  ? i_addr[1]:
                  (state == SM_ADDR_0)  ? i_addr[0]:
                  (state == SM_WDATA_7) ? i_data[7]:
                  (state == SM_WDATA_6) ? i_data[6]:
                  (state == SM_WDATA_5) ? i_data[5]:
                  (state == SM_WDATA_4) ? i_data[4]:
                  (state == SM_WDATA_3) ? i_data[3]:
                  (state == SM_WDATA_2) ? i_data[2]:
                  (state == SM_WDATA_1) ? i_data[1]:
                  (state == SM_WDATA_0) ? i_data[0]:
                  (state == SM_RW)      ? i_rnw:
                  (state == SM_STOP_0)  ? 1'b0:
                  (state == SM_STOP_1)  ? 1'b0:
                  (state == SM_START)   ? 1'b0:
                                          1'b1;

   always@(*) begin
      next_state = state;
      if(i_valid)
         case(state)
            SM_IDLE:             next_state = SM_START;
            SM_START:   if(half) next_state = SM_ADDR_6;
            SM_ADDR_6:  if(top)  next_state = SM_ADDR_5; 
            SM_ADDR_5:  if(top)  next_state = SM_ADDR_4;
            SM_ADDR_4:  if(top)  next_state = SM_ADDR_3;
            SM_ADDR_3:  if(top)  next_state = SM_ADDR_2;                  
            SM_ADDR_2:  if(top)  next_state = SM_ADDR_1;                 
            SM_ADDR_1:  if(top)  next_state = SM_ADDR_0;                
            SM_ADDR_0:  if(top)  next_state = SM_RW;
            SM_RW:      if(top)  next_state = SM_ADDR_A;
            SM_ADDR_A:  if(top)
                           if(i_rnw)   next_state = SM_RDATA_7; 
                           else        next_state = SM_WDATA_7; 
            SM_WDATA_7: if(top)  next_state = SM_WDATA_6; 
            SM_WDATA_6: if(top)  next_state = SM_WDATA_5;
            SM_WDATA_5: if(top)  next_state = SM_WDATA_4;
            SM_WDATA_4: if(top)  next_state = SM_WDATA_3;                  
            SM_WDATA_3: if(top)  next_state = SM_WDATA_2;                 
            SM_WDATA_2: if(top)  next_state = SM_WDATA_1;                
            SM_WDATA_1: if(top)  next_state = SM_WDATA_0;                
            SM_WDATA_0: if(top)  next_state = SM_DATA_A;               
            SM_RDATA_7: if(top)  next_state = SM_RDATA_6; 
            SM_RDATA_6: if(top)  next_state = SM_RDATA_5;
            SM_RDATA_5: if(top)  next_state = SM_RDATA_4;
            SM_RDATA_4: if(top)  next_state = SM_RDATA_3;                  
            SM_RDATA_3: if(top)  next_state = SM_RDATA_2;                 
            SM_RDATA_2: if(top)  next_state = SM_RDATA_1;                
            SM_RDATA_1: if(top)  next_state = SM_RDATA_0;                
            SM_RDATA_0: if(top)  next_state = SM_DATA_A;
            SM_DATA_A:  if(top)  next_state = SM_STOP_0;
            SM_STOP_0:  if(top)  next_state = SM_STOP_1;
            SM_STOP_1:  if(top)  next_state = SM_IDLE;
         endcase
      else
         next_state = SM_IDLE; 
   end
   
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) state <= 'd0;
		else        state <= next_state;
	end
 
   ///////////////////////////////////////////////////
   // Divide clock
   
   assign next_count = (i_valid & ~top) ? (count + 'd1) : 'd0;
  
   assign top        = (count == (TOP_COUNT-1));

   assign half       = (count == (TOP_COUNT/2));

   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) count <= 'd0;
		else        count <= next_count;
	end
 
   always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst)             o_scl <= 1'b1;
		else 
         if(i_valid & ((half & (state != SM_STOP_1))|top))  
            o_scl <= ~o_scl;
   end
 

endmodule
