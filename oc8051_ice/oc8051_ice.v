
`timescale 1ns/1ps
module oc8051_ice(
	input    wire  i_clk,
   input	   wire  i_nrst,	
	output   wire	o_led4,
	output   wire	o_led3,
	output   wire	o_led2,
	output   wire	o_led1,
	output   wire	o_led0
);

   parameter ROM_BYTES = 8;
   parameter RAM_BYTES = 2;

   // ROM
   reg   [7:0]                   rom [0:ROM_BYTES-1]; 
   wire  [15:0]                  rom_addr;
   wire  [$clog2(ROM_BYTES):0]   rom_addr_crop;
   wire                          rom_stb;
   reg   [31:0]                  rom_data;
   reg                           rom_ack;

   assign rom_addr_crop = rom_addr[$clog2(ROM_BYTES)-1:0];

   // RAM
   reg   [7:0]                   ram [0:RAM_BYTES-1]; 
   wire  [15:0]                  ram_addr; 
   wire  [7:0]                   ram_data_in;
   reg   [7:0]                   ram_data_out;
   reg                           ram_ackw;
   reg                           ram_ackr;
   wire                          ram_ack;
   wire                          ram_wr;

   // LEDs
   assign o_led0 = ram[0][0];
   assign o_led1 = ram[0][1];
   assign o_led2 = ram[0][2];
   assign o_led3 = ram[0][3];
   assign o_led4 = ram[0][4];


   oc8051 oc8051_top_1(
      .wb_rst_i         (~i_nrst       ), 
      .wb_clk_i         (i_clk         ),
      
      // XRAM
      .wbd_dat_i        (ram_data_out  ), 
      .wbd_we_o         (ram_wr        ), 
      .wbd_dat_o        (ram_data_in   ),
      .wbd_adr_o        (ram_addr      ), 
      .wbd_err_i        (1'b0          ),
      .wbd_ack_i        (ram_ack       ), 
      .wbd_stb_o        (ram_stb       ), 
      .wbd_cyc_o        (              ),
      
      // ROM
      .wbi_adr_o        (rom_addr      ), 
      .wbi_stb_o        (rom_stb       ), 
      .wbi_ack_i        (rom_ack       ),
      .wbi_cyc_o        (              ), 
      .wbi_dat_i        (rom_data      ), 
      .wbi_err_i        (1'b0          )
   );

   ////////////////////////////////////////////////////////////////////////////
   // RAM
    
   assign ram_ack =  ram_ackw | ram_ackr;

   always @(posedge i_clk or negedge i_nrst) begin
      if (!i_nrst) begin
         ram_ackw          <= 1'b0;
      end else begin
         if (ram_wr && ram_stb) begin
            ram[ram_addr]  <= ram_data_in;
            ram_ackw       <= 1'b1;
         end else begin
            ram_ackw       <= 1'b0;
         end
      end
   end

   always @(posedge i_clk or negedge i_nrst) begin
      if (!i_nrst) begin
         ram_ackr          <= 1'b0;
      end else begin
         if (ram_stb && !ram_wr) begin
            ram_data_out   <= ram[ram_addr];
            ram_ackr       <= 1'b1;
         end else begin
            ram_ackr       <= 1'b0;
            ram_data_out   <= 8'h00;
         end
      end
   end


   ////////////////////////////////////////////////////////////////////////////
   // ROM
   always @(posedge i_clk or negedge i_nrst) begin
      if (!i_nrst) begin
         rom_data <= 31'h0;
         rom_ack  <= 1'b0;
         // Code
         rom[0] <= 8'h04;  // label:   inc A    
         rom[1] <= 8'h90;  //          mov DPTR, #0x00
         rom[2] <= 8'h00;  //
         rom[3] <= 8'h00;  //
         rom[4] <= 8'hF0;  //          movx @DPTR, A
         rom[5] <= 8'h80;  //          sjmp label
         rom[6] <= 8'hF9;  //
         rom[7] <= 8'h00;  //
      end else begin 
         if (rom_stb) begin
            rom_data    <= {  rom[rom_addr_crop+3], 
                              rom[rom_addr_crop+2], 
                              rom[rom_addr_crop+1], 
                              rom[rom_addr_crop]      };
            rom_ack     <= 1'b1;
         end else begin
            rom_ack     <= 1'b0;
         end
      end
   end

endmodule
