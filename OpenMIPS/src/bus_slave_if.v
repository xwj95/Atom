`include "defines.v"

module bus_slave_if (
	input					clk_i,
	input					rst_i,

	//slave interface
	input		[`RegBus]	bus_data_i,
	output		[`RegBus]	bus_data_o,
	output		[`RegBus]	bus_addr_o,
	output					bus_select_o,
	output					bus_we_o,
	input					bus_ack_i,

	//master interface
	input		[`RegBus]	m_data_i,
	output		[`RegBus]	m_data_o,
	input		[`RegBus]	m_addr_i,
	input					m_select_i,
	input					m_we_i,
	output					m_ack_o

);

always @ (m_addr_i) begin
	bus_addr_o = m_addr_i;
end

always @ (m_select_i) begin
	bus_select_o = m_select_i;
end

always @ (m_data_i) begin
	bus_data_o = m_data_i;
end

assign m_data_o = bus_data_i;

always @ (m_we_i) begin
	bus_we_o = m_we_i;
end

assign m_ack_o = wb_ack_i;

endmodule
