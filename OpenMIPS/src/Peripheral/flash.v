module flash (
	input bus_clk_i,
	input bus_rst_i,
	input [31:0] bus_addr_i,
	input [31:0] bus_data_i,
	output reg[31:0] bus_data_o,
	input bus_select_i,
	input bus_we_i,
	output bus_ack_o,
	
	output [15:0] output_data,
	output flash_busy,
	output [22:0] flash_addr, 
	inout [15:0] flash_data, 
	output [7:0] flash_ctl
);

	wire output_data[15:0];

	always @ (*) begin
		bus_data_o <= {16'b0, output_data};
	end

	flash_driver u0 (
		.clk(bus_clk_i), .addr(bus_addr_i[21:0]), .data_in(bus_data_i[15:0]), 
		.data_out(output_data), .enable_erase(1'b0), 
		.enable_read(!bus_we_i), .enable_write(1'b0),
		.flash_ctl(flash_ctl), .flash_addr(flash_addr), .flash_data(flash_data), 
		.ack(bus_ack_o)
		);
		
endmodule
