`include "defines.v"

module bus(
	input		wire					clk,
	input		wire					rst,

	//Wishbone侧的接口
	input		wire[`RegBus]			wishbone_addr_i,
	input		wire[`RegBus]			wishbone_data_i,
	input		wire					wishbone_we_i, 		//1代表写，0代表读
	input		wire[3:0]				wishbone_sel_i, 	//数据总线选择信号
	input		wire					wishbone_stb_i, 	//选通信号
	input		wire					wishbone_cyc_i, 	//总线周期信号
	input 		wire[15:0] 				wishbone_select_i,

	output 		reg[`RegBus] 			wishbone_data_o,
	output 		reg 					wishbone_ack_o, 

	//RAM侧的接口
	output 		reg[19:0] 				ram_baseram_addr, 
	inout 		wire[31:0] 				ram_baseram_data, 
	output 		reg 					ram_baseram_ce, 
	output 		reg 					ram_baseram_oe, 
	output 		reg 					ram_baseram_we, 
	output 		reg[19:0] 				ram_extram_addr, 
	inout 		wire[31:0] 				ram_extram_data, 
	output 		reg 					ram_extram_ce, 
	output 		reg 					ram_extram_oe, 
	output 		reg 					ram_extram_we, 

	//ROM侧的接口
	output 		reg 					rom_inst,

	//FLASH侧的接口
	output 		reg 					flash_busy, 
	output 		reg[22:0] 				flash_addr, 
	inout 		wire[15:0] 				flash_data, 
	output 		reg[7:0] 				flash_ctl,

	//VGA侧的接口

	//UART侧的接口
	output 		reg 					uart_TxD_busy,
	output 		reg 					uart_RxD_data_ready, 
	output 		reg 					uart_com_TxD, 
	input 		wire					uart_com_RxD, 

	//segdisp侧的接口
	output 		reg[0:6] 				segdisp

	//PS2侧的接口

	);

	localparam
		RAM: 16'h0000,
		ROM: 16'h0001, 
		FLASH: 16'h0002, 
		VGA: 16'h0003, 
		UART: 16'h0004, 
		SEGDISP: 16'h0005, 
		PS2: 16'h0006;

	initial wishbone_ack_o <= 1'b0;

	always @ (posedge clk) begin
		case (wishbone_select_i)
			RAM: begin
				ram ram0(
				.clk(clk), .rst(rst), 
				.input_addr({wishbone_addr_i[19], wishbone_addr_i[19:0]}),
				.input_data(wishbone_data_i), 
				.chip_enable(1'b1), 
				.read_enable(~wishbone_we_i),
				.write_enable(wishbone_we_i), 
				.output_data(wishbone_data_o), 
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
				wishbone_ack_o <= 1'b1;				
			end
			ROM: begin
				inst_rom rom0(
				.ce(wishbone_we_i), 
				.addr(wishbone_addr_i), 
				.inst(rom_inst)
				);
				wishbone_ack_o <= 1'b1;
			end
			FLASH: begin
				flash flash0(
				.clk(clk), 
				.enable_read(~wishbone_we_i), 
				.enable_erase(), .enable_write(), 
				.input_addr(wishbone_addr_i[21:0]), 
				.input_data(wishbone_data_i[7:0]), 
				.output_data(wishbone_data_o[7:0]), 
				.flash_busy(flash_busy), 
				.flash_addr(flash_addr), 
				.flash_data(flash_data), 
				.flash_ctl(flash_ctl)
				);
				wishbone_ack_o <= 1'b1;
			end
			VGA: begin
				wishbone_ack_o <= 1'b1;
			end
			UART: begin
				uart uart0(
				.clk(clk), .rst(rst), 
				.data_in(wishbone_data_i[7:0]),
				.data_out(wishbone_data_o[7:0]),
				.TxD_start(wishbone_we_i), 
				.TxD_busy(uart_TxD_busy), 
				.RxD_data_ready(uart_RxD_data_ready), 
				.com_TxD(uart_com_TxD), 
				.com_RxD(uart_com_RxD)
				);
				wishbone_ack_o <= 1'b1;
			end
			SEGDISP: begin
				digseg_driver digseg0(
				.data(wishbone_data_i[3:0]), 
				.seg(segdisp[0:6])
				);
				wishbone_ack_o <= 1'b1;
			end
			PS2: begin
				wishbone_ack_o <= 1'b1;
			end
		endcase
	end



endmodule
