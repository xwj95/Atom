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
	output 		reg[31:0]				rom_inst,

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
	output 		reg[0:6] 				digseg_seg

	//PS2侧的接口

	);

	reg[20:0] ram_input_addr;
	reg[31:0] ram_input_data;
	reg ram_chip_enable;
	reg ram_read_enable;
	reg ram_write_enable;
	reg[31:0] ram_output_data;
	reg ram_ack;

	reg rom_chip_enable;
	reg[`InstAddrBus] rom_input_addr;
	reg[`InstBus] rom_output_inst;
	reg rom_ack;

	reg flash_read_enable;
	reg flash_erase_enable;
	reg flash_write_enable;
	reg[21:0] flash_input_addr;
	reg[15:0] flash_input_data;
	reg[15:0] flash_output_data;
	reg flash_ack;

	reg[7:0] uart_input_data;
	reg[7:0] uart_output_data;
	reg uart_TxD_start;
	reg uart_ack;

	reg[3:0] digseg_input_data;
	reg digseg_ack;

	initial wishbone_ack_o = 1'b0;

	always @ (posedge clk) begin
		ram_input_addr <= 0;
		ram_input_data <= `ZeroWord;
		ram_chip_enable <= `ChipDisable;
		ram_read_enable <= `ReadDisable;
		ram_write_enable <= `WriteDisable;
		ram_output_data <= `ZeroWord;
		ram_ack <= 0;
		rom_chip_enable <= `ChipDisable;
		rom_input_addr <= `ZeroWord;
		rom_output_inst <= `ZeroWord;
		rom_ack <= 0;
		flash_read_enable <= `ReadDisable;
		flash_erase_enable <= 0;
		flash_write_enable <= `WriteDisable;
		flash_input_addr <= 0;
		flash_input_data <= 0;
		flash_output_data <= 0;
		flash_ack <= 0;
		uart_input_data <= 0;
		uart_output_data <= 0;
		uart_TxD_start <= 0;
		uart_ack <= 0;
		digseg_input_data <= 0;
		digseg_ack <= 0;
		case (wishbone_select_i)
			`WB_SELECT_RAM: begin
				ram_input_addr <= {wishbone_addr_i[19], wishbone_addr_i[19:0]};
				ram_input_data <= wishbone_data_i;
				ram_chip_enable <= `ChipEnable;
				ram_read_enable <= ~wishbone_we_i;
				ram_write_enable <= wishbone_we_i;
				wishbone_data_o <= ram_output_data;
				wishbone_ack_o <= ram_ack;
			end
			`WB_SELECT_ROM: begin
				rom_chip_enable <= `ChipEnable;
				rom_input_addr <= wishbone_addr_i;
				wishbone_data_o <= rom_output_inst;
				wishbone_ack_o <= ram_ack;
			end
			`WB_SELECT_FLASH: begin
				flash_read_enable <= ~wishbone_we_i;
				flash_input_addr <= wishbone_addr_i[21:0];
				flash_input_data <= wishbone_data_i[15:0];
				wishbone_data_o <= {16'b0, flash_output_data};
				wishbone_ack_o <= flash_ack;
			end
			`WB_SELECT_VGA: begin
			end
			`WB_SELECT_UART: begin
				uart_input_data <= wishbone_data_i[7:0];
				wishbone_data_o <= {24'b0, uart_output_data};
				uart_TxD_start <= wishbone_we_i;
				wishbone_ack_o <= uart_ack;
			end
			`WB_SELECT_UART_STAT: begin
			end
			`WB_SELECT_DIGSEG: begin
				digseg_input_data <= wishbone_data_i[3:0];
				wishbone_ack_o <= digseg_ack;
			end
			`WB_SELECT_PS2: begin
			end
			default: begin
			end
		endcase
	end

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

	inst_rom rom0(
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
	.data_in(uart_input_data),
	.data_out(uart_output_data),
	.TxD_start(uart_TxD_start), 
	.TxD_busy(uart_TxD_busy), 
	.RxD_data_ready(uart_RxD_data_ready), 
	.com_TxD(uart_com_TxD), 
	.com_RxD(uart_com_RxD), 
	.ack(uart_ack)
	);

	digseg_driver digseg0(
	.data(digseg_input_data), 
	.seg(digseg_seg), 
	.ack(digseg_ack)
	);
endmodule
