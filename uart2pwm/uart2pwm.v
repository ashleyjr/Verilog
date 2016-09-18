`timescale 1ns/1ps
module uart2pwm(
	input				clk,
	input				nRst,
   input          rx,	
	output   [4:0] pwm,
   output         tx
);

   parameter   WAIT     = 8'h00,
               PERIOD   = 8'h01,
               DUTY     = 8'h02;
   
   reg   [7:0] state;
   reg   [6:0] addr;
   reg   [4:0] set_compare8; 
   reg         set_clk_div8;
   reg   [7:0] div;

   wire        clk_div;
   wire  [7:0] data_rx;
   wire  [7:0] cmp;
   wire        recieved;

   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state          <= WAIT;
         set_compare8   <= 5'd0;
      end else begin
         if(recieved)
            casex({state,data_rx[7]})
               {WAIT,1'b1}:   begin
                                 state <= PERIOD;
                                 addr <= data_rx[6:0];
                              end
               {WAIT,1'b0}:   begin
                                 state <= DUTY;
                                 addr <= data_rx[6:0];
                              end
               {PERIOD,1'bX}: begin
                                 state <= WAIT;
                              end
               {DUTY,1'bX}:   begin
                                 state                <= WAIT;
                                 set_compare8[addr]   <= 1'b1;
                              end
            endcase
      end
   end

   uart_autobaud uart_autobaud(
            .clk        (clk              ),
            .nRst       (nRst             ),
            .transmit   (recieved         ),
            .data_tx    (data_rx          ),
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
