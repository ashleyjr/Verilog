`timescale 1ns/1ps
module up2_mem_tb;

	parameter   CLK_PERIOD      = 20;

    parameter   ADDR_NIBBLES    = 2;
    parameter   DATA_NIBBLES    = 2;
    parameter   ADDR_WIDTH      = 4 * ADDR_NIBBLES;
    parameter   DATA_WIDTH      = 4 * DATA_NIBBLES;
    parameter   SHIFT_WIDTH     = ADDR_WIDTH + DATA_WIDTH;
    parameter   MEM_SIZE        = 2 ** ADDR_WIDTH;

    reg                         clk;         
    reg                         nRst;        
    reg                         i_read_ack;  
    wire                        o_read_req;  
    reg                         i_write_ack; 
    wire                        o_write_req; 
    reg     [DATA_WIDTH-1:0]    i_data;      
    wire    [ADDR_WIDTH-1:0]    o_addr;      
    wire    [DATA_WIDTH-1:0]    o_data;      
    reg                         i_shift;     
    reg     [3:0]               i_shift_data;
    wire    [3:0]               o_shift_data;
    reg                         i_swap_req;  
    wire                        o_swap_ack; 

    up2_mem #(
        .ADDR_NIBBLES(ADDR_NIBBLES),
        .DATA_NIBBLES(DATA_NIBBLES)
    )
    up2_mem(
        .clk            (clk            ),
        .nRst           (nRst           ),  
        .i_read_ack     (i_read_ack     ),
        .o_read_req     (o_read_req     ),             
        .i_write_ack    (i_write_ack    ),
        .o_write_req    (o_write_req    ),
        .i_data         (i_data         ),
        .o_addr         (o_addr         ),
        .o_data         (o_data         ),              
        .i_shift        (i_shift        ),
        .i_shift_data   (i_shift_data   ),
        .o_shift_data   (o_shift_data   ),
        .i_swap_req     (i_swap_req     ),   
        .o_swap_ack     (o_swap_ack     )
    );

    integer                     i;
    reg     [DATA_WIDTH-1:0]    mem [MEM_SIZE-1:0];
    reg     [3:0]               stall;

	initial begin
		while(1) begin
			#(CLK_PERIOD/2) clk = 0;
			#(CLK_PERIOD/2) clk = 1;
		end
	end

	initial begin
		$dumpfile("up2_mem.vcd");
		$dumpvars(0,up2_mem_tb);	
	    for(i=0;i<MEM_SIZE;i=i+1) $dumpvars(0,up2_mem_tb.mem[i]); 
    end

    initial begin
	    for(i=0;i<MEM_SIZE;i=i+1) begin
                    mem[i] = 0;
        end
        #0          nRst            = 1;
        #30         nRst            = 0;
        #30         nRst            = 1;
                    i_read_ack      = 0;
                    i_write_ack     = 0;
                    i_data          = 0;
                    i_shift         = 0;
                    i_shift_data    = 0;
                    i_swap_req      = 0;
       
        repeat(SHIFT_WIDTH) begin
                @(negedge clk);
                i_shift         = 1;  
                i_shift_data    = $random;
        end
        
        repeat(10000) begin

            @(negedge clk)
          
            // Swap if not shifting or finished swap
            if(~i_shift | o_swap_ack) begin
                i_swap_req      = $random;
            end

            // Shift if not swapping
            if(~i_swap_req) begin
                i_shift         = $random;  
                i_shift_data    = $random;
            end 

            // Memory interface
            if (o_write_req) begin
                stall = $random;
                repeat(stall) begin
                    @(negedge clk);
                end
                i_write_ack = 1;
                mem[o_addr] = o_data;
                @(negedge clk);
                i_write_ack = 0;
            end
            if (o_read_req) begin
                stall = $random;
                repeat(stall) begin
                    @(negedge clk);
                end
                i_read_ack = 1;
                i_data = mem[o_addr];
                @(negedge clk);
                i_read_ack = 0;
            end 
        end

        $finish;
	end

endmodule
