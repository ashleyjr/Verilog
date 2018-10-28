`timescale 1ns/1ps
module ice_ram_uart_test(
	input				i_clk,
	input				i_nrst,
	input				i_rx,
	output	      o_tx
);

   wire           rx_s;
   wire           recieved;
   wire  [7:0]    data_rx;
   wire  [7:0]    data_tx;
   wire  [15:0]   rdata; 
   wire           busy_tx;
   reg   [15:0]   wdata;
   reg            transmit;

   resync_3 resync_3(
      .i_clk   (i_clk   ),
      .i_nrst  (i_nrst  ),
      .i_rst_d (1'b1    ),
      .i_d     (i_rx    ),
      .o_q     (rx_s    )
	);

   uart_autobaud uart_autobaud(
      .i_clk         (i_clk      ),
      .i_nrst        (i_nrst     ),
      .i_transmit    (transmit   ),
      .i_data_tx     (data_tx    ),
      .i_rx          (rx_s       ),
      .o_busy_rx     (           ),
      .o_busy_tx     (busy_tx    ),
      .o_recieved    (recieved   ),
      .o_data_rx     (data_rx    ),
      .o_tx          (o_tx       )
   );

   // Writing
   reg   [12:0]   wr_ptr;
   reg            we;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         wr_ptr   <= 'd0; 
         we       <= 1'b0;
      end else begin 
         we <= 1'b0;
         if (we)
            wr_ptr <= wr_ptr + 'd1;
         if(recieved)
            if(data_rx[3:0] == 4'h0) 
               wr_ptr   <= 'd0;
            else if(data_rx[3:0] == 4'h1) begin
               we       <= 1'b1;
               wdata    <= {data_rx[7:4],wdata[15:4]};
            end
      end
   end
      

   // Reading
   parameter      SM_RD_IDLE     = 2'h0,
                  SM_RD_GET      = 2'h1,
                  SM_RD_SEND     = 2'h2,
                  SM_RD_SENDING  = 2'h3;
   reg   [1:0]    rd_state;
   reg   [11:0]   rd_ptr;
   wire  [11:0]   rd_ptr_next; 

   assign data_tx = (rd_ptr[0]) ? rdata[15:8] : rdata[7:0];

   assign rd_ptr_next = rd_ptr + 'd1;

   always@(posedge i_clk or negedge i_nrst) begin
      if(!i_nrst) begin
         rd_ptr         <= 'd0;
         rd_state       <= SM_RD_IDLE;
         transmit       <= 1'b0;
      end else begin  
         case(rd_state) 
            SM_RD_IDLE:    if({recieved,data_rx[3:0]} == 5'h1F) begin
                              rd_state <= SM_RD_GET; 
                           end 
            SM_RD_GET:     begin
                              transmit <= 1'b1;                
                              rd_state <= SM_RD_SEND;
                           end
            
            SM_RD_SEND:    begin
                              transmit <= 1'b0;
                              rd_state <= SM_RD_SENDING;
                           end
            SM_RD_SENDING: begin
                              if(!busy_tx) begin
                                 rd_ptr <= rd_ptr_next;
                                 if(rd_ptr_next == 'd0) 
                                    rd_state <= SM_RD_IDLE;
                                 else
                                    rd_state <= SM_RD_GET;
                              end     
                           end 
         endcase
      end
   end
     
   ice_ram_2048x16b ice_ram_2048x16b(
      .i_nrst        (i_nrst                 ),
      .i_wclk        (i_clk                  ),
      .i_waddr       (wr_ptr[12:2]           ),
      .i_we          (we                     ),
      .i_wdata       (wdata                  ),
      .i_rclk        (i_clk                  ),
      .i_raddr       (rd_ptr[11:1]           ),
      .i_re          (1'b1                   ),
      .o_rdata       (rdata                  )
   );
    
endmodule
