module ram (
	input clk,    // Clock
	input rst,

	input [20:0] input_addr,
	input [31:0] input_data,

	input chip_enable,
	input read_enable, 
	input write_enable,

	output [31:0] output_data,

	output [19:0] baseram_addr,
	inout [31:0] baseram_data,
	output baseram_ce,
	output baseram_oe,
	output baseram_we,

	output [19:0] extram_addr,
	inout [31:0] extram_data,
	output extram_ce,
	output extram_oe,
	output extram_we, 
	output ack
	);

	ram_driver ram_driver_inst (
		clk, rst, 
		chip_enable, read_enable, write_enable, 
		input_addr, input_data, output_data,
		baseram_addr, baseram_data, 
		baseram_ce, baseram_oe, baseram_we, 
		extram_addr, extram_data, 
		extram_ce, extram_oe, extram_we, ack
	);

endmodule
