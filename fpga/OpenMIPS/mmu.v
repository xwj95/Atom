`include "defines.v"

module mmu(
	input		wire					clk,
	input		wire					rst,

	//IFģ��Ľӿ�
	input		wire					if_ce_i,
	input		wire[`RegBus]			if_data_i,
	input		wire[`RegBus]			if_addr_i,
	input		wire					if_we_i,
	input		wire[3:0]				if_sel_i,
	output		reg[`RegBus]			if_data_o,

	output		reg						stall_req_if,

	//MEMģ��Ľӿ�
	input		wire					mem_ce_i,
	input		wire[`RegBus]			mem_data_i,
	input		wire[`RegBus]			mem_addr_i,
	input		wire					mem_we_i,
	input		wire[3:0]				mem_sel_i,
	output		reg[`RegBus]			mem_data_o,

	output		reg						stall_req_mem,

	//TLBģ��Ľӿ�
	output		reg						tlb_ce,
	output		reg						tlb_write_o,
	output		reg[`RegBus]			tlb_addr_o,
	input		wire[`RegBus]			tlb_addr_i,
	input		wire[15:0]				tlb_select_i,

	//MMU��Ľӿ�
	output		reg						mmu_ce_o,
	output		reg[`RegBus]			mmu_data_o,
	output		reg[`RegBus]			mmu_addr_o,
	output		reg						mmu_we_o,
	output		reg[15:0]				mmu_select_o,
	input		wire[`RegBus]			mmu_data_i,
	input		wire					mmu_ack_i,

	input		wire					stall_req,
	output		wire[12:0]				state
	);

	reg[2:0] mmu_state;											//����MMUģ���״̬
	reg[2:0] mmu_state_next;
	reg[`RegBus] mem_wdata;

	reg	if_ack;
	reg	memw_ack;
	reg memr_ack;

	assign state = {if_ce_i, mem_ce_i, stall_req_mem, stall_req_if, mmu_state_next, mmu_state, memr_ack, memw_ack, if_ack};

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			mmu_ce_o <= `ChipEnable;
			mmu_data_o <= `ZeroWord;
			mmu_addr_o <= `ZeroWord;
			mmu_we_o <= `WriteDisable;
			mmu_select_o <= `WB_SELECT_ZERO;
			stall_req_if <= `NoStop;
			stall_req_mem <= `NoStop;
			tlb_ce <= `ChipDisable;
			tlb_write_o <= `False_v;
			tlb_addr_o <= `ZeroWord;
			mmu_state <= `MMU_IF1_MEMW1_MEMR1;
		end else begin
			mmu_state <= mmu_state_next;
			case (mmu_state)
				`MMU_IF0_MEMW0_MEMR0: begin						//ȡָδ��ɣ�д�ô�δ��ɣ����ô�δ���
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= mem_addr_i;
				end
				`MMU_IF0_MEMW0_MEMR1: begin						//ȡָδ��ɣ�д�ô�δ��ɣ����ô������
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= mem_wdata;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteEnable;
					mmu_select_o <= tlb_select_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `True_v;
					tlb_addr_o <= mem_addr_i;
				end
				`MMU_IF0_MEMW1_MEMR0: begin						//ȡָδ��ɣ�д�ô�����ɣ����ô�δ���
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					stall_req_if <= `Stop;
					stall_req_mem <= stall_req;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= mem_addr_i;
				end
				`MMU_IF0_MEMW1_MEMR1: begin						//ȡָδ��ɣ�д�ô�����ɣ����ô������
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= tlb_addr_i;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= tlb_select_i;
					stall_req_if <= stall_req;
					stall_req_mem <= `NoStop;
					tlb_ce <= `ChipEnable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= if_addr_i;
				end
				`MMU_IF1_MEMW1_MEMR1: begin						//ȡָ����ɣ�д�ô�����ɣ����ô������
					mmu_ce_o <= `ChipEnable;
					mmu_data_o <= `ZeroWord;
					mmu_addr_o <= `ZeroWord;
					mmu_we_o <= `WriteDisable;
					mmu_select_o <= `WB_SELECT_ZERO;
					stall_req_if <= `NoStop;
					stall_req_mem <= `NoStop;
					tlb_ce <= `ChipDisable;
					tlb_write_o <= `False_v;
					tlb_addr_o <= `ZeroWord;
				end
				default: begin
				end
			endcase
		end
	end

	always @ (*) begin
		if (rst == `RstEnable) begin
			if_ack <= `True_v;
			memw_ack <= `True_v;
			memr_ack <= `True_v;
			mmu_state_next <= `MMU_IF1_MEMW1_MEMR1;
			mem_wdata <= `ZeroWord;
			if_data_o <= `ZeroWord;
			mem_data_o <= `ZeroWord;
		end else begin
			if_ack <= `True_v;
			memw_ack <= `True_v;
			memr_ack <= `True_v;
			mmu_state_next <= `MMU_IF1_MEMW1_MEMR1;
			mem_wdata <= `ZeroWord;
			if_data_o <= `ZeroWord;
			mem_data_o <= `ZeroWord;
			case (mmu_state)
				`MMU_IF0_MEMW0_MEMR0: begin						//ȡָδ��ɣ�д�ô�δ��ɣ����ô�δ���
					memr_ack <= mmu_ack_i;
					if (mmu_ack_i == `True_v) begin
						mem_data_o <= mmu_data_i;
						mem_wdata <= mem_data_i; 
						if (mem_sel_i != 4'b1111) begin			//��Ҫ�ȶ���д��ָ����ô���ɺ��޸Ķ�Ӧ�ֽ�
							if (mem_sel_i[3] == 1'b0) begin
								mem_wdata[31:24] <= mmu_data_o[31:24];
							end
							if (mem_sel_i[2] == 1'b0) begin
								mem_wdata[23:16] <= mmu_data_o[23:16];
							end
							if (mem_sel_i[1] == 1'b0) begin
								mem_wdata[15:8] <= mmu_data_o[15:8];
							end
							if (mem_sel_i[0] == 1'b0) begin
								mem_wdata[7:0] <= mmu_data_o[7:0];
							end
						end
						mmu_state_next <= `MMU_IF0_MEMW0_MEMR1;
					end
				end
				`MMU_IF0_MEMW0_MEMR1: begin						//ȡָδ��ɣ�д�ô�δ��ɣ����ô������
					memw_ack <= mmu_ack_i;
					if (mmu_ack_i == `True_v) begin
						mmu_state_next <= `MMU_IF0_MEMW1_MEMR1;
					end
				end
				`MMU_IF0_MEMW1_MEMR0: begin						//ȡָδ��ɣ�д�ô�����ɣ����ô�δ���
					memr_ack <= mmu_ack_i;
					if (mmu_ack_i == `True_v) begin
						mem_data_o <= mmu_data_i;
						mmu_state_next <= `MMU_IF0_MEMW1_MEMR1;
					end
				end
				`MMU_IF0_MEMW1_MEMR1: begin						//ȡָδ��ɣ�д�ô�����ɣ����ô������
					if_ack <= mmu_ack_i;
					if (mmu_ack_i == `True_v) begin
						if_data_o <= mmu_data_i;
						mmu_state_next <= `MMU_IF1_MEMW1_MEMR1;
					end
				end
				`MMU_IF1_MEMW1_MEMR1: begin						//ȡָ����ɣ�д�ô�����ɣ����ô������
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
							end else begin						//���ֻд�����ֽڣ���Ҫ�ȶ���д
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
					mmu_state_next <= {if_ack, memw_ack, memr_ack};
				end
				default: begin
					mmu_state_next <= `MMU_IF1_MEMW1_MEMR1;
				end
			endcase
		end
	end

endmodule
