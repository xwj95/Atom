module flash_test(
	input clk,
	input do_read, 
	input do_erase, 
	input do_write, 
	input [21:0] user_addr, 
	input [7:0] user_data, 
	output [22:0] flash_addr, 
	inout [15:0] flash_data, 
	output [7:0] flash_ctl, 
	output [15:0] led, 
	output [0:6] segdisp0, 
	output [0:6] segdisp1
);

	wire [15:0] data_to_disp;
	digseg_driver disp_data_high(.data(data_to_disp[7:4]), .seg(segdisp1));
	digseg_driver disp_data_low(.data(data_to_disp[3:0]), .seg(segdisp0));

	reg enable_write, enable_erase, enable_read;
	wire flash_busy;

	always @ (posedge clk) begin
		enable_erase <= ~do_erase;
		enable_write <= ~do_write;
		enable_read <= ~do_read;
	end

	assign led = {
		data_to_disp[15:8], 
		4'b0, 
		enable_write, enable_erase, enable_read, flash_busy
	};

	flash_driver u0 (
		.clk(clk), .addr(user_addr), .data_in({8'b0, user_data}), 
		.data_out(data_to_disp), .enable_erase(enable_erase), 
		.enable_read(enable_read), .enable_write(enable_write),
		.busy(flash_busy), .flash_ctl(flash_ctl),
		.flash_addr(flash_addr), .flash_data(flash_data)
		);
		
endmodule
