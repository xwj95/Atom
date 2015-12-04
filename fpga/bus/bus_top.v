`include "defines.v"

module bus_top(
	input		wire					clk,
	input		wire					rst,

	//Wishbone侧的接口
	input		wire[`WB_AddrBus]		wishbone_addr_i,
	input		wire[`WB_DataBus]		wishbone_data_i,
	input		wire					wishbone_we_i,		//1代表写，0代表�
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
	output		[`FlashAddrBus]			flash_addr,
	inout		[`FlashDataBus]			flash_data,
	output		[`FlashCtrlBus]			flash_ctl,

	//VGA侧的接口

	//UART侧的接口
	output								uart_com_TxD,
	input								uart_com_RxD,

	//segdisp侧的接口
	output		[`DigSegDataBus]		digseg_seg1,
	output		[`DigSegDataBus]		digseg_seg0

	//PS2侧的接口

	);

	//slave 3 interface - VGA
	wire[`WB_DataBus]	s3_data_o;
	wire[`WB_AddrBus]	s3_addr_o;
	wire				s3_we_o;
	wire				s3_select_o;
	reg[`WB_DataBus]	s3_data_i = 0;
	reg					s3_ack_i = 0;

	//slave 5 interface - UART_STAT
	wire[`WB_DataBus]	s5_data_o;
	wire[`WB_AddrBus]	s5_addr_o;
	wire				s5_we_o;
	wire				s5_select_o;
	reg[`WB_DataBus]	s5_data_i = 0;
	reg					s5_ack_i = 0;

	//slave 7 interface - PS2
	wire[`WB_DataBus]	s7_data_o;
	wire[`WB_AddrBus]	s7_addr_o;
	wire				s7_we_o;
	wire				s7_select_o;
	reg[`WB_DataBus]	s7_data_i = 0;
	reg					s7_ack_i = 0;

	wire[`WB_AddrBus] ram_addr_o;
	wire[`WB_DataBus] ram_data_i;
	wire[`WB_DataBus] ram_data_o;
	wire ram_select_o;
	wire ram_we_o;
	wire ram_ack_i;

	wire[`WB_AddrBus] rom_addr_o;
	wire[`WB_DataBus] rom_data_i;
	wire[`WB_DataBus] rom_data_o;
	wire rom_select_o;
	wire rom_we_o;
	wire rom_ack_i;

	wire[`WB_AddrBus] flash_addr_o;
	wire[`WB_DataBus] flash_data_i;
	wire[`WB_DataBus] flash_data_o;
	wire flash_select_o;
	wire flash_we_o;
	wire flash_ack_i;

	wire[`WB_AddrBus] uart_addr_o;
	wire[`WB_DataBus] uart_data_i;
	wire[`WB_DataBus] uart_data_o;
	wire uart_select_o;
	wire uart_we_o;
	wire uart_ack_i;

	wire[`WB_AddrBus] digseg_addr_o;
	wire[`WB_DataBus] digseg_data_i;
	wire[`WB_DataBus] digseg_data_o;
	wire digseg_select_o;
	wire digseg_we_o;
	wire digseg_ack_i;

	bus bus0(
		.m_data_i(bus_data_i),
		.m_addr_i(bus_addr_i),
		.m_we_i(bus_we_i),
		.m_select_i(bus_select_i),
		.m_data_o(bus_data_o),
		.m_ack_o(bus_ack_o),
		.s0_data_o(ram_data_o),
		.s0_addr_o(ram_addr_o),
		.s0_we_o(ram_we_o),
		.s0_select_o(ram_select_o),
		.s0_data_i(ram_data_i),
		.s0_ack_i(ram_ack_i),
		.s1_data_o(rom_data_o),
		.s1_addr_o(rom_addr_o),
		.s1_we_o(rom_we_o),
		.s1_select_o(rom_select_o),
		.s1_data_i(rom_data_i),
		.s1_ack_i(rom_ack_i),
		.s2_data_o(flash_data_o),
		.s2_addr_o(flash_addr_o),
		.s2_we_o(flash_we_o),
		.s2_select_o(flash_select_o),
		.s2_data_i(flash_data_i),
		.s2_ack_i(flash_ack_i),
		.s3_data_o(s3_data_o),
		.s3_addr_o(s3_addr_o),
		.s3_we_o(s3_we_o),
		.s3_select_o(s3_select_o),
		.s3_data_i(s3_data_i),
		.s3_ack_i(s3_ack_i),
		.s4_data_o(uart_data_o),
		.s4_addr_o(uart_addr_o),
		.s4_we_o(uart_we_o),
		.s4_select_o(uart_select_o),
		.s4_data_i(uart_data_i),
		.s4_ack_i(uart_ack_i),
		.s5_data_o(s5_data_o),
		.s5_addr_o(s5_addr_o),
		.s5_we_o(s5_we_o),
		.s5_select_o(s5_select_o),
		.s5_data_i(s5_data_i),
		.s5_ack_i(s5_ack_i),
		.s6_data_o(digseg_data_o),
		.s6_addr_o(digseg_addr_o),
		.s6_we_o(digseg_we_o),
		.s6_select_o(digseg_select_o),
		.s6_data_i(digseg_data_i),
		.s6_ack_i(digseg_ack_i),
		.s7_data_o(s7_data_o),
		.s7_addr_o(s7_addr_o),
		.s7_we_o(s7_we_o),
		.s7_select_o(s7_select_o),
		.s7_data_i(s7_data_i),
		.s7_ack_i(s7_ack_i)
	);

	ram ram0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(ram_addr_o),
		.bus_data_i(ram_data_o),
		.bus_data_o(ram_data_i),
		.bus_select_i(ram_select_o),
		.bus_we_i(ram_we_o),
		.bus_ack_o(ram_ack_i),
		.baseram_addr(ram_baseram_addr),
		.baseram_data(ram_baseram_data),
		.baseram_ce(ram_baseram_ce),
		.baseram_oe(ram_baseram_oe),
		.baseram_we(ram_baseram_we),
		.extram_addr(ram_extram_addr),
		.extram_data(ram_extram_data),
		.extram_ce(ram_extram_ce),
		.extram_oe(ram_extram_oe),
		.extram_we(ram_extram_we)
	);	

	rom rom0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(rom_addr_o),
		.bus_data_i(rom_data_o),
		.bus_data_o(rom_data_i),
		.bus_select_i(rom_select_o),
		.bus_we_i(rom_we_o),
		.bus_ack_o(rom_ack_i)
	);

	flash flash0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(flash_addr_o),
		.bus_data_i(flash_data_o),
		.bus_data_o(flash_data_i),
		.bus_select_i(flash_select_o),
		.bus_we_i(flash_we_o),
		.bus_ack_o(flash_ack_i),
		.flash_addr(flash_addr),
		.flash_data(flash_data),
		.flash_ctl(flash_ctl)
	);

	uart uart0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(uart_addr_o),
		.bus_data_i(uart_data_o),
		.bus_data_o(uart_data_i),
		.bus_select_i(uart_select_o),
		.bus_we_i(uart_we_o),
		.bus_ack_o(uart_ack_i),
		.com_TxD(uart_com_TxD),
		.com_RxD(uart_com_RxD)
	);

	digseg digseg0(
		.clk(clk),
		.rst(rst),
		.bus_addr_i(digseg_addr_o),
		.bus_data_i(digseg_data_o),
		.bus_data_o(digseg_data_i),
		.bus_select_i(digseg_select_o),
		.bus_we_i(digseg_we_o),
		.bus_ack_o(digseg_ack_i),
		.seg0(digseg_seg0),
		.seg1(digseg_seg1)
	);

endmodule
