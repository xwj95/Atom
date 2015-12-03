`include "defines.v"
module openmips_min_sopc(
	input							clk,
	input							rst,

	//RAM
	output		[19:0]				baseram_addr,
	inout		[31:0]				baseram_data,
	output							baseram_ce,
	output							baseram_oe,
	output							baseram_we,
	output		[19:0]				extram_addr,
	inout		[31:0]				extram_data,
	output							extram_ce,
	output							extram_oe,
	output							extram_we,

	//FLASH
	output		[22:0]				flash_addr,
	inout		[15:0]				flash_data,
	output		[7:0]				flash_ctl,

	//VGA

	//UART
	output							com_TxD,
	input							com_RxD,

	//segdisp
	output		[0:6]				segdisp0,
	output		[0:6]				segdisp1
	);

	//连接指令存储�
	wire[`InstAddrBus]		inst_addr;
	wire[`InstBus]			inst;
	wire					rom_ce;
	wire					mem_we_i;
	wire[`RegBus]			mem_addr_i;
	wire[`RegBus]			mem_data_i;
	wire[`RegBus]			mem_data_o;
	wire[3:0]				mem_sel_i;
	wire					mem_ce_i;
	wire[5:0]				int;
	wire					timer_int;

	reg						clk_4;
	reg[2:0]				clk_count;

	wire[`RegBus]			wishbone_data_o;
	wire					wishbone_ack_i;
	wire[`RegBus]			wishbone_addr_o;
	wire[`RegBus]			wishbone_data_i;
	wire					wishbone_we_o;
	wire[15:0]				wishbone_select_o;
	wire					wishbone_stb_o;
	wire					wishbone_cyc_o;

	initial begin
		clk_4 = 1'b0;
		clk_count <= 3'b000;
	end

	always @ (posedge clk or negedge clk) begin
		if (clk_count[2] == 1'b1) begin
			clk_4 <= ~clk_4;
			clk_count <= 0;
		end else begin
			clk_count <= clk_count + 1'b1;
		end
	end

	assign int = {5'b00000, timer_int};		//时钟中断作为一个中断输�

	//例化处理器OpenMIPS
	openmips openmips0(
		.clk(clk),
		.rst(rst),
		.clk_4(clk_4),
		.clk_count(clk_count[1:0]),
		.int_i(int),						//中断输入

		.wishbone_data_i(wishbone_data_i),
		.wishbone_ack_i(wishbone_ack_i),
		.wishbone_addr_o(wishbone_addr_o),
		.wishbone_data_o(wishbone_data_o),
		.wishbone_we_o(wishbone_we_o),
		.wishbone_select_o(wishbone_select_o),
		.wishbone_stb_o(wishbone_stb_o),
		.wishbone_cyc_o(wishbone_cyc_o),

		.timer_int_o(timer_int)				//时钟中断输出
	);

	//例化Wishbone总线
	bus bus0 (
		.clk(clk),
		.rst(rst),
		.wishbone_addr_i(wishbone_addr_o),
		.wishbone_data_i(wishbone_data_o),
		.wishbone_we_i(wishbone_we_o),
		.wishbone_stb_i(wishbone_stb_o),
		.wishbone_cyc_i(wishbone_cyc_o),
		.wishbone_select_i(wishbone_select_o),
		.wishbone_data_o(wishbone_data_i),
		.wishbone_ack_o(wishbone_ack_i),
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
