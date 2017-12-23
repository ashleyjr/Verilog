`timescale 1ns/1ps
module up2_alu_tb;

	parameter CLK_PERIOD = 20;

	reg	            clk;
	reg	            nRst;
	reg	            i_r_write;
	reg	    [3:0]   i_r0;
	reg	    [3:0]   i_r1;
	reg	    [3:0]   i_r2;
    reg     [3:0]   i_mux_sel;
    reg     [3:0]   i_alu_op;
	wire	[3:0]   o_r0;
	wire	[3:0]   o_r1;
	wire	[3:0]   o_r2;

	up2_alu up2_alu(
        .clk            (clk        ),
        .nRst           (nRst       ),
        .i_r_write      (i_r_write  ),
        .i_r0           (i_r0       ),
        .i_r1           (i_r1       ),
        .i_r2           (i_r2       ),
        .i_mux_sel      (i_mux_sel  ),
        .i_alu_op       (i_alu_op   ),
        .o_r0           (o_r0       ),
        .o_r1           (o_r1       ),
        .o_r2           (o_r2       )
	);

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end
	
    initial begin
        $dumpfile("up2_alu.vcd");
        $dumpvars(0,up2_alu_tb);
    end

    initial begin
        while(1) begin
            @(posedge clk) begin
                $display("%tps",$time);
                $display("                        nRst         = %x",nRst       );
                $display("                        i_r_write    = %x",i_r_write  );
                $display("                        i_r0         = %x",i_r0       );
                $display("                        i_r1         = %x",i_r1       );
                $display("                        i_r2         = %x",i_r2       );
                $display("                        i_mux_sel    = %x",i_mux_sel  );
                $display("                        i_alu_op     = %x",i_alu_op   );
                $display("                        o_r0         = %x",o_r0       );
                $display("                        o_r1         = %x",o_r1       );
                $display("                        o_r2         = %x",o_r2       ); 
            end
        end
    end


    initial begin
		#0              nRst		= 1;
                        i_r_write   = 0;
				        i_r0        = 0;
                        i_r1        = 0;
                        i_r2        = 0;
		                i_mux_sel   = 0;
                        i_alu_op    = 0;
        #98             nRst		= 0;	
        #27             i_r_write   = 1;
		#27             i_r_write   = 0;

        // 1 + 1
        @(negedge clk)  
                        i_r0        = 1;
                        i_r1        = 1;
                        i_r2        = 1;
                        i_r_write   = 1;
        @(negedge clk)
                        i_r_write   = 0;

        #100
        $finish;
	end

endmodule
