module up_alu_tb;

	parameter CLK_PERIOD = 20;

	reg  [7:0]  data_in_a0;
   reg  [7:0]  data_in_a1;
   reg  [7:0]  data_in_b0;
   reg  [7:0]  data_in_b1;
   reg         sel_in_a;
   reg         sel_in_b;
   reg  [2:0]  op;
   wire [7:0]  data_out;
   wire [7:0]  data_out_a;
   wire [7:0]  data_out_b;
	
   
   up_alu up_alu(
		.data_in_a0       (data_in_a0    ),
      .data_in_a1       (data_in_a1    ),
      .data_in_b0       (data_in_b0    ),
      .data_in_b1       (data_in_b1    ),
      .sel_in_a         (sel_in_a      ),
      .sel_in_b         (sel_in_b      ),
      .op               (op            ),
      .data_out         (data_out      ),
      .data_out_a       (data_out_a    ),
      .data_out_b       (data_out_b    )
   );

	initial begin
		$dumpfile("up_alu.vcd");
		$dumpvars(0,up_alu_tb);
	end

	initial begin	
               data_in_a0  = 0;
               data_in_a1  = 0;
               data_in_b0  = 0;
               data_in_b1  = 0;
               sel_in_a    = 0;
               sel_in_b    = 0;
               op          = 0;
		
      // Load data
      #100     data_in_a0  = 8'h11;
               data_in_a1  = 8'h06;
               data_in_b0  = 8'h33;
               data_in_b1  = 8'h03;

      // Switch input muxs
      #100     sel_in_a    = 1;
               sel_in_b    = 1;

      // Sweep math op codes
      #100     op          = 0;
      #100     op          = 1;
      #100     op          = 2;
      #100     op          = 3;

      #100     data_in_a0  = 8'hFC;
      #100     data_in_b0  = 8'hF9;
      #100     sel_in_a    = 0;
      #100     sel_in_b    = 0;

      // Sweep logic and passive ops
      #100     op          = 4;
      #100     op          = 5;
      #100     op          = 6;
      #100     op          = 7;
      
      #10000
		$finish;
	end

endmodule
