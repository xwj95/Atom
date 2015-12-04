`include "defines.v"

module bus_top(
	input		wire					clk,
	input		wire					rst,

	//Wishbone侧的接口
	input		wire[`WB_AddrBus]		wishbone_addr_i,
	input		wire[`WB_DataBus]		wishbone_data_i,
	input		wire					wishbone_we_i,		//1代表写，0代表读
	input		wire					wishbone_stb_i,	
	input		wire					wishbone_cyc_i,
	input		wire[`WB_SelectBus]		wishbone_select_i,

	output		reg[`WB_DataBus]		wishbone_data_o,
	output		reg						wishbone_ack_o,

	//RAM侧的接口
	output		[`DataMemNumLog2-2:0]	ram_baseram_addr,
	inout		[`DataBus]				ram_baseram_data,
	output								ram_baseram_ce,
	output								ram_baseram_oe,
	output								ram_baseram_we,
	output		[`DataMemNumLog2-2:0]	ram_extram_addr,
	inout		[`DataBus]				ram_extram_data,
	output								ram_extram_ce,
	output								ram_extram_oe,
	output								ram_extram_we,

	//ROM侧的接口

	//FLASH侧的接口
	output								flash_busy,
	output		[`FlashAddrBus]			flash_addr,
	inout		[`FlashDataBus]			flash_data,
	output		[`FlashCtrlBus]			flash_ctl,

	//VGA侧的接口

	//UART侧的接口
	output								uart_TxD_busy,
	output								uart_RxD_data_ready,
	output								uart_com_TxD,
	input								uart_com_RxD,

	//segdisp侧的接口
	output		[`DigSegDataBus]		digseg_seg1,
	output		[`DigSegDataBus]		digseg_seg0

	//PS2侧的接口

	);

	//slave 0 interface
	wire[`WB_DataBus]	s0_data_o;
	wire[`WB_AddrBus]	s0_addr_o;
	wire				s0_we_o;
	wire				s0_select_o;
	reg[`WB_DataBus]	s0_data_i;
	reg					s0_ack_i;

	//slave 1 interface
	wire[`WB_DataBus]	s1_data_o;
	wire[`WB_AddrBus]	s1_addr_o;
	wire				s1_we_o;
	wire				s1_select_o;
	reg[`WB_DataBus]	s1_data_i;
	reg					s1_ack_i;

	//slave 2 interface
	wire[`WB_DataBus]	s2_data_o;
	wire[`WB_AddrBus]	s2_addr_o;
	wire				s2_we_o;
	wire				s2_select_o;
	reg[`WB_DataBus]	s2_data_i;
	reg					s2_ack_i;

	//slave 3 interface
	wire[`WB_DataBus]	s3_data_o;
	wire[`WB_AddrBus]	s3_addr_o;
	wire				s3_we_o;
	wire				s3_select_o;
	reg[`WB_DataBus]	s3_data_i;
	reg					s3_ack_i;

	//slave 4 interface
	wire[`WB_DataBus]	s4_data_o;
	wire[`WB_AddrBus]	s4_addr_o;
	wire				s4_we_o;
	wire				s4_select_o;
	reg[`WB_DataBus]	s4_data_i;
	reg					s4_ack_i;

	//slave 5 interface
	wire[`WB_DataBus]	s5_data_o;
	wire[`WB_AddrBus]	s5_addr_o;
	wire				s5_we_o;
	wire				s5_select_o;
	reg[`WB_DataBus]	s5_data_i;
	reg					s5_ack_i;

	//slave 6 interface
	wire[`WB_DataBus]	s6_data_o;
	wire[`WB_AddrBus]	s6_addr_o;
	wire				s6_we_o;
	wire				s6_select_o;
	reg[`WB_DataBus]	s6_data_i;
	reg					s6_ack_i;

	//slave 7 interface
	wire[`WB_DataBus]	s7_data_o;
	wire[`WB_AddrBus]	s7_addr_o;
	wire				s7_we_o;
	wire				s7_select_o;
	reg[`WB_DataBus]	s7_data_i;
	reg					s7_ack_i;

	wire[`WB_AddrBus] ram_addr_i;
	wire[`WB_DataBus] ram_data_i;
	wire[`WB_DataBus] ram_data_o;
	wire ram_select_i;
	input bus_we_i;
	output bus_ack_o;

	wire[`WB_AddrBus] bus_addr_i;
	wire[`WB_DataBus] bus_data_i;
	reg[`WB_DataBus] bus_data_o;
	wire bus_select_i;
	wire bus_we_i;
	reg bus_ack_o;

	wire[`WB_AddrBus] bus_addr_i;
	wire[`WB_DataBus] bus_data_i;
	reg[`WB_DataBus] bus_data_o;
	wire bus_select_i;
	wire bus_we_i;
	reg bus_ack_o;

	wire[`WB_AddrBus] bus_addr_i;
	wire[`WB_DataBus] bus_data_i;
	reg[`WB_DataBus] bus_data_o;
	wire bus_select_i;
	wire bus_we_i;
	reg bus_ack_o;

	wire[`WB_AddrBus] bus_addr_i;
	wire[`WB_DataBus] bus_data_i;
	reg[`WB_DataBus] bus_data_o;
	wire bus_select_i;
	wire bus_we_i;
	reg bus_ack_o;

	bus bus0(
		.m_data_i(bus_data_i),
		.m_addr_i(bus_addr_i),
		.m_we_i(bus_we_i),
		.m_select_i(bus_select_i),
		.m_data_o(bus_data_o),
		.m_ack_o(bus_ack_o),
		.s0_data_i(s0_data_i),
		.s0_addr_i(s0_addr_i),
		.s0_we_i(s0_we_i),
		.s0_select_i(s0_select_i),
		.s0_data_o(s0_data_o),
		.s0_ack_o(s0_ack_o),
		.s1_data_i(s1_data_i),
		.s1_addr_i(s1_addr_i),
		.s1_we_i(s1_we_i),
		.s1_select_i(s1_select_i),
		.s1_data_o(s1_data_o),
		.s1_ack_o(s1_ack_o),
		.s2_data_i(s2_data_i),
		.s2_addr_i(s2_addr_i),
		.s2_we_i(s2_we_i),
		.s2_select_i(s2_select_i),
		.s2_data_o(s2_data_o),
		.s2_ack_o(s2_ack_o),
		.s3_data_i(s3_data_i),
		.s3_addr_i(s3_addr_i),
		.s3_we_i(s3_we_i),
		.s3_select_i(s3_select_i),
		.s3_data_o(s3_data_o),
		.s3_ack_o(s3_ack_o),
		.s4_data_i(s4_data_i),
		.s4_addr_i(s4_addr_i),
		.s4_we_i(s4_we_i),
		.s4_select_i(s4_select_i),
		.s4_data_o(s4_data_o),
		.s4_ack_o(s4_ack_o),
		.s5_data_i(s5_data_i),
		.s5_addr_i(s5_addr_i),
		.s5_we_i(s5_we_i),
		.s5_select_i(s5_select_i),
		.s5_data_o(s5_data_o),
		.s5_ack_o(s5_ack_o),
		.s6_data_i(s6_data_i),
		.s6_addr_i(s6_addr_i),
		.s6_we_i(s6_we_i),
		.s6_select_i(s6_select_i),
		.s6_data_o(s6_data_o),
		.s6_ack_o(s6_ack_o),
		.s7_data_i(s7_data_i),
		.s7_addr_i(s7_addr_i),
		.s7_we_i(s7_we_i),
		.s7_select_i(s7_select_i),
		.s7_data_o(s7_data_o),
		.s7_ack_o(s7_ack_o)
	);

	ram ram0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(ram_input_addr),
		.bus_data_i(ram_input_data),
		.bus_data_o(ram_output_data),
		.bus_select_i(ram_chip_enable),
		.bus_we_i(ram_write_enable),
		.bus_ack_o(ram_ack),
		.baseram_addr(baseram_addr),
		.baseram_data(baseram_data),
		.baseram_ce(baseram_ce),
		.baseram_oe(baseram_oe),
		.baseram_we(baseram_we),
		.extram_addr(extram_addr),
		.extram_data(extram_data),
		.extram_ce(extram_ce),
		.extram_oe(extram_oe),
		.extram_we(extram_we)
	);	

	rom rom0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(rom_input_addr),
		.bus_data_i(),
		.bus_data_o(rom_output_inst),
		.bus_select_i(rom_chip_enable),
		.bus_we_i(),
		.bus_ack_o(rom_ack)
	);

	flash flash0(
		clk(clk),
		rst(rst),
		bus_addr_i(flash_input_addr),
		bus_data_i(flash_input_data),
		bus_data_o(flash_output_data),
		bus_select_i(),
		bus_we_i(flash_write_enable),
		bus_ack_o(flash_ack),
		flash_addr(flash_addr),
		flash_data(flash_data),
		flash_ctl(flash_ctl)
	);

	uart uart0(
		clk(clk),
		rst(rst),
		bus_addr_i(),
		bus_data_i(uart_input_data),
		bus_data_o(uart_output_data),
		bus_select_i(uart_enable),
		bus_we_i(uart_TxD_start),
		bus_ack_o(uart_ack),
		com_TxD(uart_com_TxD),
		com_RxD(uart_com_RxD)
	);

	digseg digseg0(
		clk(clk),
		rst(rst),
		bus_addr_i(),
		bus_data_i(digseg_input_data0),
		bus_data_o(),
		bus_select_i(),
		bus_we_i(),
		bus_ack_o(digseg_ack),
		seg(digseg_seg0)
	);
	
	digseg digseg1(
		.data(digseg_input_data1),
		.seg(digseg_seg1),
		.ack(digseg_ack)
	);

endmodule
