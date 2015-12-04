`include "defines.v"

module bus_top(
	input		wire				clk,
	input		wire				rst,

	//Wishbone侧的接口
	input		wire[`RegBus]		wishbone_addr_i,
	input		wire[`RegBus]		wishbone_data_i,
	input		wire				wishbone_we_i, 		//1代表写，0代表读	
	input		wire				wishbone_stb_i,	
	input		wire				wishbone_cyc_i,
	input 		wire[15:0] 			wishbone_select_i,

	output 		reg[`RegBus] 		wishbone_data_o,
	output 		reg 				wishbone_ack_o, 

	//RAM侧的接口
	output 		[19:0] 				ram_baseram_addr, 
	inout 		[31:0] 				ram_baseram_data, 
	output 		 					ram_baseram_ce, 
	output 		 					ram_baseram_oe, 
	output 		 					ram_baseram_we, 
	output 		[19:0] 				ram_extram_addr, 
	inout 		[31:0] 				ram_extram_data, 
	output 		 					ram_extram_ce, 
	output 		 					ram_extram_oe, 
	output 		 					ram_extram_we, 

	//ROM侧的接口
	output 		[31:0] 				rom_inst,

	//FLASH侧的接口
	output 		 					flash_busy, 
	output 		[22:0] 				flash_addr, 
	inout 		[15:0] 				flash_data, 
	output 		[7:0] 				flash_ctl,

	//VGA侧的接口

	//UART侧的接口
	output 		 					uart_TxD_busy,
	output 		 					uart_RxD_data_ready, 
	output 		 					uart_com_TxD, 
	input 							uart_com_RxD, 

	//segdisp侧的接口
	output 		[0:6] 				digseg_seg1,
	output		[0:6]				digseg_seg0

	//PS2侧的接口

	);

	reg[20:0] ram_input_addr;
	reg[31:0] ram_input_data;
	reg ram_chip_enable;
	reg ram_read_enable;
	reg ram_write_enable;
	wire[31:0] ram_output_data;
	wire ram_ack;

	reg rom_chip_enable;
	reg[`InstAddrBus] rom_input_addr;
	wire[`InstBus] rom_output_inst;
	wire rom_ack;

	reg flash_read_enable;
	reg flash_erase_enable;
	reg flash_write_enable;
	reg[21:0] flash_input_addr;
	reg[15:0] flash_input_data;
	wire[15:0] flash_output_data;
	wire flash_ack;

	reg[7:0] uart_input_data;
	wire[7:0] uart_output_data;
	reg uart_enable;
	reg uart_TxD_start;
	wire uart_ack_t;
	wire uart_ack_r;

	reg[3:0] digseg_input_data1;
	reg[3:0] digseg_input_data0;
	wire digseg_ack;

	initial wishbone_ack_o = 1'b0;

	always @ (posedge clk) begin
		ram_input_addr <= 21'b0;
		ram_input_data <= `ZeroWord;
		ram_chip_enable <= `ChipDisable;
		ram_read_enable <= `ReadDisable;
		ram_write_enable <= `WriteDisable;
		rom_chip_enable <= `ChipDisable;
		rom_input_addr <= `ZeroWord;
		flash_read_enable <= `ReadDisable;
		flash_erase_enable <= 1'b0;
		flash_write_enable <= `WriteDisable;
		flash_input_addr <= 22'b0;
		flash_input_data <= 16'b0;
		uart_input_data <= 8'b0;
		uart_TxD_start <= 1'b0;
		uart_enable <= 1'b0;
		digseg_input_data1 <= 4'b0;
		digseg_input_data0 <= 4'b0;
		case (wishbone_select_i)
			`WB_SELECT_ZERO: begin		
				ram_input_addr <= 21'b0;
				ram_input_data <= `ZeroWord;
				ram_chip_enable <= `ChipDisable;
				ram_read_enable <= `ReadDisable;
				ram_write_enable <= `WriteDisable;
				rom_chip_enable <= `ChipDisable;
				rom_input_addr <= `ZeroWord;
				flash_read_enable <= `ReadDisable;
				flash_erase_enable <= 1'b0;
				flash_write_enable <= `WriteDisable;
				flash_input_addr <= 22'b0;
				flash_input_data <= 16'b0;
				uart_input_data <= 8'b0;
				uart_TxD_start <= 1'b0;
				uart_enable <= 1'b0;
				digseg_input_data1 <= 4'b0;
				digseg_input_data0 <= 4'b0;
				wishbone_data_o <= 32'b0;
				wishbone_ack_o <= 1'b1;
			end
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
				if (wishbone_we_i == 1'b1) begin
					wishbone_data_o <= `ZeroWord;
					wishbone_ack_o <= 1'b1;
				end else begin
					wishbone_data_o <= rom_output_inst;
					wishbone_ack_o <= rom_ack;
				end
			end
			`WB_SELECT_FLASH: begin
				flash_read_enable <= ~wishbone_we_i;
				flash_write_enable <= `WriteDisable;
				flash_erase_enable <= 1'b0;
				flash_input_addr <= wishbone_addr_i[21:0];
				flash_input_data <= wishbone_data_i[15:0];
				wishbone_data_o <= {16'b0, flash_output_data};
				wishbone_ack_o <= flash_ack;
			end
			`WB_SELECT_VGA: begin
				wishbone_data_o <= 0;
			end
			`WB_SELECT_UART: begin
				uart_input_data <= wishbone_data_i[7:0];
				wishbone_data_o <= {24'b0, uart_output_data};
				uart_TxD_start <= ~wishbone_we_i;
				uart_enable <= 1'b1;
				if (wishbone_we_i == 1'b1)
					wishbone_ack_o <= uart_ack_t;
				else
					wishbone_ack_o <= uart_ack_r;
			end
			`WB_SELECT_UART_STAT: begin
				wishbone_data_o <= 0;
			end
			`WB_SELECT_DIGSEG: begin
				if (wishbone_we_i == 1'b0) begin
					digseg_input_data1 <= 0;
					digseg_input_data0 <= 0;
				end else begin
					digseg_input_data1 <= wishbone_data_i[7:4];
					digseg_input_data0 <= wishbone_data_i[3:0];
					wishbone_ack_o <= digseg_ack;
				end
			end
			`WB_SELECT_PS2: begin
				wishbone_data_o <= 0;
			end
			default: begin
			end
		endcase
	end

	bus bus0(
		.clk_i(clk),
		.rst_i(rst),
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

	digseg_driver digseg0(
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
