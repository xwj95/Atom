`include "defines.v"

module mmu(
	input		wire					clk,
	input		wire					rst,
	input		wire[1:0]				clk_count,

	//IF模块的接口
	input		wire					if_ce_i,
	input		wire[`RegBus]			if_data_i,
	input		wire[`RegBus]			if_addr_i,
	input		wire					if_we_i,
	input		wire[3:0]				if_sel_i,
	output		reg[`RegBus]			if_data_o,

	output		reg						stall_req_if,

	//MEM模块的接口
	input		wire					mem_ce_i,
	input		wire[`RegBus]			mem_data_i,
	input		wire[`RegBus]			mem_addr_i,
	input		wire					mem_we_i,
	input		wire[3:0]				mem_sel_i,
	output		reg[`RegBus]			mem_data_o,

	output		reg						stall_req_mem,

	output		reg						mmu_excepttype_is_tlbm_o,
	output		reg						mmu_excepttype_is_tlbl_o,
	output		reg						mmu_excepttype_is_tlbs_o,

	//TLB模块的接口
	output		reg						tlb_ce,
	output		reg						tlb_write_o,
	output		reg[`RegBus]			tlb_addr_o,
	input		wire[`RegBus]			tlb_addr_i,
	input		wire[15:0]				tlb_select_i,
	input		wire					tlb_excepttype_is_tlbm_i,
	input		wire					tlb_excepttype_is_tlbl_i,
	input		wire					tlb_excepttype_is_tlbs_i,

	//MMU侧的接口
	output		reg						mmu_ce_o,
	output		reg[`RegBus]			mmu_data_o,
	output		reg[`RegBus]			mmu_addr_o,
	output		reg						mmu_we_o,
	output		reg[15:0]				mmu_select_o,
	input		wire[`RegBus]			mmu_data_i,
	input		wire					mmu_ack_i,

	input		wire					stall_req
	);

	wire[2:0] mmu_state;									//保存MMU模块的状态
	reg	if_ack;
	reg	memw_ack;
	reg memr_ack;

	reg[`RegBus] mem_wdata;

	assign mmu_state = {if_ack, memw_ack, memr_ack};


	/*********************		第一段：控制状态转化的时序电路		*********************/
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			mmu_ce_o <= `ChipEnable;
			mmu_data_o <= `ZeroWord;
			mmu_addr_o <= `ZeroWord;
			mmu_we_o <= `WriteDisable;
			mmu_select_o <= `WB_SELECT_ZERO;
			stall_req_if <= `NoStop;
			stall_req_mem <= `NoStop;
			if_ack <= `True_v;
			memw_ack <= `True_v;
			memr_ack <= `True_v;
			tlb_ce <= `ChipDisable;
			tlb_write_o <= `False_v;
			tlb_addr_o <= `ZeroWord;
			mmu_excepttype_is_tlbm_o <= `False_v;
			mmu_excepttype_is_tlbl_o <= `False_v;
			mmu_excepttype_is_tlbs_o <= `False_v;
		end else begin
			if ((clk_count == 2'b00) && (mmu_state == `MMU_IF1_MEMW1_MEMR1)) begin
				tlb_ce <= `ChipDisable;
				tlb_write_o <= `False_v;
				tlb_addr_o <= `ZeroWord;
				if (if_ce_i == `ChipEnable) begin
					if_ack <= `False_v;
				end else begin
					if_ack <= `True_v;
				end
				if (mem_ce_i == `ChipEnable) begin
					if (mem_we_i == `WriteEnable) begin
						mem_wdata <= mem_data_o;
						if (mem_sel_i == 4'b1111) begin
							memw_ack <= `False_v;
							memr_ack <= `True_v;
						end else begin						//如果只写部分字节，需要先读后写
							memw_ack <= `False_v;
							memr_ack <= `False_v;
						end
					end else begin
						memw_ack <= `True_v;
						memr_ack <= `False_v;
					end
				end else begin
					memw_ack <= `True_v;
					memr_ack <= `True_v;
				end
				mmu_excepttype_is_tlbm_o <= `False_v;
				mmu_excepttype_is_tlbl_o <= `False_v;
				mmu_excepttype_is_tlbs_o <= `False_v;
			end
			case (mmu_state)
				`MMU_IF0_MEMW0_MEMR0: begin					//取指未完成，写访存未完成，读访存未完成
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= mem_addr_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					mmu_excepttype_is_tlbm_o <= mmu_excepttype_is_tlbm_o || tlb_excepttype_is_tlbm_i;
					mmu_excepttype_is_tlbl_o <= mmu_excepttype_is_tlbl_o || tlb_excepttype_is_tlbl_i;
					mmu_excepttype_is_tlbs_o <= mmu_excepttype_is_tlbs_o || tlb_excepttype_is_tlbs_i;
				end
				`MMU_IF0_MEMW0_MEMR1: begin					//取指未完成，写访存未完成，读访存已完成
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= mem_wdata;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteEnable;
					mmu_select_o <= tlb_select_i;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `True_v;
					tlb_addr_o <= mem_addr_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					mmu_excepttype_is_tlbm_o <= mmu_excepttype_is_tlbm_o || tlb_excepttype_is_tlbm_i;
					mmu_excepttype_is_tlbl_o <= mmu_excepttype_is_tlbl_o || tlb_excepttype_is_tlbl_i;
					mmu_excepttype_is_tlbs_o <= mmu_excepttype_is_tlbs_o || tlb_excepttype_is_tlbs_i;
				end
				`MMU_IF0_MEMW1_MEMR0: begin					//取指未完成，写访存已完成，读访存未完成
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= mem_addr_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					mmu_excepttype_is_tlbm_o <= mmu_excepttype_is_tlbm_o || tlb_excepttype_is_tlbm_i;
					mmu_excepttype_is_tlbl_o <= mmu_excepttype_is_tlbl_o || tlb_excepttype_is_tlbl_i;
					mmu_excepttype_is_tlbs_o <= mmu_excepttype_is_tlbs_o || tlb_excepttype_is_tlbs_i;
				end
				`MMU_IF0_MEMW1_MEMR1: begin					//取指未完成，写访存已完成，读访存已完成
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= if_addr_i;
					stall_req_if <= stall_req;
					stall_req_mem <= `NoStop;
					mmu_excepttype_is_tlbm_o <= mmu_excepttype_is_tlbm_o || tlb_excepttype_is_tlbm_i;
					mmu_excepttype_is_tlbl_o <= mmu_excepttype_is_tlbl_o || tlb_excepttype_is_tlbl_i;
					mmu_excepttype_is_tlbs_o <= mmu_excepttype_is_tlbs_o || tlb_excepttype_is_tlbs_i;
				end
				`MMU_IF1_MEMW1_MEMR1: begin					//取指已完成，写访存已完成，读访存已完成
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= `ZeroWord;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= `WB_SELECT_ZERO;
					tlb_ce <= `ChipDisable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= `ZeroWord;
					stall_req_if <= `NoStop;
					stall_req_mem <= `NoStop;
				end
				default: begin
				end
			endcase
		end
	end

	/*********************		第二段：给处理器接口信号赋值的组合电路		*********************/
	always @ (rst, mmu_ack_i) begin
		if (rst == `RstEnable) begin
			stall_req_if <= `NoStop;
			if_data_o <= `ZeroWord;
			stall_req_mem <= `NoStop;
			mem_data_o <= `ZeroWord;
		end else begin
			case (mmu_state)
				`MMU_IF0_MEMW0_MEMR0: begin					//取指未完成，写访存未完成，读访存未完成
					if (mmu_ack_i == `True_v) begin
						mem_data_o <= mmu_data_o;
						if (mem_sel_i != 4'b1111) begin		//需要先读后写的指令，读访存完成后修改对应字节
							if (mem_sel_i[3] == 1'b0) begin
								mem_wdata[31:24] <= mem_data_o[31:24];
							end
							if (mem_sel_i[2] == 1'b0) begin
								mem_wdata[23:16] <= mem_data_o[23:16];
							end
							if (mem_sel_i[1] == 1'b0) begin
								mem_wdata[15:8] <= mem_data_o[15:8];
							end
							if (mem_sel_i[0] == 1'b0) begin
								mem_wdata[7:0] <= mem_data_o[7:0];
							end
						end
						memr_ack <= `True_v;
					end
				end
				`MMU_IF0_MEMW0_MEMR1: begin					//取指未完成，写访存未完成，读访存已完成
					if (mmu_ack_i == `True_v) begin
						memw_ack <= `True_v;
					end
				end
				`MMU_IF0_MEMW1_MEMR0: begin					//取指未完成，写访存已完成，读访存未完成
					if (mmu_ack_i == `True_v) begin
						mem_data_o <= mmu_data_o;
						memr_ack <= `True_v;
					end
				end
				`MMU_IF0_MEMW1_MEMR1: begin					//取指未完成，写访存已完成，读访存已完成
					if (mmu_ack_i == `True_v) begin
						if_data_o <= mmu_data_o;
						if_ack <= `True_v;
					end
				end
				`MMU_IF1_MEMW1_MEMR1: begin					//取指已完成，写访存已完成，读访存已完成
				end
				default: begin
				end
			endcase
		end
	end

endmodule
