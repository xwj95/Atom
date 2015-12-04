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

	reg[`DataMemNumLog2-1:0] ram_input_addr;
	reg[`DataBus] ram_input_data;
	reg ram_chip_enable;
	reg ram_read_enable;
	reg ram_write_enable;
	wire[`DataBus] ram_output_data;
	wire ram_ack;

	reg rom_chip_enable;
	reg[`RomAddrBus] rom_input_addr;
	wire[`InstBus] rom_output_inst;
	wire rom_ack;

	reg flash_read_enable;
	reg flash_erase_enable;
	reg flash_write_enable;
	reg[`FlashAddrBusWord] flash_input_addr;
	reg[`FlashDataBus] flash_input_data;
	wire[`FlashCtrlBus] flash_output_data;
	wire flash_ack;

	reg[`DigSegDataBus] uart_input_data;
	wire[`DigSegDataBus] uart_output_data;
	reg uart_enable;
	reg uart_TxD_start;
	wire uart_ack_t;
	wire uart_ack_r;

	reg[`DigSegAddrBus] digseg_input_data1;
	reg[`DigSegAddrBus] digseg_input_data0;
	wire digseg_ack;

	bus bus0(
		.m_data_i(wishbone_data_i),
		.m_addr_i(wishbone_addr_i),
		.m_we_i(wishbone_we_i),
		.m_select_i(wishbone_select_i),
		.m_data_o(wishbone_data_o),
		.m_ack_o(wishbone_ack_o),
		.s0_data_i(ram_input_data),
		.s0_addr_i({11'b0, ram_input_addr}),
		.s0_we_i(ram_write_enable),
		.s0_select_i(ram_chip_enable),
		.s0_data_o(ram_output_data),
		.s0_ack_o(ram_ack),
		.s1_data_i(),
		.s1_addr_i(rom_input_addr),
		.s1_we_i(),
		.s1_select_i(rom_chip_enable),
		.s1_data_o(rom_output_inst),
		.s1_ack_o(rom_ack),
		.s2_data_i({16'b0, flash_input_data}),
		.s2_addr_i({10'b0, flash_input_addr}),
		.s2_we_i(flash_write_enable),
		.s2_select_i(),
		.s2_data_o(flash_output_data),
		.s2_ack_o(flash_ack),
		.s3_data_i(),
		.s3_addr_i(),
		.s3_we_i(),
		.s3_select_i(),
		.s3_data_o(),
		.s3_ack_o(),
		.s4_data_i({24'b0, uart_input_data}),
		.s4_addr_i(),
		.s4_we_i(!uart_TxD_start),
		.s4_select_i(),
		.s4_data_o({24'b0, uart_output_data}),
		.s4_ack_o(uart_ack),
		.s5_data_i(),
		.s5_addr_i(),
		.s5_we_i(),
		.s5_select_i(),
		.s5_data_o(),
		.s5_ack_o(),
		.s6_data_i(),
		.s6_addr_i(),
		.s6_we_i(),
		.s6_select_i(),
		.s6_data_o(),
		.s6_ack_o(),
		.s7_data_i(),
		.s7_addr_i(),
		.s7_we_i(),
		.s7_select_i(),
		.s7_data_o(),
		.s7_ack_o()
	);

	ram ram0(
	.clk(clk), .rst(rst), 
	.input_addr(ram_input_addr),
	.input_data(ram_input_data), 
	.chip_enable(ram_chip_enable), 
	.read_enable(ram_read_enable),
	.write_enable(ram_write_enable), 
	.output_data(ram_output_data), 
	.baseram_addr(ram_baseram_addr), 
	.baseram_data(ram_baseram_data), 
	.baseram_ce(ram_baseram_ce), 
	.baseram_oe(ram_baseram_oe), 
	.baseram_we(ram_baseram_we), 
	.extram_addr(ram_extram_addr), 
	.extram_data(ram_extram_data), 
	.extram_ce(ram_extram_ce), 
	.extram_oe(ram_extram_oe), 
	.extram_we(ram_extram_we), 
	.ack(ram_ack)
	);	

	rom rom0(
	.ce(rom_chip_enable), 
	.addr(rom_input_addr), 
	.inst(rom_output_inst), 
	.ack(rom_ack)
	);

	flash flash0(
	.clk(clk), 
	.enable_read(flash_read_enable), 
	.enable_erase(flash_erase_enable),
	.enable_write(flash_write_enable), 
	.input_addr(flash_input_addr), 
	.input_data(flash_input_data), 
	.output_data(flash_output_data), 
	.flash_busy(flash_busy), 
	.flash_addr(flash_addr), 
	.flash_data(flash_data), 
	.flash_ctl(flash_ctl), 
	.ack(flash_ack)
	);

	uart uart0(
	.clk(clk), .rst(rst), 
	.enable(uart_enable), 
	.data_in(uart_input_data),
	.data_out(uart_output_data),
	.TxD_start(uart_TxD_start), 
	.TxD_busy(uart_TxD_busy), 
	.RxD_data_ready(uart_RxD_data_ready), 
	.com_TxD(uart_com_TxD), 
	.com_RxD(uart_com_RxD), 
	.ack_t(uart_ack_t), 
	.ack_r(uart_ack_r)
	);

	digseg digseg0(
	.data(digseg_input_data0), 
	.seg(digseg_seg0), 
	.ack(digseg_ack)
	);
	
	digseg_driver digseg1(
	.data(digseg_input_data1),
	.seg(digseg_seg1),
	.ack(digseg_ack)
	);

endmodule
