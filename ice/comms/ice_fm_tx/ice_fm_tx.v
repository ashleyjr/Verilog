`timescale 1ns/1ps
module ice_fm_tx(
	input	   wire  i_clk,
	input	   wire  i_nrst,
	input				i_rx,
	output	      o_tx,
   output   wire  o_fm
);
   
   wire           clk; 
   wire           rx_s;
   reg   [7:0]    sample_top,
                  sample_counter;
   wire           sample;
   reg   [12:0]   wr_ptr;
   reg            we;
   reg   [10:0]   rd_ptr;
   wire  [15:0]   ram_rdata;
   reg   [15:0]   ram_wdata;
   wire  [7:0]    data_rx;
   wire   [7:0]    data_tx;
   wire            transmit;
   reg            set;
   reg            set1;
   reg            set2;

   parameter      SM_RD_IDLE     = 2'h0,
                  SM_RD_FINAL    = 2'h1,
                  SM_RD_SENDING  = 2'h2;
   reg   [1:0]    rd_state;
   reg   [11:0]   send_ptr; 
   wire  [11:0]   rd_ptr_next; 


   ///////////////////////////////////////////////////
   // PLL out is 67.5 MHz
   ice_pll #(
      .p_divr     (4'd0          ),
      .p_divf     (7'd44         ),
      .p_divq     (3'd3          )
   
   )ice_pll(
	   .i_clk	   (i_clk         ),
	   .i_nrst	   (i_nrst        ),
	   .i_bypass   (1'b0          ),
      .o_clk      (clk           ),
      .o_lock     (              )	
	);
   ///////////////////////////////////////////////////
   // SAMPLE COUNTER 
   assign sample = (sample_counter == sample_top);
   
   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         sample_counter <= 'd0;
         sample_top     <= 'd0;
      end else begin
         if(sample) 
            sample_counter <= 'd0;
         else
            sample_counter <= sample_counter + 'd1;
      end
   end
   ///////////////////////////////////////////////////
   // READ POINTER 
   
   assign data_tx = (send_ptr[0]) ? ram_rdata[15:8] : ram_rdata[7:0];

   assign send_ptr_next = send_ptr + 'd1;

   assign transmit = (  (SM_RD_IDLE != rd_state)      &
                        (send_ptr[11:1] == rd_ptr)    & 
                        ~busy_tx                      & 
                        sample);

   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         rd_ptr   <= 'd0;
         send_ptr <= 'd0;
         rd_state <= SM_RD_IDLE; 
      end else begin
         if(sample) 
            if(ram_rdata == 'd0)
               rd_ptr <= 'd0;
            else
               rd_ptr <= rd_ptr + 'd1;
         case(rd_state) 
            SM_RD_IDLE:    if({recieved,data_rx[3:0]} == 5'h1F) begin
                              rd_state <= SM_RD_SENDING; 
                              send_ptr <= 'd0;
                           end  
            SM_RD_SENDING: begin 
                              if(transmit) begin 
                                 send_ptr <= send_ptr + 'd1;
                                 if(ram_rdata == 'd0) 
                                    rd_state <= SM_RD_FINAL;
                                 
                              end     
                           end 
            // Try reducing clock
            // Cutting down timer
            //    CUrrently at 24 bits
            SM_RD_FINAL:   begin
                              if(transmit)
                                 rd_state <= SM_RD_IDLE;
                           end
         endcase  
         if(set | set1 | set2)
            rd_ptr <= 'd0;
      end
   end
   ///////////////////////////////////////////////////
   // WRITE POINTER
   always@(posedge clk or negedge i_nrst) begin
      if(!i_nrst) begin
         wr_ptr      <= 'd0; 
         we          <= 1'b0;
         ram_wdata   <= 'd0;
         set         <= 1'b0;
         set1        <= 1'b0;
         set2        <= 1'b0;
      end else begin 
         we    <= 1'b0;
         set   <= 1'b0;
         set1  <= set;
         set2  <= set1;
         if (we)
            wr_ptr <= wr_ptr + 'd1;
         if(recieved)
            if(data_rx[3:0] == 4'h0) 
               wr_ptr   <= 'd0;
            else if(data_rx[3:0] == 4'h1) begin
               we          <= 1'b1;
               ram_wdata   <= {data_rx[7:4],ram_wdata[15:4]};
            end 
            else if(data_rx[3:0] == 4'h2) 
               sample_top[3:0]   <= data_rx[7:4];
            else if(data_rx[3:0] == 4'h3) 
               sample_top[7:4]   <= data_rx[7:4];
            else if(data_rx[3:0] == 4'h4)
               set      <= 1'b1; 
      end
   end
    
   ///////////////////////////////////////////////////
   // FM TX   
   fm_tx #(
      .p_hz_sz    (27            )
   )fm_tx(
      .i_clk      (clk           ),
      .i_nrst     (i_nrst        ),
      .i_clk_hz   (27'd67500000  ),
      .i_base_hz  (27'd30000000  ),
      .i_shift_hz ({{11{1'b0}},ram_rdata}),
      .i_set      (set|set1|set2 ),
      .o_fm       (o_fm          )
   );
   ///////////////////////////////////////////////////
   // RAM
   ice_ram_2048x16b ice_ram_2048x16b(
      .i_nrst        (i_nrst                 ),
      .i_wclk        (clk                    ),
      .i_waddr       (wr_ptr[12:2]           ),
      .i_we          (we                     ),
      .i_wdata       (ram_wdata              ),
      .i_rclk        (clk                    ),
      .i_raddr       (rd_ptr                 ),
      .i_re          (1'b1                   ),
      .o_rdata       (ram_rdata              )
   ); 
   ///////////////////////////////////////////////////
   // UART 
   resync_3 resync_3(
      .i_clk   (clk     ),
      .i_nrst  (i_nrst  ),
      .i_rst_d (1'b1    ),
      .i_d     (i_rx    ),
      .o_q     (rx_s    )
	);
   uart_autobaud uart_autobaud(
      .i_clk         (clk        ),
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
   ///////////////////////////////////////////////////


endmodule
