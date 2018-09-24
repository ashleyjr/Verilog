module ram (
   input    wire           i_wclk,
   input    wire     [8:0] i_waddr,
   input    wire           i_we,
   input    wire     [7:0] i_wdata,
   input    wire           i_rclk,
   input    wire     [8:0] i_raddr,
   input    wire           i_re,
   output   wire     [7:0] o_rdata
);

  
   `ifdef SIM
      reg   [7:0] mem [511:0];
      reg   [7:0] s_rdata;
      
      assign o_rdata = s_rdata;

      always@(posedge i_rclk) begin
         if(i_re)
            s_rdata <= mem[i_raddr];
         else 
            s_rdata <= 8'd0;
      end

      always@(posedge i_wclk) begin
         if(i_we)
            mem[i_waddr] <= i_wdata;
      end
   `else
      // Configured in 512 x 8 
      SB_RAM40_4K #(
         .WRITE_MODE (2'b1    ),
         .READ_MODE  (2'b1    )
      ) ram (
         .RDATA      (o_rdata ),
         .RADDR      (i_raddr ),
         .RCLK       (i_rclk  ),
         .RCLKE      (i_re    ),
         .RE         (i_re    ),
         .WADDR      (i_waddr ),
         .WCLK       (i_wclk  ),
         .WCLKE      (i_we    ),
         .WDATA      (i_wdata ),
         .WE         (i_we    ),
         .MASK       (16'b0   )
      );
   `endif

endmodule

