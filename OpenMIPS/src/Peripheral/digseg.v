`include "defines.v"
module digseg_driver(
	input clk,
	input rst,

	input [`WB_AddrBus] bus_addr_i,
	input [`WB_DataBus] bus_data_i,
	output [`WB_DataBus] bus_data_o,
	input bus_select_i,
	input bus_we_i,
	output bus_ack_o,

	output [`DigSegDataBus] seg
	);

	digseg_driver digseg_driver0(
		bus_data_i[`DigSegAddrBus], seg, 
		bus_ack_o
	);

	assign bus_data_o = {25'b0, seg};

endmodule
