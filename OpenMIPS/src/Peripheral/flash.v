module flash_test(
	input clk,

	input enable_read, 
	input enable_erase, 
	input enable_write, 
	
	input [21:0] input_addr, 
	input [15:0] input_data,
	
	output [15:0] output_data,
	output flash_busy,
	output [22:0] flash_addr, 
	inout [15:0] flash_data, 
	output [7:0] flash_ctl, 
	output ack
);

	flash_driver u0 (
		.clk(clk), .addr(input_addr), .data_in(input_data), 
		.data_out(output_data), .enable_erase(enable_erase), 
		.enable_read(enable_read), .enable_write(enable_write),
		.busy(flash_busy), .flash_ctl(flash_ctl),
		.flash_addr(flash_addr), .flash_data(flash_data), 
		.ack(ack)
		);
		
endmodule
