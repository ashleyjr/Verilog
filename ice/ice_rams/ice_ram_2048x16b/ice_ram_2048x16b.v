`timescale 1ns/1ps
module ice_ram_2048x16b(
   input    wire              i_nrst,
   input    wire              i_wclk,
   input    wire     [10:0]   i_waddr,
   input    wire              i_we,
   input    wire     [15:0]   i_wdata,
   input    wire              i_rclk,
   input    wire     [10:0]   i_raddr,
   input    wire              i_re,
   output   wire     [15:0]   o_rdata
);

   wire  [1:0]    o_rdata7,
                  o_rdata6,
                  o_rdata5,
                  o_rdata4, 
                  o_rdata3,
                  o_rdata2,
                  o_rdata1,
                  o_rdata0;

   assign o_rdata = {o_rdata7,
                     o_rdata6,
                     o_rdata5,
                     o_rdata4,
                     o_rdata3,
                     o_rdata2,
                     o_rdata1,
                     o_rdata0};
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram7 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[15:14]),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata7      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram6 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[13:12]),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata6      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram5 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[11:10]),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata5      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram4 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[9:8]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata4      )
   );


   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram3 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[7:6]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata3      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram2 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[5:4]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata2      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram1 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[3:2]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata1      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram0 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[1:0]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata0      )
   );

endmodule
