`include "defines.v"
module rom(
	input clk,
	input rst,

	input [`WB_AddrBus] bus_addr_i,
	input [`WB_DataBus] bus_data_i,
	output reg[`WB_DataBus] bus_data_o,
	input bus_select_i,
	input bus_we_i,
	output bus_ack_o
	);

	rom_driver rom_driver0(
		bus_select_i, bus_addr_i[`RomAddrBus], 
		bus_data_o, bus_ack_o
	);

endmodule
