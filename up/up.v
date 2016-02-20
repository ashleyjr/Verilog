module up(
	input	   wire           clk,
	input	   wire           nRst,
   input    wire           prog,
   input    wire           int,
   input    wire           rx,
	output 	wire [7:0]	   leds,
   output   wire           tx
);
  

	
   // up
   wire        ale;
   reg   [7:0] address_latch;

   // datapath
   wire  [7:0] data_in;
   wire  [4:0] op;
   wire        ir_we;
   wire        pc_we;
   wire  [2:0] rb_sel_in;
   wire        rb_we;
   wire        sp_we;
   wire  [7:0] data_out;
   wire  [3:0] ir;
   wire        z;

   // memory
   wire        mem_re;
   wire        mem_we;
   wire  [7:0] load_in;
   wire  [7:0] load_out;

   // uart
   wire        busy_tx;
   wire  [7:0] data_tx;
   wire  [7:0] data_rx;
   wire        transmit;

   // Up only reset
   wire  up_nRst;
   assign up_nRst = nRst & ~prog;

   // Address latch
   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         address_latch <= 8'h00;
      end else begin
         if(ale) address_latch <= data_out;
      end
   end

   up_datapath up_datapath(
      .clk        (clk              ),
      .nRst       (up_nRst          ),
      .data_in    (data_in          ),
      .op         (op               ),
      .ir_we      (ir_we            ),
      .pc_we      (pc_we            ),
      .rb_sel_in  (rb_sel_in        ),
      .rb_we      (rb_we            ),
      .sp_we      (sp_we            ),
      .data_out   (data_out         ),
      .ir         (ir               ),
      .z          (z                )
   );

   up_controller up_controller(
      .clk        (clk              ),
      .nRst       (up_nRst          ),
      .int        (int              ),
      .ir         (ir               ),
      .mem_re     (mem_re           ),
      .z          (z                ),
      .op         (op               ),
      .ir_we      (ir_we            ),
      .pc_we      (pc_we            ),
      .rb_sel     (rb_sel_in        ),
      .rb_we      (rb_we            ),
      .sp_we      (sp_we            ),
      .mem_we     (mem_we           ),
      .ale        (ale              )
   );

   up_core up_core(
      .clk        (clk              ),
      .nRst       (up_nRst          ),   
      .data_in    (data_in          ),
      .mem_re     (mem_re           ),
      .int        (int              ),
      .data_out   (                 ),         
      .mem_we     (                 )
   ); 


   up_memory up_memory(
      .clk        (clk              ),
      .nRst       (nRst             ),
      .prog       (prog             ),
      .in         (data_out         ),
      .address    (address_latch    ),
      .we         (mem_we           ),
      .load_in    (load_in          ),
      .busy_tx    (busy_tx          ),
      .recived    (recived          ),
      .out        (data_in          ),
      .re         (mem_re           ),
      .transmit   (transmit         ),
      .load_out   (load_out         ),
      .leds       (leds             )
   );

   uart_autobaud uart_autobaud(
      .clk        (clk              ),
      .nRst       (nRst             ),
      .transmit   (transmit         ),
      .data_tx    (data_tx          ),
      .rx         (rx               ),
      .busy_tx    (busy_tx          ),
      .busy_rx    (),
      .recieved   (recived          ),
      .data_rx    (load_in          ),
      .tx         (tx               )
   );

endmodule
