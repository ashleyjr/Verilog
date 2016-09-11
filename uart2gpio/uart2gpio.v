`timescale 1ns/1ps
module uart2gpio(
	input                   clk,
	input                   nRst,
	input                   rx,	
	output                  tx,
   output   reg   [20:0]   bank1 
);
   parameter   WAIT        = 5'd0;
   parameter   READ        = 5'd1;
   parameter   READ_BANK   = 5'd2;
   parameter   READ_PIN    = 5'd3;
   parameter   WRITE       = 5'd4;
   parameter   WRITE_BANK  = 5'd5;
   parameter   WRITE_PIN   = 5'd6;
   parameter   CONFIG      = 5'd7;
   parameter   CONFIG_BANK = 5'd8;
   parameter   CONFIG_PIN  = 5'd9;
   
   reg   [4:0] state;
   reg   [7:0] bank;
   reg   [7:0] pin;
   reg   [7:0] data_tx;
   reg         transmit;
   
   wire        recieved;
   wire [7:0]  data_rx;
      
   uart_autobaud uart_autobaud(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .transmit      (transmit),
      .data_tx       (data_tx),
      .rx            (rx         ),
      .busy_rx       (  ),
      .busy_tx       (  ),
      .recieved      (recieved  ),
      .data_rx       (data_rx    ),
      .tx            (tx)
   );
   
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= WAIT;
      end else begin
         if(recieved) begin
            transmit <= 1'b1;
            data_tx <= data_rx;
            case(state)
               WAIT:          case(data_rx)
                                 8'd0:   state <= READ;
                                 8'd1:   state <= WRITE;
                                 8'd2:   state <= CONFIG;
                              endcase
               READ:          begin
                                 state <= READ_BANK; 
                              end
               READ_BANK:     begin
                                 state <= READ_PIN;
                                 pin   <= data_rx;
                              end
               READ_PIN:      begin
                                 state <= WAIT;
                              end
               WRITE:         begin
                                 state <= WRITE_BANK;
                              end
               WRITE_BANK:    begin
                                 state <= WRITE_PIN;
                                 pin <= data_rx;
                              end
               WRITE_PIN:     begin
                                 state <= WAIT;
                                 bank1[pin] <= data_rx[0]; 
                              end
               CONFIG:         begin
                                 state <= CONFIG_BANK;
                                 bank <= data_rx;
                              end
               CONFIG_BANK:   begin
                                 state <= CONFIG_PIN;
                                 pin <= data_rx;
                              end
               CONFIG_PIN:    begin
                                 state <= WAIT;
                                 data_tx <= 8'd53;
                              end
            endcase
         end else begin
            transmit <= 1'b0;
         end
      end
   end


endmodule
