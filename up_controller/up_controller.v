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

   parameter   FETCH_LATCH    = 3'b001,
               FETCH_READ     = 3'b010,
               EXECUTE_1      = 3'b011,
               EXECUTE_2      = 3'b100,
               EXECUTE_3      = 3'b101;

   reg [2:0]   state;

   assign op = 
            (state == FETCH_LATCH)                       ?  5'b01101 :  // PC shifted right out
            (state == FETCH_READ )                       ?  5'b01111 :  // PC + 1 out
            ((state == EXECUTE_1) && (ir == 4'b0000))      ?  5'b00000 :  // Do an add
            ((state == EXECUTE_1) && (ir == 4'b0001))      ?  5'b00001 :  // Do a sub
            ((state == EXECUTE_1) && (ir == 4'b0010))      ?  5'b00010 :  // Do a mul
            ((state == EXECUTE_1) && (ir == 4'b0011))      ?  5'b00011 :  // Do a div
            ((state == EXECUTE_1) && (ir == 4'b0100))      ?  5'b00100 :  // Do a div
            (ir == 4'b0101)                                 ? 5'b00101  :  // Do an xor    
            (ir == 4'b0110)                                 ? 5'b00110  :  // Do an xor    
            (ir == 4'b0111)                                 ? 5'b00111  :  // Do an xor    

                                                            5'b00000 ;

   assign ir_we = 
            (state == FETCH_READ)                        ?  1'b1 : 1'b0;

   assign pc_we = 
            (state == FETCH_READ)                        ?  1'b1 : 1'b0;


   assign rb_sel_in = 
            ((state == EXECUTE_1) && (ir == 4'b0000))      ?  3'b100 : 
            ((state == EXECUTE_1) && (ir == 4'b0001))      ?  3'b100 :
            ((state == EXECUTE_1) && (ir == 4'b0010))      ?  3'b100 :
            ((state == EXECUTE_1) && (ir == 4'b0011))      ?  3'b100 :
            ((state == EXECUTE_1) && (ir == 4'b0100))      ?  3'b100 : 
            ((state == EXECUTE_1) && (ir == 4'b0101))      ?  3'b100  :
            ((state == EXECUTE_2) && (ir == 4'b0101))      ?  3'b101  :
            ((state == EXECUTE_3) && (ir == 4'b0101))      ?  3'b100  :
            ((state == EXECUTE_1) && (ir == 4'b0110))      ?  3'b101  :
            ((state == EXECUTE_2) && (ir == 4'b0110))      ?  3'b110  :
            ((state == EXECUTE_3) && (ir == 4'b0110))      ?  3'b101  :
            ((state == EXECUTE_1) && (ir == 4'b0111))      ?  3'b110  :
            ((state == EXECUTE_2) && (ir == 4'b0111))      ?  3'b111  :
            ((state == EXECUTE_3) && (ir == 4'b0111))      ?  3'b110  :
             
            
                  3'b000;

   assign rb_we = 
            ((state == EXECUTE_1) && (ir == 4'b0000))      ?  1'b1  : 
            ((state == EXECUTE_1) && (ir == 4'b0001))      ?  1'b1  : 
            ((state == EXECUTE_1) && (ir == 4'b0010))      ?  1'b1  : 
            ((state == EXECUTE_1) && (ir == 4'b0011))      ?  1'b1  : 
            ((state == EXECUTE_1) && (ir == 4'b0100))      ?  1'b1  :
            ((state == EXECUTE_1) && (ir == 4'b0101))      ?  1'b1  :
            ((state == EXECUTE_2) && (ir == 4'b0101))      ?  1'b1  :
            ((state == EXECUTE_3) && (ir == 4'b0101))      ?  1'b1  :
            ((state == EXECUTE_1) && (ir == 4'b0110))      ?  1'b1  :
            ((state == EXECUTE_2) && (ir == 4'b0110))      ?  1'b1  :
            ((state == EXECUTE_3) && (ir == 4'b0110))      ?  1'b1  :
            ((state == EXECUTE_1) && (ir == 4'b0111))      ?  1'b1  :
            ((state == EXECUTE_2) && (ir == 4'b0111))      ?  1'b1  :
            ((state == EXECUTE_3) && (ir == 4'b0111))      ?  1'b1  :

                                                               1'b0;

   assign ale = 
            (state == FETCH_LATCH)                       ? 1'b1  : 1'b0;



   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         state <= FETCH_LATCH;
      end else begin
         case(state)
            FETCH_LATCH:   state <= FETCH_READ; 
            FETCH_READ:    state <= EXECUTE_1;
            EXECUTE_1:     begin
                              if((ir == 4'b0101) ||
                                  (ir == 4'b0110) ||
                                    (ir == 4'b0111) 
                              )
                                 state <= EXECUTE_2;
                              else
                                 state <= FETCH_LATCH;        
                           end
            EXECUTE_2:     state <= EXECUTE_3;
            EXECUTE_3:     state <= FETCH_LATCH;
         endcase
      end
   end endmodule
