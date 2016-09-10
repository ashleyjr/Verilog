`timescale 1ns/1ps
module uart2gpio(
	input    clk,
	input    nRst,
	input    rx,
	input    sw2,
	input    sw1,
	input    sw0,
	output   tx,
	output   [4:0] led
);
   parameter   WAIT        = 8'd0;
   parameter   READ        = 8'd1;
   parameter   READ_BANK   = 8'd2;
   parameter   READ_PIN    = 8'd3;
   parameter   WRITE       = 8'd4;
   parameter   WRITE_BANK  = 8'd5;
   parameter   WRITE_PIN   = 8'd6;
   
   reg   [3:0] state;
   reg   [7:0] bank;
   reg   [7:0] pin;
   reg   [7:0] data_tx;
   reg         transmit;
   
   wire        recieved;
   wire [7:0]  data_rx;
      
   assign led[0] =   state[0]; 
   assign led[1] =   state[1];
   assign led[2] =   state[2];
   assign led[3] =   state[3];
   assign led[4] = 1'b0; 
   
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
               WAIT:       case(data_rx)
                              8'd48:   state <= READ;
                              8'd49:   state <= WRITE;
                           endcase
               READ:       begin
                              state <= READ_BANK;
                              bank  <= data_rx; 
                           end
               READ_BANK:  begin
                              state <= READ_PIN;
                              pin   <= data_rx;
                           end
               READ_PIN:   begin
                              state <= WAIT;
                              data_tx <= 8'd50;
                           end
               WRITE:      begin
                              state <= WRITE_BANK;
                              bank <= data_rx;
                           end
               WRITE_BANK: begin
                              state <= WRITE_PIN;
                              pin <= data_rx;
                           end
               WRITE_PIN:  begin
                              state <= WAIT;
                              data_tx <= 8'd51;
                           end
            endcase
         end else begin
            transmit <= 1'b0;
         end
      end
   end


endmodule
