`include "defines.v"
module openmips(
	input		wire					clk,
	input		wire					rst,
	input		wire					clk_4,
	input		wire[1:0]				clk_count,

	input		wire[5:0]				int_i,	

	//wishbone总线
	input wire[`RegBus]					wishbone_data_i,
	input wire							wishbone_ack_i,
	output wire[`RegBus]				wishbone_addr_o,
	output wire[`RegBus]				wishbone_data_o,
	output wire							wishbone_we_o,
	output wire[15:0]					wishbone_select_o,
	output wire							wishbone_stb_o,
	output wire							wishbone_cyc_o,

	output		wire					timer_int_o
	);

	//连接IF/ID模块与译码阶段ID模块的变�
	wire[`InstAddrBus]		pc;
	wire[`InstAddrBus]		id_pc_i;
	wire[`InstBus]			id_inst_i;

	//连接译码阶段ID模块输出与ID/EX模块的输入的变量
	wire[`AluOpBus]			id_aluop_o;
	wire[`AluSelBus]		id_alusel_o;
	wire[`RegBus]			id_reg1_o;
	wire[`RegBus]			id_reg2_o;
	wire					id_wreg_o;
	wire[`RegAddrBus]		id_wd_o;
	wire					id_is_in_delayslot_o;
	wire[`RegBus]			id_link_address_o;
	wire[`RegBus]			id_inst_o;
	wire[31:0]				id_excepttype_o;
	wire[`RegBus]			id_current_inst_address_o;

	//连接ID/EX模块输出与执行阶段EX模块的输入的变量
	wire[`AluOpBus]			ex_aluop_i;
	wire[`AluSelBus]		ex_alusel_i;
	wire[`RegBus]			ex_reg1_i;
	wire[`RegBus]			ex_reg2_i;
	wire					ex_wreg_i;
	wire[`RegAddrBus]		ex_wd_i;
	wire					ex_is_in_delayslot_i;
	wire[`RegBus]			ex_link_address_i;
	wire[`RegBus]			ex_inst_i;
	wire[31:0]				ex_excepttype_i;
	wire[`RegBus]			ex_current_inst_address_i;

	//连接执行阶段EX的模块的输出与EX/MEM模块的输入的变量
	wire					ex_wreg_o;
	wire[`RegAddrBus]		ex_wd_o;
	wire[`RegBus]			ex_wdata_o;
	wire[`RegBus]			ex_hi_o;
	wire[`RegBus]			ex_lo_o;
	wire					ex_whilo_o;
	wire[`AluOpBus]			ex_aluop_o;
	wire[`RegBus]			ex_mem_addr_o;
	wire[`RegBus]			ex_reg1_o;
	wire[`RegBus]			ex_reg2_o;
	wire					ex_cp0_reg_we_o;
	wire[4:0]				ex_cp0_reg_write_addr_o;
	wire[`RegBus]			ex_cp0_reg_data_o;
	wire[31:0]				ex_excepttype_o;
	wire[`RegBus]			ex_current_inst_address_o;
	wire					ex_is_in_delayslot_o;

	//连接EX/MEM模块的输出与访存阶段MEM模块的输入的变量
	wire					mem_wreg_i;
	wire[`RegAddrBus]		mem_wd_i;
	wire[`RegBus]			mem_wdata_i;
	wire[`RegBus]			mem_hi_i;
	wire[`RegBus]			mem_lo_i;
	wire					mem_whilo_i;

	wire[`AluOpBus]			mem_aluop_i;
	wire[`RegBus]			mem_mem_addr_i;
	wire[`RegBus]			mem_reg1_i;
	wire[`RegBus]			mem_reg2_i;	
	wire					mem_cp0_reg_we_i;
	wire[4:0]				mem_cp0_reg_write_addr_i;
	wire[`RegBus] 			mem_cp0_reg_data_i;
	wire[31:0]				mem_excepttype_i;
	wire					mem_is_in_delayslot_i;
	wire[`RegBus]			mem_current_inst_address_i;

	//连接访存阶段MEM模块的输出与MEM/WB模块的输入的变量
	wire					mem_wreg_o;
	wire[`RegAddrBus]		mem_wd_o;
	wire[`RegBus]			mem_wdata_o;
	wire[`RegBus]			mem_hi_o;
	wire[`RegBus]			mem_lo_o;
	wire					mem_whilo_o;
	wire 					mem_cp0_reg_we_o;
	wire[4:0] 				mem_cp0_reg_write_addr_o;
	wire[`RegBus] 			mem_cp0_reg_data_o;
	wire[31:0]				mem_excepttype_o;
	wire					mem_is_in_delayslot_o;
	wire[`RegBus]			mem_current_inst_address_o;
	wire[`RegBus]			bad_v_addr_o;

	//连接MEM/WB模块的输出与回写阶段的输入的变量
	wire					wb_wreg_i;
	wire[`RegAddrBus]		wb_wd_i;
	wire[`RegBus]			wb_wdata_i;
	wire[`RegBus]			wb_hi_i;
	wire[`RegBus]			wb_lo_i;
	wire					wb_whilo_i;
	wire 					wb_cp0_reg_we_i;
	wire[4:0] 				wb_cp0_reg_write_addr_i;
	wire[`RegBus] 			wb_cp0_reg_data_i;	
	wire[31:0]				wb_excepttype_i;
	wire					wb_is_in_delayslot_i;
	wire[`RegBus]			wb_current_inst_address_i;

	//连接译码阶段ID模块与通用寄存器Regfile模块的变�
	wire					reg1_read;
	wire					reg2_read;
	wire[`RegBus]			reg1_data;
	wire[`RegBus]			reg2_data;
	wire[`RegAddrBus]		reg1_addr;
	wire[`RegAddrBus]		reg2_addr;

	//连接执行阶段与hilo模块的输出，读取HI、LO寄存�
	wire[`RegBus]			hi;
	wire[`RegBus]			lo;
	
	wire[`DoubleRegBus]		hilo_temp_o;
	wire[1:0]				cnt_o;
	
	wire[`DoubleRegBus]		hilo_temp_i;
	wire[1:0]				cnt_i;
	
	wire					is_in_delayslot_i;
	wire					is_in_delayslot_o;
	wire					next_inst_in_delayslot_o;
	wire					id_branch_flag_o;
	wire[`RegBus]			branch_target_address;
	wire[5:0]				stall;
	wire					stallreq_from_if;
	wire					stallreq_from_id;
	wire					stallreq_from_ex;
	wire					stallreq_from_mem;
	wire					stallreq_from_wishbone;

	wire[`RegBus]			cp0_data_o;
	wire[4:0]				cp0_raddr_i;

	wire					flush;
	wire[`RegBus]			new_pc;

	wire[`RegBus]			cp0_index;
	wire[`RegBus]			cp0_entry_lo_0;
	wire[`RegBus]			cp0_entry_lo_1;
	wire[`RegBus]			cp0_bad_v_addr;
	wire[`RegBus]			cp0_count;
	wire[`RegBus]			cp0_entry_hi;
	wire[`RegBus]			cp0_compare;
	wire[`RegBus]			cp0_status;
	wire[`RegBus]			cp0_cause;
	wire[`RegBus]			cp0_epc;
	wire[`RegBus]			cp0_ebase;

	wire[`RegBus]			latest_epc;

	wire					rom_ce;

	wire[`RegBus]			ram_addr_o;
	wire					ram_we_o;
	wire[3:0]				ram_sel_o;
	wire[`RegBus]			ram_data_o;
	wire					ram_ce_o;
	wire[`RegBus]			ram_data_i;

	wire					mmu_ce_o;
	wire[`RegBus]			mmu_data_o;
	wire[`RegBus]			mmu_addr_o;
	wire					mmu_we_o;
	wire[15:0]				mmu_select_o;
	wire[`RegBus]			mmu_data_i;
	wire					mmu_ack_i;
	wire					mmu_excepttype_is_tlbm;
	wire					mmu_excepttype_is_tlbl;
	wire					mmu_excepttype_is_tlbs;

	wire					tlb_ce;
	wire					tlb_write;
	wire[`RegBus]			tlb_addr_o;
	wire[`RegBus]			tlb_addr_i;
	wire[15:0]				tlb_select_i;
	wire					tlb_we;
	wire[`TLBIndexBus]		tlb_index;
	wire[`TLBDataBus]		tlb_data;
	wire					tlb_excepttype_is_tlbm;
	wire					tlb_excepttype_is_tlbl;
	wire					tlb_excepttype_is_tlbs;

	//pc_reg例化
	pc_reg pc_reg0(
		.clk(clk_4),
		.rst(rst),
		.stall(stall),
		.flush(flush),
		.new_pc(new_pc),
		.branch_flag_i(id_branch_flag_o),
		.branch_target_address_i(branch_target_address),
		.pc(pc),
		.ce(rom_ce_o)
	);

	assign rom_addr_o = pc;		//指令存储器的输入地址就是pc的�

	//IF/ID模块例化
	if_id if_id0(
		.clk(clk_4),
		.rst(rst),
		.stall(stall),
		.flush(flush),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i)
	);

	//译码阶段ID模块例化
	id id0(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),
		.ex_aluop_i(ex_aluop_o),
		//来自Regfile模块的输�
		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		//处于执行阶段的指令要写入的目的寄存器信息
		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),

		//处于访存阶段的指令要写入的目的寄存器信息
		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

		.is_in_delayslot_i(is_in_delayslot_i),
		//送到Regfile模块的信�
		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read),
		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr),

		//送到ID/EX模块的信�
		.aluop_o(id_aluop_o),
		.alusel_o(id_alusel_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),
		.excepttype_o(id_excepttype_o),
		.inst_o(id_inst_o),

		.next_inst_in_delayslot_o(next_inst_in_delayslot_o),
		.branch_flag_o(id_branch_flag_o),
		.branch_target_address_o(branch_target_address),
		.link_addr_o(id_link_address_o),

		.is_in_delayslot_o(id_is_in_delayslot_o),
		.current_inst_address_o(id_current_inst_address_o),
		.stallreq(stallreq_from_id)
	);

	//通用寄存器Regfile模块例化
	regfile regfile1(
		.clk(clk_4),
		.rst(rst),
		.we(wb_wreg_i),
		.waddr(wb_wd_i),
		.wdata(wb_wdata_i),
		.re1(reg1_read),
		.raddr1(reg1_addr),
		.rdata1(reg1_data),
		.re2(reg2_read),
		.raddr2(reg2_addr),
		.rdata2(reg2_data)
	);

	//ID/EX模块例化
	id_ex id_ex0(
		.clk(clk_4),
		.rst(rst),

		.stall(stall),
		.flush(flush),

		//从译码阶段ID模块传递过来的信息
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_link_address(id_link_address_o),
		.id_is_in_delayslot(id_is_in_delayslot_o),
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),
		.id_inst(id_inst_o),
		.id_excepttype(id_excepttype_o),
		.id_current_inst_address(id_current_inst_address_o),

		//传递到执行阶段EX模块的信�
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_link_address(ex_link_address_i),
		.ex_is_in_delayslot(ex_is_in_delayslot_i),
		.is_in_delayslot_o(is_in_delayslot_i),
		.ex_inst(ex_inst_i),
		.ex_excepttype(ex_excepttype_i),
		.ex_current_inst_address(ex_current_inst_address_i)
	);

	//EX模块例化
	ex ex0(
		.rst(rst),

		//从ID/EX模块传递过来的信息
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.hi_i(hi),
		.lo_i(lo),
		.inst_i(ex_inst_i),

		//输出到EX/MEM模块的信�
		.wb_hi_i(wb_hi_i),
		.wb_lo_i(wb_lo_i),
		.wb_whilo_i(wb_whilo_i),
		.mem_hi_i(mem_hi_o),
		.mem_lo_i(mem_lo_o),
		.mem_whilo_i(mem_whilo_o),

		.hilo_temp_i(hilo_temp_i),
		.cnt_i(cnt_i),
		
		.link_address_i(ex_link_address_i),
		.is_in_delayslot_i(ex_is_in_delayslot_i),

		.excepttype_i(ex_excepttype_i),
		.current_inst_address_i(ex_current_inst_address_i),

		//访存阶段的指令是否要写CP0，用来检测数据相�
		.mem_cp0_reg_we(mem_cp0_reg_we_o),
		.mem_cp0_reg_write_addr(mem_cp0_reg_write_addr_o),
		.mem_cp0_reg_data(mem_cp0_reg_data_o),

		//回写阶段的指令是否要写CP0，用来检测数据相�
	  	.wb_cp0_reg_we(wb_cp0_reg_we_i),
		.wb_cp0_reg_write_addr(wb_cp0_reg_write_addr_i),
		.wb_cp0_reg_data(wb_cp0_reg_data_i),

		.cp0_reg_data_i(cp0_data_o),
		.cp0_reg_read_addr_o(cp0_raddr_i),
		
		//向下一流水级传递，用于写CP0中的寄存�
		.cp0_reg_we_o(ex_cp0_reg_we_o),
		.cp0_reg_write_addr_o(ex_cp0_reg_write_addr_o),
		.cp0_reg_data_o(ex_cp0_reg_data_o),	  
			  
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),
		.hi_o(ex_hi_o),
		.lo_o(ex_lo_o),
		.whilo_o(ex_whilo_o),

		.hilo_temp_o(hilo_temp_o),
		.cnt_o(cnt_o),

		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o),
		
		.excepttype_o(ex_excepttype_o),
		.is_in_delayslot_o(ex_is_in_delayslot_o),
		.current_inst_address_o(ex_current_inst_address_o),
		.stallreq(stallreq_from_ex)
	);

	//EX/MEM模块例化
	ex_mem ex_mem0(
		.clk(clk_4),
		.rst(rst),
		.stall(stall),
		.flush(flush),

		//来自执行阶段EX模块的信�
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_hi(ex_hi_o),
		.ex_lo(ex_lo_o),
		.ex_whilo(ex_whilo_o),

		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),

		.ex_cp0_reg_we(ex_cp0_reg_we_o),
		.ex_cp0_reg_write_addr(ex_cp0_reg_write_addr_o),
		.ex_cp0_reg_data(ex_cp0_reg_data_o),

		.ex_excepttype(ex_excepttype_o),
		.ex_is_in_delayslot(ex_is_in_delayslot_o),
		.ex_current_inst_address(ex_current_inst_address_o),
		.hilo_i(hilo_temp_o),
		.cnt_i(cnt_o),

		//送到访存阶段MEM模块的信�
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_hi(mem_hi_i),
		.mem_lo(mem_lo_i),
		.mem_whilo(mem_whilo_i),

		.mem_cp0_reg_we(mem_cp0_reg_we_i),
		.mem_cp0_reg_write_addr(mem_cp0_reg_write_addr_i),
		.mem_cp0_reg_data(mem_cp0_reg_data_i),

		.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i),

		.mem_excepttype(mem_excepttype_i),
		.mem_is_in_delayslot(mem_is_in_delayslot_i),
		.mem_current_inst_address(mem_current_inst_address_i),

		.hilo_o(hilo_temp_i),
		.cnt_o(cnt_i)
	);

	//MEM模块例化
	mem mem0(
		.rst(rst),

		//来自EX/MEM模块的信�
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
		.hi_i(mem_hi_i),
		.lo_i(mem_lo_i),
		.whilo_i(mem_whilo_i),

		.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
		//来自memory的信�
		.mem_data_i(ram_data_i),

		.cp0_reg_we_i(mem_cp0_reg_we_i),
		.cp0_reg_write_addr_i(mem_cp0_reg_write_addr_i),
		.cp0_reg_data_i(mem_cp0_reg_data_i),

		.excepttype_i(mem_excepttype_i),
		.is_in_delayslot_i(mem_is_in_delayslot_i),
		.current_inst_address_i(mem_current_inst_address_i),

		.cp0_bad_v_addr_i(cp0_bad_v_addr),
		.cp0_status_i(cp0_status),
		.cp0_cause_i(cp0_cause),
		.cp0_epc_i(cp0_epc),
		.cp0_index_i(cp0_index),
		.cp0_entry_lo0_i(cp0_entry_lo0),
		.cp0_entry_lo1_i(cp0_entry_lo1),
		.cp0_entry_hi_i(cp0_entry_hi),

		//回写阶段的指令是否要写CP0，用来检测数据相�
		.wb_cp0_reg_we(wb_cp0_reg_we_i),
		.wb_cp0_reg_write_addr(wb_cp0_reg_write_addr_i),
		.wb_cp0_reg_data(wb_cp0_reg_data_i),

		.excepttype_is_tlbm_i(mmu_excepttype_is_tlbm),
		.excepttype_is_tlbl_i(mmu_excepttype_is_tlbl),
		.excepttype_is_tlbs_i(mmu_excepttype_is_tlbs),

		.cp0_reg_we_o(mem_cp0_reg_we_o),
		.cp0_reg_write_addr_o(mem_cp0_reg_write_addr_o),
		.cp0_reg_data_o(mem_cp0_reg_data_o),

		//送到MEM/WB模块的信�
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.hi_o(mem_hi_o),
		.lo_o(mem_lo_o),
		.whilo_o(mem_whilo_o),
		.mem_addr_o(ram_addr_o),
		.mem_we_o(ram_we_o),
		.mem_sel_o(ram_sel_o),
		.mem_data_o(ram_data_o),
		.mem_ce_o(ram_ce_o),

		.excepttype_o(mem_excepttype_o),
		.cp0_epc_o(latest_epc),
		.is_in_delayslot_o(mem_is_in_delayslot_o),
		.current_inst_address_o(mem_current_inst_address_o),
		.bad_v_addr_o(bad_v_addr_o),

		//送到TLB模块的信�
		.tlb_we_o(tlb_we),
		.tlb_index_o(tlb_index),
		.tlb_data_o(tlb_data)
	);

	//MEM/WB模块例化
	mem_wb mem_wb0(
		.clk(clk_4),
		.rst(rst),
		.stall(stall),
		.flush(flush),
		
		//来自访存阶段MEM模块的信�
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
		.mem_hi(mem_hi_o),
		.mem_lo(mem_lo_o),
		.mem_whilo(mem_whilo_o),

		.mem_cp0_reg_we(mem_cp0_reg_we_o),
		.mem_cp0_reg_write_addr(mem_cp0_reg_write_addr_o),
		.mem_cp0_reg_data(mem_cp0_reg_data_o),

		//送到回写阶段的信�
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),
		.wb_hi(wb_hi_i),
		.wb_lo(wb_lo_i),
		.wb_whilo(wb_whilo_i),
		
		.wb_cp0_reg_we(wb_cp0_reg_we_i),
		.wb_cp0_reg_write_addr(wb_cp0_reg_write_addr_i),
		.wb_cp0_reg_data(wb_cp0_reg_data_i)
	);

	hilo_reg hilo_reg0(
		.clk(clk_4),
		.rst(rst),

		//写端�
		.we(wb_whilo_i),
		.hi_i(wb_hi_i),
		.lo_i(wb_lo_i),

		//读端�
		.hi_o(hi),
		.lo_o(lo)
	);

	ctrl ctrl0(
		.rst(rst),

		.excepttype_i(mem_excepttype_o),
		.cp0_epc_i(latest_epc),
	
		.stallreq_from_id(stallreq_from_id),

	 	//来自执行阶段的暂停请�
		.stallreq_from_ex(stallreq_from_ex),

		.new_pc(new_pc),
		.flush(flush),
		.stall(stall)
	);

	cp0_reg cp0_reg0(
		.clk(clk_4),
		.rst(rst),

		.we_i(wb_cp0_reg_we_i),
		.waddr_i(wb_cp0_reg_write_addr_i),
		.raddr_i(cp0_raddr_i),
		.data_i(wb_cp0_reg_data_i),

		.excepttype_i(mem_excepttype_o),
		.int_i(int_i),
		.current_inst_addr_i(mem_current_inst_address_o),
		.bad_v_addr_i(bad_v_addr_o),
		.is_in_delayslot_i(mem_is_in_delayslot_o),

		.data_o(cp0_data_o),
		.index_o(cp0_index),
		.entry_lo_0_o(cp0_entry_lo_0),
		.entry_lo_1_o(cp0_entry_lo_1),
		.bad_v_addr_o(cp0_bad_v_addr),
		.count_o(cp0_count),
		.entry_hi_o(cp0_entry_hi),
		.compare_o(cp0_compare),
		.status_o(cp0_status),
		.cause_o(cp0_cause),
		.epc_o(cp0_epc),
		.ebase_o(cp0_ebase),
		
		.timer_int_o(timer_int_o)
	);

	mmu mmu0(
		.clk(clk),
		.rst(rst),
		.clk_count(clk_count),

		//IF模块的接�
		.if_ce_i(rom_ce),
		.if_data_i(32'h00000000),
		.if_addr_i(pc),
		.if_we_i(1'b0),
		.if_sel_i(4'b1111),
		.if_data_o(inst_i),

		.stall_req_if(stallreq_from_if),

		//MEM模块的接�
		.mem_ce_i(ram_ce_o),
		.mem_data_i(ram_data_o),
		.mem_addr_i(ram_addr_o),
		.mem_we_i(ram_we_o),
		.mem_sel_i(ram_sel_o),
		.mem_data_o(ram_data_i),

		.stall_req_mem(stallreq_from_mem),

		.mmu_excepttype_is_tlbm_o(mmu_excepttype_is_tlbm),
		.mmu_excepttype_is_tlbl_o(mmu_excepttype_is_tlbl),
		.mmu_excepttype_is_tlbs_o(mmu_excepttype_is_tlbs),

		//TLB模块的接�
		.tlb_ce(tlb_ce),
		.tlb_write_o(tlb_write),
		.tlb_addr_o(tlb_addr_o),
		.tlb_addr_i(tlb_addr_i),
		.tlb_select_i(tlb_select_i),
		.tlb_excepttype_is_tlbm_i(tlb_excepttype_is_tlbm),
		.tlb_excepttype_is_tlbl_i(tlb_excepttype_is_tlbl),
		.tlb_excepttype_is_tlbs_i(tlb_excepttype_is_tlbs),

		//总线侧的接口
		.mmu_ce_o(mmu_ce_o),
		.mmu_data_o(mmu_data_o),
		.mmu_addr_o(mmu_addr_o),
		.mmu_we_o(mmu_we_o),
		.mmu_select_o(mmu_select_o),
		.mmu_data_i(mmu_data_i),
		.mmu_ack_i(mmu_ack_i),

		.stall_req(stallreq_from_wishbone)
	);

	tlb tlb0(
		.rst(rst),

		.mmu_addr(tlb_addr_o),
		.tlb_ce(tlb_ce),
		.mmu_write(tlb_write),
		.tlb_addr(tlb_addr_i),
		.tlb_select(tlb_select_i),

		.tlb_we(tlb_we),
		.tlb_index(tlb_index),
		.tlb_data(tlb_data),

		.excepttype_is_tlbm(tlb_excepttype_is_tlbm),
		.excepttype_is_tlbl(tlb_excepttype_is_tlbl),
		.excepttype_is_tlbs(tlb_excepttype_is_tlbs)
	);

	wishbone_bus wishbone_bus0(
		.clk(clk),
		.rst(rst),

		//来自控制模块ctrl
		.stall_i(stall),
		.flush_i(flush),

		//CPU侧读写操作信�
		.mmu_ce_i(mmu_ce_o),
		.mmu_data_i(mmu_data_o),
		.mmu_addr_i(mmu_addr_o),
		.mmu_we_i(mmu_we_o),
		.mmu_select_i(mmu_select_o),
		.mmu_data_o(mmu_data_i),
		.mmu_ack_o(mmu_ack_i),

		//Wishbone总线侧接�
		.wishbone_data_i(wishbone_data_i),
		.wishbone_ack_i(wishbone_ack_i),
		.wishbone_addr_o(wishbone_addr_o),
		.wishbone_data_o(wishbone_data_o),
		.wishbone_we_o(wishbone_we_o),
		.wishbone_select_o(wishbone_select_o),
		.wishbone_stb_o(wishbone_stb_o),
		.wishbone_cyc_o(wishbone_cyc_o),

		.stallreq(stallreq_from_wishbone)
	);

endmodule
