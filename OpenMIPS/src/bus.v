`include "defines.v"

module bus(
	input							clk_i,
	input							rst_i,

	//master interface
	input 		wire[`RegBus]		m_data_i,
	input		wire[`RegBus]		m_addr_i,
	input		wire				m_we_i,
	input		wire[15:0]			m_select_i,
	output		reg[`RegBus]		m_data_o,
	output		reg					m_ack_o,

	//slave 0 interface
	input		wire[`RegBus]		s0_data_i,
	input		wire[`RegBus]		s0_addr_i,
	input		wire				s0_we_i,
	input		wire				s0_select_i,
	output		reg[`RegBus]		s0_data_o,
	output		reg					s0_ack_o,

	//slave 1 interface
	input		wire[`RegBus]		s1_data_i,
	input		wire[`RegBus]		s1_addr_i,
	input		wire				s1_we_i,
	input		wire				s1_select_i,
	output		reg[`RegBus]		s1_data_o,
	output		reg					s1_ack_o,

	//slave 2 interface
	input		wire[`RegBus]		s2_data_i,
	input		wire[`RegBus]		s2_addr_i,
	input		wire				s2_we_i,
	input		wire				s2_select_i,
	output		reg[`RegBus]		s2_data_o,
	output		reg					s2_ack_o,

	//slave 3 interface
	input		wire[`RegBus]		s3_data_i,
	input		wire[`RegBus]		s3_addr_i,
	input		wire				s3_we_i,
	input		wire				s3_select_i,
	output		reg[`RegBus]		s3_data_o,
	output		reg					s3_ack_o,

	//slave 4 interface
	input		wire[`RegBus]		s4_data_i,
	input		wire[`RegBus]		s4_addr_i,
	input		wire				s4_we_i,
	input		wire				s4_select_i,
	output		reg[`RegBus]		s4_data_o,
	output		reg					s4_ack_o,

	//slave 5 interface
	input		wire[`RegBus]		s5_data_i,
	input		wire[`RegBus]		s5_addr_i,
	input		wire				s5_we_i,
	input		wire				s5_select_i,
	output		reg[`RegBus]		s5_data_o,
	output		reg					s5_ack_o,

	//slave 6 interface
	input		wire[`RegBus]		s6_data_i,
	input		wire[`RegBus]		s6_addr_i,
	input		wire				s6_we_i,
	input		wire				s6_select_i,
	output		reg[`RegBus]		s6_data_o,
	output		reg					s6_ack_o,

	//slave 7 interface
	input		wire[`RegBus]		s7_data_i,
	input		wire[`RegBus]		s7_addr_i,
	input		wire				s7_we_i,
	input		wire				s7_select_i,
	output		reg[`RegBus]		s7_data_o,
	output		reg					s7_ack_o
);

//local wires
wire		[`RegBus]			ms0_data_i;
wire		[`RegBus]			ms0_data_o;
wire		[`RegBus]			ms0_addr;
wire							ms0_select;
wire							ms0_we;
wire							ms0_ack;

wire		[`RegBus]			ms1_data_i;
wire		[`RegBus]			ms1_data_o;
wire		[`RegBus]			ms1_addr;
wire							ms1_select;
wire							ms1_we;
wire							ms1_ack;

wire		[`RegBus]			ms2_data_i;
wire		[`RegBus]			ms2_data_o;
wire		[`RegBus]			ms2_addr;
wire							ms2_select;
wire							ms2_we;
wire							ms2_ack;

wire		[`RegBus]			ms3_data_i;
wire		[`RegBus]			ms3_data_o;
wire		[`RegBus]			ms3_addr;
wire							ms3_select;
wire							ms3_we;
wire							ms3_ack;

wire		[`RegBus]			ms4_data_i;
wire		[`RegBus]			ms4_data_o;
wire		[`RegBus]			ms4_addr;
wire							ms4_select;
wire							ms4_we;
wire							ms4_ack;

wire		[`RegBus]			ms5_data_i;
wire		[`RegBus]			ms5_data_o;
wire		[`RegBus]			ms5_addr;
wire							ms5_select;
wire							ms5_we;
wire							ms5_ack;

