module fir_filter(
	input			clk,
	input			nRst,
	input	[31:0]	fir_in,
	input 			rx,
	output	[31:0]	fir_out,
	output			tx
);

	reg		[31:0] 	div_in;
	reg 			update;
	reg	 			div_clk_last;


	wire	[7:0]	data_rx;
	wire	[7:0]	data_tx;
	wire			recieved;
	wire			sample;

	assign sample = ((div_clk != div_clk_last) && (div_clk == 1'b1)) ? 1'b1 : 1'b0;

	always@(posedge clk or negedge nRst) begin
		if(!nRst) begin
			div_in 			<= 32'd0;
			update 			<= 1'b0;
			div_clk_last 	<= div_clk;
		end else begin
			if(recieved) 	div_in 			<= {div_in,data_rx};		
							update 			<= recieved; 	// delay by 1 clock
							div_clk_last 	<= div_clk;
		end
	end

	clk_divider clk_divider(
		.clk 			(clk 			),
		.nRst 			(nRst			),
		.update 		(update			),
		.div 			(div_in 		),
		.div_clk 		(div_clk		)
	);

	fir_filter_core fir_filter_core(
		.clk 			(clk 			),
		.nRst 			(nRst 			),
		.sample 		(sample 		),
		.coeffs_shift	(recieved		),
		.data_in 		(fir_in 		),
		.coeffs_in	 	(div_in[31:24]	),
		.data_out 		(fir_out		),
		.coeffs_out 	(data_tx 		)
	);

	uart_autobaud uart_autobaud(
		.clk 			(clk 			),
		.nRst 			(nRst 			),
		.transmit		(transmit		),
		.data_tx 		(data_tx 		),
		.rx 			(rx 			),
		.busy_tx 		(busy_tx 		),
		.busy_rx 		(busy_rx		),
		.recieved 		(recieved 		),
		.data_rx 		(data_rx		),
		.tx 			(tx 			)
	);





endmodule