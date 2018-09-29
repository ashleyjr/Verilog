module ram (
   input    wire           i_nrst,
   input    wire           i_wclk,
   input    wire     [8:0] i_waddr,
   input    wire           i_we,
   input    wire     [7:0] i_wdata,
   input    wire           i_rclk,
   input    wire     [8:0] i_raddr,
   input    wire           i_re,
   output   wire     [7:0] o_rdata
);

   reg   [7:0] wdata1;
   reg   [8:0] waddr1;
   reg         we1,we2;
   reg         re1,re2;
   wire        we;
   wire        re;

   assign   we = i_we | we1 | we2;

   assign   re = i_re | re1;

   always@(posedge i_wclk or negedge i_nrst) begin 
      if(!i_nrst) begin
         wdata1   <= 8'h00;
         waddr1   <= 9'h000;
         we1      <= 1'b0;
         we2      <= 1'b0;
         re1      <= 1'b0;
      end else begin
         wdata1   <= i_wdata;
         waddr1   <= i_waddr;
         we1      <= i_we;
         we2      <= we1;
         re1      <= i_re;
      end
   end 

   `ifdef SIM
      reg   [7:0] mem [511:0];
      reg   [7:0] s_rdata; 

      assign o_rdata = s_rdata;

      always@(posedge i_rclk) begin
         if(re)
            s_rdata <= mem[i_raddr];
         else 
            s_rdata <= 8'd0;
      end

      always@(posedge i_wclk) begin  
         if(we1)
            mem[waddr1] <= wdata1; 
      end
   `else
      wire  [15:0]   s_rdata;
      wire  [15:0]   s_wdata;

      assign o_rdata = {s_rdata[14],
                        s_rdata[12],
                        s_rdata[10],
                        s_rdata[8],
                        s_rdata[6],
                        s_rdata[4],
                        s_rdata[2],
                        s_rdata[0]};
      
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
                        wdata1[0]};

      // Configured in 512 x 8 
      SB_RAM40_4K #(
         .WRITE_MODE (32'sd1  ),
         .READ_MODE  (32'sd1  )
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

