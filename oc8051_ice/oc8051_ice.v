
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

   parameter ROM_BYTES = 82;
   parameter RAM_BYTES = 20;

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
      .wbi_err_i        (1'b0          ),
  
      // Internal RAM
      .rd_addr          (rd_addr       ),
      .wr_addr          (wr_addr       ),
      .wr_dat           (wr_data       ),
      .ram_data         (rd_data       ),
      .desCy            (bit_data_in   ),
      .bit_data         (bit_data_out  ),
      .wr_ram           (wr            ),
      .bit_addr_o       (bit_addr      )
    
   );


   ////////////////////////////////////////////////////////////////////////////
   // Internal RAM
 
   wire  [7:0] rd_addr;
   wire  [7:0] wr_addr;
   wire  [7:0] wr_data;
   wire  [7:0] rd_data;
   wire        bit_data_in;
   wire        bit_data_out;
   wire        wr;
   wire        bit_addr;   
   reg   [7:0] wr_data_m;
   reg   [7:0] rd_addr_m, 
               wr_addr_m;
   wire        rd_en;
   reg         bit_addr_r,
               rd_en_r;
   reg   [7:0] wr_data_r;
   reg   [7:0] rd_data_m;
   reg   [2:0] bit_select; 
   reg   [7:0] buff [0:256];
   
   assign bit_data_out  = rd_data[bit_select];
   assign rd_data       = rd_en_r ? wr_data_r: rd_data_m;
   assign rd_en         = (rd_addr_m == wr_addr_m) & wr;
    
   //
   // writing to ram
   always @(posedge i_clk)
   begin
    if (wr)
       buff[wr_addr_m] <=  wr_data_m;
   end
   
   //
   // reading from ram
   always @(posedge i_clk or negedge i_nrst)
   begin
     if (!i_nrst)
       rd_data_m <=  8'h0;
     else if ((wr_addr_m==rd_addr_m) & wr & !rd_en)
       rd_data_m <=  wr_data_m;
     else if (!rd_en)
       rd_data_m <=  buff[rd_addr_m];
   end
 
   always @(posedge i_clk or negedge i_nrst)
     if (!i_nrst) begin
       bit_addr_r <=  1'b0;
       bit_select <=  3'b0;
     end else begin
       bit_addr_r <=  bit_addr;
       bit_select <=  rd_addr[2:0];
     end
    
   always @(posedge i_clk or negedge i_nrst)
     if (!i_nrst) begin
       rd_en_r    <=  1'b0;
       wr_data_r  <=  8'h0;
     end else begin
       rd_en_r    <=  rd_en;
       wr_data_r  <=  wr_data_m;
     end
   always @(rd_addr or bit_addr)
     casex ( {bit_addr, rd_addr[7]} )          
         2'b0?: rd_addr_m = rd_addr;
         2'b10: rd_addr_m = {4'b0010, rd_addr[6:3]};
         2'b11: rd_addr_m = {1'b1, rd_addr[6:3], 3'b000};
     endcase
   always @(wr_addr or bit_addr_r)
     casex ( {bit_addr_r, wr_addr[7]} )
         2'b0?: wr_addr_m = wr_addr;
         2'b10: wr_addr_m = {8'h00, 4'b0010, wr_addr[6:3]};
         2'b11: wr_addr_m = {8'h00, 1'b1, wr_addr[6:3], 3'b000};
     endcase 
   always @(rd_data or bit_select or bit_data_in or wr_data or bit_addr_r)
     casex ( {bit_addr_r, bit_select} ) 
         4'b0_???: wr_data_m = wr_data;
         4'b1_000: wr_data_m = {rd_data[7:1], bit_data_in};
         4'b1_001: wr_data_m = {rd_data[7:2], bit_data_in, rd_data[0]};
         4'b1_010: wr_data_m = {rd_data[7:3], bit_data_in, rd_data[1:0]};
         4'b1_011: wr_data_m = {rd_data[7:4], bit_data_in, rd_data[2:0]};
         4'b1_100: wr_data_m = {rd_data[7:5], bit_data_in, rd_data[3:0]};
         4'b1_101: wr_data_m = {rd_data[7:6], bit_data_in, rd_data[4:0]};
         4'b1_110: wr_data_m = {rd_data[7], bit_data_in, rd_data[5:0]};
         4'b1_111: wr_data_m = {bit_data_in, rd_data[6:0]};
     endcase


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
         
         // Code - leds
         rom[0] <= 8'h04;  // label:   inc A    
         rom[1] <= 8'h90;  //          mov DPTR, #0x00
         rom[2] <= 8'h00;  //
         rom[3] <= 8'h00;  //
         rom[4] <= 8'hF0;  //          movx @DPTR, A
         rom[5] <= 8'h80;  //          sjmp label
         rom[6] <= 8'hF9;  //
         rom[7] <= 8'h00;  //
   
         // Code - fib
         rom[0] <= 8'h7F;
         rom[1] <= 8'h00;
         rom[2] <= 8'h8F;
         rom[3] <= 8'h82;
         rom[4] <= 8'hC0;
         rom[5] <= 8'h07;
         rom[6] <= 8'h12;
         rom[7] <= 8'h00;
         rom[8] <= 8'h21;
         rom[9] <= 8'hE5;
         rom[10] <= 8'h82;  
         rom[11] <= 8'hD0;
         rom[12] <= 8'h07;
         rom[13] <= 8'h90;
         rom[14] <= 8'h00;
         rom[15] <= 8'h00;
         rom[16] <= 8'hF0;
         rom[17] <= 8'h0F;
         rom[18] <= 8'hC3;
         rom[19] <= 8'hEF;
         rom[20] <= 8'h64;
         rom[21] <= 8'h80;
         rom[22] <= 8'h94;
         rom[23] <= 8'h85;
         rom[24] <= 8'h40;
         rom[25] <= 8'hE8;
         rom[26] <= 8'h74;
         rom[27] <= 8'h7F;
         rom[28] <= 8'h90;
         rom[29] <= 8'h00;
         rom[30] <= 8'h10;
         rom[31] <= 8'hF0;
         rom[32] <= 8'h22;
         rom[33] <= 8'hE5;
         rom[34] <= 8'h82;
         rom[35] <= 8'hFF;
         rom[36] <= 8'h70;
         rom[37] <= 8'h03;
         rom[38] <= 8'hF5;
         rom[39] <= 8'h82;
         rom[40] <= 8'h22;
         rom[41] <= 8'hBF;
         rom[42] <= 8'h01;
         rom[43] <= 8'h04;
         rom[44] <= 8'h75;
         rom[45] <= 8'h82;
         rom[46] <= 8'h01;
         rom[47] <= 8'h22;
         rom[48] <= 8'hEF;
         rom[49] <= 8'h14;
         rom[50] <= 8'hF5;
         rom[51] <= 8'h82;
         rom[52] <= 8'hC0;
         rom[53] <= 8'h07;
         rom[54] <= 8'h12;
         rom[55] <= 8'h00;
         rom[56] <= 8'h21;
         rom[57] <= 8'hAE;
         rom[58] <= 8'h82;
         rom[59] <= 8'hD0;
         rom[60] <= 8'h07;
         rom[61] <= 8'hEF;
         rom[62] <= 8'h24;
         rom[63] <= 8'hFE;
         rom[64] <= 8'hF5;
         rom[65] <= 8'h82;
         rom[66] <= 8'hC0;
         rom[67] <= 8'h06;
         rom[68] <= 8'h12;
         rom[69] <= 8'h00;
         rom[70] <= 8'h21;
         rom[71] <= 8'hAF;
         rom[72] <= 8'h82;
         rom[73] <= 8'hD0;
         rom[74] <= 8'h06;
         rom[75] <= 8'hEF;
         rom[76] <= 8'h2E;
         rom[77] <= 8'hF5;
         rom[78] <= 8'h82;
         rom[79] <= 8'h22;
         rom[80] <= 8'h00;
         rom[81] <= 8'h00;

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
