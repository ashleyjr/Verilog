`timescale 1ns/1ps
module uart2pwm(
	input				clk,
	input				nRst,
   input          rx,	
	output   [4:0] pwm,
   output         tx
);

   parameter   CMD_PERIOD        = 8'hAA,
               CMD_DUTY          = 8'hBB,
               SM_WAIT           = 8'h00,
               SM_PERIOD_ADDR    = 8'h01,
               SM_PERIOD_SET     = 8'h02,
               SM_DUTY_ADDR      = 8'h03,
               SM_DUTY_SET       = 8'h04;
   
   reg   [7:0] state;
   reg   [7:0] addr;
   reg   [4:0] set_compare8; 
   reg         set_clk_div8;
   reg   [7:0] div;

   wire        clk_div;
   wire  [7:0] data_rx;
   wire  [7:0] cmp;
   wire        recieved;
   wire  [7:0] data_tx;

   assign data_tx = 
      (state == SM_WAIT       ) ? data_rx + 1  :
      (state == SM_DUTY_ADDR  ) ? data_rx + 2  :
                                 data_rx + 3;



   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state          <= SM_WAIT;
         addr           <= 8'h00;
         set_compare8   <= 5'd0;
      end else begin
         if(recieved) begin
            casex({state,data_rx})
               {SM_WAIT,CMD_DUTY}:        begin
                                             state                <= SM_DUTY_ADDR;
                                          end
               {SM_DUTY_ADDR,8'hXX}:      begin
                                             addr                 <= data_rx;
                                             state                <= SM_DUTY_SET;
                                          end
               {SM_DUTY_SET,8'hXX}:       begin
                                             set_compare8[addr]   <= 1'b1;
                                             state                <= SM_WAIT;
                                          end
            endcase
         end else begin
            set_compare8 <= 5'd0;
         end
      end
   end

   uart_autobaud uart_autobaud(
            .clk        (clk              ),
            .nRst       (nRst             ),
            .transmit   (recieved         ),
            .data_tx    (data_tx          ),
            .rx         (rx               ),
            .busy_tx    (                 ),
            .busy_tx    (                 ),
            .recieved   (recieved         ),
            .data_rx    (data_rx          ),
            .tx         (tx               )
   );

   clk_div8 clk_div8(
            .clk        (clk              ),
            .nRst       (nRst             ),
            .div        (div              ),
            .set        (set_clk_div8     ),
            .clk_div    (clk_div          )
   );

   counter8 counter8(
            .clk        (clk_div          ),
            .nRst       (nRst             ),
            .count      (cmp              )
   );

   genvar i;
   generate
      for(i=0;i<5;i=i+1) begin
         compare8 compare8(
            .clk        (clk              ),
            .nRst       (nRst             ),
            .set        (set_compare8[i]  ),
            .cmp_static (data_rx          ),
            .cmp        (cmp              ),
            .out        (pwm[i]           )
         );
      end
   endgenerate

endmodule
