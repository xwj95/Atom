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

assign bus_addr_o = m_addr_i,
	bus_select_o = m_select_i,
	bus_data_o = m_data_i,
	bus_we_o = m_we_i,
	m_data_o = bus_data_i,
	m_ack_o = wb_ack_i;


endmodule
