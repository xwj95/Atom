module uart(
	input clk,
	input rst,	// assert to reset the status of receiver
	input enable, 
	input [7:0] data_in,
	output [7:0] data_out,
	input TxD_start,
	output TxD_busy,
	output RxD_data_ready,
	output com_TxD,
	input com_RxD, 
	output ack_t, 
	output ack_r);

	localparam CLK_FREQ = 50000000,	// 50 MB
			BAUD = 115200;



	uart_async_transmitter #(.ClkFrequency(CLK_FREQ), .Baud(BAUD)) u0
	(.clk(clk), .TxD_start(!TxD_start & enable), .TxD_data(data_in),
	.TxD(com_TxD), .TxD_busy(TxD_busy), .ack(ack_t));

	uart_async_receiver #(.ClkFrequency(CLK_FREQ), .Baud(BAUD)) u1
	(.clk(clk), .rst(!rst), .RxD(com_RxD),
	.RxD_data_ready(RxD_data_ready), .RxD_waiting_data(),
	.RxD_data(data_out), .ack(ack_r));

endmodule
