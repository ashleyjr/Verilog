module up(
	input	   wire           clk,
	input	   wire           nRst,
   input    wire           int,
   input    wire           rx,
	output 	wire [7:0]	   led,
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

   // uart
   wire        busy_tx;
   wire  [7:0  ]data_tx;
   wire        transmit;


   always@(posedge clk or negedge nRst) begin
      if(!nRst) begin
         address_latch <= 8'h00;
      end else begin
         if(ale) address_latch <= data_out;
      end
   end

   up_datapath up_datapath(
      .clk        (clk              ),
      .nRst       (nRst             ),
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
      .nRst       (nRst             ),
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

   up_memory up_memory(
      .clk        (clk              ),
      .nRst       (nRst             ),
      .in         (data_out         ),
      .address    (address_latch    ),
      .we         (mem_we           ),
      .busy_tx    (busy_tx          ),
      .out        (data_in          ),
      .re         (mem_re           ),
      .test       (led              ),
      .data_tx    (data_tx          ),
      .transmit   (transmit         )
   );

   uart_autobaud uart_autobaud(
      .clk        (clk),
      .nRst       (nRst),
      .transmit   (transmit),
      .data_tx    (data_tx),
      .rx         (rx     ),
      .busy_tx       (busy_tx),
      .busy_rx    (),
      .recieved      (),
      .data_rx    (),
      .tx         (tx)
   );

endmodule
