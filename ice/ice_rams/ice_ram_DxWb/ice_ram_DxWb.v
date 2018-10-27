`timescale 1ns/1ps
module ice_ram_DxWb (
   input    wire                       i_nrst,
   input    wire                       i_wclk,
   input    wire     [$clog2(pD)-1:0]  i_waddr,
   input    wire                       i_we,
   input    wire     [pW-1:0]          i_wdata,
   input    wire                       i_rclk,
   input    wire     [$clog2(pD)-1:0]  i_raddr,
   input    wire                       i_re,
   output   wire     [pW-1:0]          o_rdata
);

   parameter   pD    = 1;
   parameter   pW    = 1;
   parameter   pMODE = 1; 

   reg   [pW-1:0]          wdata1;
   reg   [$clog2(pD)-1:0]  waddr1;
   reg                     we1;
   reg                     re1,re2;
   wire                    we;
   wire                    re;

   assign   we = i_we | we1 ;

   assign   re = i_re | re1;

   always@(posedge i_wclk or negedge i_nrst) begin 
      if(!i_nrst) begin
         wdata1   <= 'd0;
         waddr1   <= 'd0;
         we1      <= 'd0; 
         re1      <= 'd0;
      end else begin
         wdata1   <= i_wdata;
         waddr1   <= i_waddr;
         we1      <= i_we; 
         re1      <= i_re;
      end
   end 

   `ifdef SIM
      reg   [pW-1:0] mem       [pD-1:0];
      reg   [pW-1:0] s_rdata; 

      assign o_rdata = s_rdata;

      always@(posedge i_rclk) begin
         if(re)
            s_rdata <= mem[i_raddr];
         else 
            s_rdata <= 'd0;
      end

      always@(posedge i_wclk) begin  
         if(we1)
            mem[waddr1] <= wdata1; 
      end
   `else
      wire  [15:0]   s_rdata;
      wire  [15:0]   s_wdata;

      generate
         // Width 16
         if (pMODE == 32'sd0) begin
            assign o_rdata = s_rdata;      
            assign s_wdata = wdata1; 
         end
         // Width 8
         else if (pMODE == 32'sd1) begin
            assign o_rdata = {s_rdata[14],
                              s_rdata[12],
                              s_rdata[10],
                              s_rdata[8],
                              s_rdata[6],
                              s_rdata[4],
                              s_rdata[2],
                              s_rdata[0]  }; 
            assign s_wdata = {1'bx,
                              wdata1[7],
                              1'bx,
                              wdata1[6],
                              1'bx,
                              wdata1[5],
                              1'bx,
                              wdata1[4],
                              1'bx,
                              wdata1[3],
                              1'bx,
                              wdata1[2],
                              1'bx,
                              wdata1[1],
                              1'bx,
                              wdata1[0] };
         end
         // Width 4
         else if (pMODE == 32'sd2) begin
            assign o_rdata = {s_rdata[13],
                              s_rdata[9],
                              s_rdata[5],
                              s_rdata[1]  };  
            assign s_wdata = {2'bxx,
                              wdata1[3],
                              2'bxx,
                              wdata1[2],
                              2'bxx,
                              wdata1[1],
                              2'bxx,
                              wdata1[0],
                              1'bx,
                              wdata1[3],
                              1'bx,
                              wdata1[2],
                              1'bx,
                              wdata1[1],
                              1'bx,
                              wdata1[0] };
         end
         // Width 2
         else if (pMODE == 32'sd3) begin
            assign o_rdata = {s_rdata[11],
                              s_rdata[3]};
            assign s_wdata = {4'bxxxx,
                              wdata1[1],              
                              7'bxxxxxxx,
                              wdata1[0],               
                              3'bxxx   };
         end
      endgenerate

      SB_RAM40_4K #(
         .WRITE_MODE (pMODE),
         .READ_MODE  (pMODE)
      ) ram (
         .MASK       (16'hxxxx),
         .RDATA      (s_rdata ),
         .RADDR      (i_raddr ),
         .RCLK       (i_rclk  ),
         .RCLKE      (1'b1    ),
         .RE         (re      ),
         .WADDR      (waddr1  ),
         .WCLK       (i_wclk  ),
         .WCLKE      (1'b1    ),
         .WDATA      (s_wdata ),
         .WE         (we      )
      );
   `endif

endmodule

