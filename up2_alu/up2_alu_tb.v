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
    wire            o_zero_flag;

	up2_alu up2_alu(
        .clk            (clk            ),
        .nRst           (nRst           ),
        .i_r_write      (i_r_write      ),
        .i_r0           (i_r0           ),
        .i_r1           (i_r1           ),
        .i_r2           (i_r2           ),
        .i_mux_sel      (i_mux_sel      ),
        .i_alu_op       (i_alu_op       ),
        .o_r0           (o_r0           ),
        .o_r1           (o_r1           ),
        .o_r2           (o_r2           ),
	    .o_zero_flag    (o_zero_flag    )
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

    reg     [4095:0]        seen_states;
    integer                 count;

    initial begin
		#0              nRst		= 1;
                        i_r_write   = 0;
				        i_r0        = 0;
                        i_r1        = 0;
                        i_r2        = 0;
		                i_mux_sel   = 0;
                        i_alu_op    = 0;
        @(negedge clk)  nRst		= 0;
        @(negedge clk)  nRst        = 1;
      
      
        // Hit all states using write mechanism
        
        // Takes 50021 cycles
        
        seen_states = 0;
        count = 0;
        while(|(~seen_states))  begin
            @(negedge clk)  
                        
                        i_r0        = $random;
                        i_r1        = $random;
                        i_r2        = $random;
                        i_r_write   = $random;
                        i_mux_sel   = $random;
                        i_alu_op    = $random;
            @(posedge clk)
                        seen_states[{o_r0,o_r1,o_r2}] = 1'b1;
            count = count + 1;
        end
        $display("Hit all states using write in %d cycles", count);

        // Hit all states by using internal ops only
        
        // Takes 795921 cycles
        
        seen_states = 0;
        count = 0;
        while(|(~seen_states))  begin
            @(negedge clk)  
                        i_mux_sel   = $random;
                        i_alu_op    = $random;
            @(posedge clk)
                        seen_states[{o_r0,o_r1,o_r2}] = 1'b1;
            count = count + 1;
        end
        $display("Hit all states without using write in %d cycles", count);
        
        $finish;
	end

endmodule
