module up_memory(
	input    wire			   clk,
	input    wire			   nRst,
	input    wire           prog,       // Enable shift load
   input    wire	[7:0]    in,         // Data in from up
	input    wire	[7:0]    address,    // Address in from up
	input    wire			   we,         // Write enable
   input    wire  [7:0]    load_in,    // Data in from serial
   input    wire           busy_tx,    // Serial is busy sending data
   input    wire           recived,    // Serial has recived some data
	output   wire	[7:0]    out,        // Data out to up
	output   reg			   re,         // Data out is valid
   output   reg            transmit,   // Send the load out over serial
   output   wire  [7:0]    load_out,   // data out o serial
   output   wire  [7:0]    leds        // one byte is memory mapped to leds
);

   parameter   SIZE           = 256;
   parameter   LEDS_LOC       = 160;
   parameter   S_MEM_ONLY     = 2'b00;
   parameter   S_MEM_LOAD_1   = 2'b01;
   parameter   S_MEM_LOAD_2   = 2'b10;


	reg [7:0]   mem   [SIZE-1:0];
   reg [1:0]   state;

   assign out        = mem[address];
   assign load_out   = mem[SIZE-1];
   assign leds       = mem[LEDS_LOC]; 

 
   integer i;
   always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
         re          <= 1'b0;
         transmit    <= 1'b0;
         state       <= S_MEM_ONLY;
         for (i=0; i<SIZE; i=i+1) begin 
            mem[i]   <= 8'h00;
         end
      end else begin
         case(state)
            S_MEM_ONLY:       begin   
                                 if(we)      mem[address]   <= in;
                                 if(prog)    state          <= S_MEM_LOAD_1;
                                             re             <= 1'b1;
                                             transmit       <= 1'b0;
                              end
            S_MEM_LOAD_1:     if(!prog)      state          <= S_MEM_ONLY;
                              else
                                 if(recived) begin         
                                             transmit       <= 1'b1;
                                             state          <= S_MEM_LOAD_2;
                                 end
            S_MEM_LOAD_2:     begin
                                 transmit <= 1'b0;
                                 if(!prog)   state          <= S_MEM_ONLY;
                                 else
                                    if(!busy_tx) begin
                                             mem[0]         <= load_in;
                                             state          <= S_MEM_LOAD_1;
                                       for (i=0; i<SIZE; i=i+1) begin 
                                             mem[i+1]       <= mem[i];    
                                       end
                                 end
                              end
         endcase
      end
	end

endmodule
