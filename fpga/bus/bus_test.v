module bus_test (
	input clk,
	input rst,
	input [31:0] sw_dip,
	output [15:0] led, 

	//RAMä¾§çš„æŽ¥å�
	output 		[19:0] 				baseram_addr, 
	inout 		[31:0] 				baseram_data, 
	output 		 					baseram_ce, 
	output 		 					baseram_oe, 
	output 		 					baseram_we, 
	output 		[19:0] 				extram_addr, 
	inout 		[31:0] 				extram_data, 
	output 		 					extram_ce, 
	output 		 					extram_oe, 
	output 		 					extram_we, 

	//FLASHä¾§çš„æŽ¥å�
	output 		[22:0] 				flash_addr, 
	inout 		[15:0] 				flash_data, 
	output 		[7:0] 				flash_ctl,

	//VGAä¾§çš„æŽ¥å�

	//UARTä¾§çš„æŽ¥å�
	output 		 					com_TxD, 
	input 							com_RxD, 

	//segdispä¾§çš„æŽ¥å�
	output 		[0:6] 				segdisp0,
	output 		[0:6]				segdisp1
);
	wire[31:0] output_data;
	wire output_ack;
	assign led = {output_ack, output_data[14:0]};

	bus bus0 (
	.clk(clk), .rst(rst), 
	.wishbone_addr_i({24'b0, sw_dip[7:0]}), 
	.wishbone_data_i({24'b0, sw_dip[15:8]}), 
	.wishbone_we_i(sw_dip[31]), 
	.wishbone_stb_i(), 
	.wishbone_cyc_i(), 
	.wishbone_select_i({8'b0, sw_dip[23:16]}), 
	.wishbone_data_o(output_data), 
	.wishbone_ack_o(output_ack),
	.ram_baseram_addr(baseram_addr), 
	.ram_baseram_data(baseram_data), 
	.ram_baseram_ce(baseram_ce), 
	.ram_baseram_oe(baseram_oe), 
	.ram_baseram_we(baseram_we), 
	.ram_extram_addr(extram_addr), 
	.ram_extram_data(extram_data), 
	.ram_extram_ce(extram_ce), 
	.ram_extram_oe(extram_oe), 
	.ram_extram_we(extram_we), 
	.rom_inst(), 
	.flash_busy(), 
	.flash_addr(flash_addr), 
	.flash_data(flash_data), 
	.flash_ctl(flash_ctl), 
	.uart_TxD_busy(), 
	.uart_RxD_data_ready(), 
	.uart_com_TxD(com_TxD), 
	.uart_com_RxD(com_RxD), 
	.digseg_seg0(segdisp0),
	.digseg_seg1(segdisp1)
	);


endmodule
