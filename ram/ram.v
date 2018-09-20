module pll (
   input             clk,
   input             nRst,
	input				   sw2,
	input				   sw1,
	input				   sw0,	
	output	reg	   led4,
	output	reg	   led3,
	output	reg	   led2,
	output	reg	   led1,
	output	reg	   led0

);

   wire  [15:0]   rdata, wdata;
   wire  [7:0]    addr;

   assign wdata = {13'h000F,sw2,sw1,sw0};
   assign addr = 8'h0;
   
   assign led0 = rdata[0];   
   assign led1 = rdata[1];   
   assign led2 = rdata[2];
   assign led3 = rdata[3];
   assign led4 = rdata[4];



   ifdef __ICARUS__

   SB_RAM40_4K #(
      .WRITE_MODE(0),
      .READ_MODE(0)
   ) ram (
      .RDATA(rdata),
      .RADDR(addr),
      .RCLK(clk),
      .RCLKE(1'b1),
      .RE(1'b1),
      .WADDR(addr),
      .WCLK(clk),
      .WCLKE(1'b1),
      .WDATA(wdata),
      .WE(1'b1),
      .MASK(16'b0)
   );
   
   defparam ram.INIT_0 = 256'h123456789abcdef00000dddd0000eeee00000012483569ac0111044400000001;
   defparam ram.INIT_1 = 256'h56789abcdef123400000dddd0000eeee00000012483569ac0111044401000002;
   defparam ram.INIT_2 = 256'habcdef12345678900000dddd0000eeee00000012483569ac0111044402000004;
   defparam ram.INIT_3 = 256'h00000000000000000000dddd0000eeee00000012483569ac0111044403000008;
   defparam ram.INIT_4 = 256'hffff000022220000444400006666000088880012483569ac0111044404000010;
   defparam ram.INIT_5 = 256'hffff000022220000444400006666000088880012483569ac0111044405000020;
   defparam ram.INIT_6 = 256'hffff000022220000444400006666000088880012483569ac0111044406000040;
   defparam ram.INIT_7 = 256'hffff000022220000444400006666000088880012483569ac0111044407000080;
   defparam ram.INIT_8 = 256'h0000111100003333000055550000777700000012483569ac0111044408000100;
   defparam ram.INIT_9 = 256'h0000111100003333000055550000777700000012483569ac0111044409000200;
   defparam ram.INIT_A = 256'h0000111100003333000055550000777700000012483569ac011104440a000400;
   defparam ram.INIT_B = 256'h0000111100003333000055550000777700000012483569ac011104440b000800;
   defparam ram.INIT_C = 256'h0123000099990000aaaa0000bbbb0000cccc0012483569ac011104440c001000;
   defparam ram.INIT_D = 256'h4567000099990000aaaa0000bbbb0000cccc0012483569ac011104440d002000;
   defparam ram.INIT_E = 256'h89ab000099990000aaaa0000bbbb0000cccc0012483569ac011104440e004000;
   defparam ram.INIT_F = 256'hcdef000099990000aaaa0000bbbb0000cccc0012483569ac011104440f008000;
endmodule