wire		[`RegBus]			ms6_data_i;
wire		[`RegBus]			ms6_data_o;
wire		[`RegBus]			ms6_addr;
wire							ms6_select;
wire							ms6_we;
wire							ms6_ack;

wire		[`RegBus]			ms7_data_i;
wire		[`RegBus]			ms7_data_o;
wire		[`RegBus]			ms7_addr;
wire							ms7_select;
wire							ms7_we;
wire							ms7_ack;

//master interfaces
bus_master_if m0(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),
	.bus_data_i(	m_data_i		),
	.bus_data_o(	m_data_o		),
	.bus_addr_i(	m_addr_i		),
	.bus_select_i(	m_select_i		),
	.bus_we_i(		m_we_i			),
	.bus_ack_o(		m_ack_o			),

	.s0_data_i(		ms0_data_i		),
	.s0_data_o(		ms0_data_o		),
	.s0_addr_o(		ms0_addr		),
	.s0_select_o(	ms0_select		),
	.s0_we_o(		ms0_we			),
	.s0_ack_i(		ms0_ack			),

	.s1_data_i(		ms1_data_i		),
	.s1_data_o(		ms1_data_o		),
	.s1_addr_o(		ms1_addr		),
	.s1_select_o(	ms1_select		),
	.s1_we_o(		ms1_we			),
	.s1_ack_i(		ms1_ack			),
	
	.s2_data_i(		ms2_data_i		),
	.s2_data_o(		ms2_data_o		),
	.s2_addr_o(		ms2_addr		),
	.s2_select_o(	ms2_select		),
	.s2_we_o(		ms2_we			),
	.s2_ack_i(		ms2_ack			),
	
	.s3_data_i(		ms3_data_i		),
	.s3_data_o(		ms3_data_o		),
	.s3_addr_o(		ms3_addr		),
	.s3_select_o(	ms3_select		),
	.s3_we_o(		ms3_we			),
	.s3_ack_i(		ms3_ack			),
	
	.s4_data_i(		ms4_data_i		),
	.s4_data_o(		ms4_data_o		),
	.s4_addr_o(		ms4_addr		),
	.s4_select_o(	ms4_select		),
	.s4_we_o(		ms4_we			),
	.s4_ack_i(		ms4_ack			),
	
	.s5_data_i(		ms5_data_i		),
	.s5_data_o(		ms5_data_o		),
	.s5_addr_o(		ms5_addr		),
	.s5_select_o(	ms5_select		),
	.s5_we_o(		ms5_we			),
	.s5_ack_i(		ms5_ack			),

	.s6_data_i(		ms6_data_i		),
	.s6_data_o(		ms6_data_o		),
	.s6_addr_o(		ms6_addr		),
	.s6_select_o(	ms6_select		),
	.s6_we_o(		ms6_we			),
	.s6_ack_i(		ms6_ack			),
	
	.s7_data_i(		ms7_data_i		),
	.s7_data_o(		ms7_data_o		),
	.s7_addr_o(		ms7_addr		),
	.s7_select_o(	ms7_select		),
	.s7_we_o(		ms7_we			),
	.s7_ack_i(		ms7_ack			)
);

//slave interface
bus_slave_if s0(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s0_data_i		),
	.bus_data_o(	s0_data_o		),
	.bus_addr_o(	s0_addr_o		),
	.bus_select_o(	s0_select_o		),
	.bus_we_o(		s0_we_o			),
	.bus_ack_i(		s0_ack_i		),

	.m_data_i(		ms0_data_o		),
	.m_data_o(		ms0_data_i		),
	.m_addr_i(		ms0_addr		),
	.m_select_i(	ms0_select		),
	.m_we_i(		ms0_we			),
	.m_ack_o(		ms0_ack			)
);

