module ram_test (
	input clk,    // Clock
	input rst,

	input [7:0] user_addr,
	input [3:0] user_data,

	output [0:6] segdisp0,

	input read_enable, 
	input write_enable,

	output [19:0] baseram_addr,
	inout [31:0] baseram_data,
	output baseram_ce,
	output baseram_oe,
	output baseram_we,

	output [19:0] extram_addr,
	inout [31:0] extram_data,
	output extram_ce,
	output extram_oe,
	output extram_we 
	);

	wire[31:0] data_from_ram;
	reg[3:0] data_out;
	digseg_driver digseg_show_data(data_out[3:0], segdisp0);


	always @ (posedge clk) begin
		data_out <= data_from_ram[3:0];
	end

	ram_driver ram_driver_inst (
		clk, rst, 1'b1, !read_enable, !write_enable, 
		{user_addr[7], 12'b0, user_addr}, {28'b0, user_data}, 
		data_from_ram, baseram_addr, baseram_data, 
		baseram_ce, baseram_oe, baseram_we, 
		extram_addr, extram_data, 
		extram_ce, extram_oe, extram_we
	);

endmodule