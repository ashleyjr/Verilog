module up_controller(
	input			   clk,
	input			   nRst,
	input			   int,
	input	   [3:0]	ir,
	input 			mem_re,
	output	[4:0]	op,
	output			ir_we,
	output			pc_we,
	output	[2:0]	rb_sel_in,
	output 			rb_we,
	output 			sp_we,
	output 			mem_we,
	output			ale
);

   parameter   FETCH_LATCH    = 2'b00,
               FETCH_READ     = 2'b01,
               EXECUTE        = 2'b10,
               INT            = 2'b11;

   reg [1:0]   state;

   assign op = 
            (state == FETCH_LATCH)                       ?  5'b01101 :  // PC shifted right out
            (state == FETCH_READ )                       ?  5'b01111 :  // PC + 1 out
            ((state == EXECUTE) && (ir == 4'b0000))      ?  5'b00000 :  // Do an add
                                                            5'b00000 ;

   assign ir_we = 
            ((state == FETCH_READ) && (mem_re))          ?  1'b1 : 1'b0;

   assign pc_we = 
            ((state == FETCH_READ) && (mem_re))          ?  1'b1 : 1'b0;


   assign rb_sel_in = 
            ((state == EXECUTE) && (ir == 4'b0000))      ? 2'b00 : 2'b00;

   assign rb_we = 
            ((state == EXECUTE) && (ir == 4'b0000))      ? 1'b1  : 1'b0;

   assign ale = 
            (state == FETCH_LATCH)  ?  1'b1     :
                                       1'b0     ;



   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= FETCH_LATCH;
      end else begin
         case(state)
            FETCH_LATCH:               state <= FETCH_READ; 
            FETCH_READ:    if(mem_re)  state <= EXECUTE;
            EXECUTE:                   state <= FETCH_READ;
         endcase
      end
   end 
endmodule
