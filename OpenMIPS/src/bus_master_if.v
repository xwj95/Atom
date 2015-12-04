`include "defines.v"

module bus_master_if (
	input				clk_i,
	input				rst_i,

	//master interface
	input	[`RegBus]	bus_data_i,
	output	[`RegBus]	bus_data_o,
	input	[`RegBus]	bus_addr_i,
	input	[15:0]		bus_select_i,
	input				bus_we_i,
	output				bus_ack_o,

	//slave interface
	input	[`RegBus]	s0_data_i,
	output	[`RegBus]	s0_data_o,
	output	[`RegBus]	s0_addr_o,
	output				s0_select_o,
	output				s0_we_o,
	input				s0_ack_i,

	input	[`RegBus]	s1_data_i,
	output	[`RegBus]	s1_data_o,
	output	[`RegBus]	s1_addr_o,
	output				s1_select_o,
	output				s1_we_o,
	input				s1_ack_i,
	
	input	[`RegBus]	s2_data_i,
	output	[`RegBus]	s2_data_o,
	output	[`RegBus]	s2_addr_o,
	output				s2_select_o,
	output				s2_we_o,
	input				s2_ack_i,
	
	input	[`RegBus]	s3_data_i,
	output	[`RegBus]	s3_data_o,
	output	[`RegBus]	s3_addr_o,
	output				s3_select_o,
	output				s3_we_o,
	input				s3_ack_i,
	
	input	[`RegBus]	s4_data_i,
	output	[`RegBus]	s4_data_o,
	output	[`RegBus]	s4_addr_o,
	output				s4_select_o,
	output				s4_we_o,
	input				s4_ack_i,
	
	input	[`RegBus]	s5_data_i,
	output	[`RegBus]	s5_data_o,
	output	[`RegBus]	s5_addr_o,
	output				s5_select_o,
	output				s5_we_o,
	input				s5_ack_i,
	
	input	[`RegBus]	s6_data_i,
	output	[`RegBus]	s6_data_o,
	output	[`RegBus]	s6_addr_o,
	output				s6_select_o,
	output				s6_we_o,
	input				s6_ack_i,
	
	input	[`RegBus]	s7_data_i,
	output	[`RegBus]	s7_data_o,
	output	[`RegBus]	s7_addr_o,
	output				s7_select_o,
	output				s7_we_o,
	input				s7_ack_i
);

//address & data pass
assign s0_addr_o = bus_addr_i;
assign s1_addr_o = bus_addr_i;
assign s2_addr_o = bus_addr_i;
assign s3_addr_o = bus_addr_i;
assign s4_addr_o = bus_addr_i;
assign s5_addr_o = bus_addr_i;
assign s6_addr_o = bus_addr_i;
assign s7_addr_o = bus_addr_i;

assign s0_select_o = bus_select_i[0];
assign s1_select_o = bus_select_i[1];
assign s2_select_o = bus_select_i[2];
assign s3_select_o = bus_select_i[3];
assign s4_select_o = bus_select_i[4];
assign s5_select_o = bus_select_i[5];
assign s6_select_o = bus_select_i[6];
assign s7_select_o = bus_select_i[7];

assign s0_data_o = bus_data_i;
assign s1_data_o = bus_data_i;
assign s2_data_o = bus_data_i;
assign s3_data_o = bus_data_i;
assign s4_data_o = bus_data_i;
assign s5_data_o = bus_data_i;
assign s6_data_o = bus_data_i;
assign s7_data_o = bus_data_i;

always @ (bus_select_i or s0_data_i or s1_data_i or s2_data_i or s3_data_i or
	s4_data_i or s5_data_i or s6_data_i or s7_data_i) begin
	case(bus_select_i)
		16'h0001:	bus_data_o = s0_data_i;
		16'h0002:	bus_data_o = s1_data_i;
		16'h0004:	bus_data_o = s2_data_i;
		16'h0008:	bus_data_o = s3_data_i;
		16'h0010:	bus_data_o = s4_data_i;
		16'h0020:	bus_data_o = s5_data_i;
		16'h0040:	bus_data_o = s6_data_i;
		16'h0080:	bus_data_o = s7_data_i;
	endcase
end

assign s0_we_o = bus_we_i;
assign s1_we_o = bus_we_i;
assign s2_we_o = bus_we_i;
assign s3_we_o = bus_we_i;
assign s4_we_o = bus_we_i;
assign s5_we_o = bus_we_i;
assign s6_we_o = bus_we_i;
assign s7_we_o = bus_we_i;

always @ (bus_select_i or s0_ack_i or s1_ack_i or s2_ack_i or s3_ack_i or
	s4_ack_i or s5_ack_i or s6_ack_i or s7_ack_i) begin
	case(bus_select_i)
		16'h0001:	bus_ack_o = s0_ack_i;
		16'h0002:	bus_ack_o = s0_ack_i;
		16'h0004:	bus_ack_o = s0_ack_i;
		16'h0008:	bus_ack_o = s0_ack_i;
		16'h0010:	bus_ack_o = s0_ack_i;
		16'h0020:	bus_ack_o = s0_ack_i;
		16'h0040:	bus_ack_o = s0_ack_i;
		16'h0080:	bus_ack_o = s0_ack_i;
		default:	bus_ack_o = 1'b0;
	endcase
end

endmodule