bus_slave_if s1(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s1_data_i		),
	.bus_data_o(	s1_data_o		),
	.bus_addr_o(	s1_addr_o		),
	.bus_select_o(	s1_select_o		),
	.bus_we_o(		s1_we_o			),
	.bus_ack_i(		s1_ack_i		),

	.m_data_i(		ms1_data_o		),
	.m_data_o(		ms1_data_i		),
	.m_addr_i(		ms1_addr		),
	.m_select_i(	ms1_select		),
	.m_we_i(		ms1_we			),
	.m_ack_o(		ms1_ack			)
);

bus_slave_if s2(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s2_data_i		),
	.bus_data_o(	s2_data_o		),
	.bus_addr_o(	s2_addr_o		),
	.bus_select_o(	s2_select_o		),
	.bus_we_o(		s2_we_o			),
	.bus_ack_i(		s2_ack_i		),

	.m_data_i(		ms2_data_o		),
	.m_data_o(		ms2_data_i		),
	.m_addr_i(		ms2_addr		),
	.m_select_i(	ms2_select		),
	.m_we_i(		ms2_we			),
	.m_ack_o(		ms2_ack			)
);

bus_slave_if s3(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s3_data_i		),
	.bus_data_o(	s3_data_o		),
	.bus_addr_o(	s3_addr_o		),
	.bus_select_o(	s3_select_o		),
	.bus_we_o(		s3_we_o			),
	.bus_ack_i(		s3_ack_i		),

	.m_data_i(		ms3_data_o		),
	.m_data_o(		ms3_data_i		),
	.m_addr_i(		ms3_addr		),
	.m_select_i(	ms3_select		),
	.m_we_i(		ms3_we			),
	.m_ack_o(		ms3_ack			)
);

bus_slave_if s4(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s4_data_i		),
	.bus_data_o(	s4_data_o		),
	.bus_addr_o(	s4_addr_o		),
	.bus_select_o(	s4_select_o		),
	.bus_we_o(		s4_we_o			),
	.bus_ack_i(		s4_ack_i		),

	.m_data_i(		ms4_data_o		),
	.m_data_o(		ms4_data_i		),
	.m_addr_i(		ms4_addr		),
	.m_select_i(	ms4_select		),
	.m_we_i(		ms4_we			),
	.m_ack_o(		ms4_ack			)
);

bus_slave_if s5(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s5_data_i		),
	.bus_data_o(	s5_data_o		),
	.bus_addr_o(	s5_addr_o		),
	.bus_select_o(	s5_select_o		),
	.bus_we_o(		s5_we_o			),
	.bus_ack_i(		s5_ack_i		),

	.m_data_i(		ms5_data_o		),
	.m_data_o(		ms5_data_i		),
	.m_addr_i(		ms5_addr		),
	.m_select_i(	ms5_select		),
	.m_we_i(		ms5_we			),
	.m_ack_o(		ms5_ack			)
);

bus_slave_if s6(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s6_data_i		),
	.bus_data_o(	s6_data_o		),
	.bus_addr_o(	s6_addr_o		),
	.bus_select_o(	s6_select_o		),
	.bus_we_o(		s6_we_o			),
	.bus_ack_i(		s6_ack_i		),

	.m_data_i(		ms6_data_o		),
	.m_data_o(		ms6_data_i		),
	.m_addr_i(		ms6_addr		),
	.m_select_i(	ms6_select		),
	.m_we_i(		ms6_we			),
	.m_ack_o(		ms6_ack			)
);

bus_slave_if s7(
	.clk_i(			clk_i			),
	.rst_i(			rst_i			),

	.bus_data_i(	s7_data_i		),
	.bus_data_o(	s7_data_o		),
	.bus_addr_o(	s7_addr_o		),
	.bus_select_o(	s7_select_o		),
	.bus_we_o(		s7_we_o			),
	.bus_ack_i(		s7_ack_i		),

	.m_data_i(		ms7_data_o		),
	.m_data_o(		ms7_data_i		),
	.m_addr_i(		ms7_addr		),
	.m_select_i(	ms7_select		),
	.m_we_i(		ms7_we			),
	.m_ack_o(		ms7_ack			)
);

endmodule
