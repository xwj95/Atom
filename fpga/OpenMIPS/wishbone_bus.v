`include "defines.v"

module wishbone_bus(
	input		wire					clk,
	input		wire					rst,

	//����ctrlģ��
	input		wire[5:0]				stall_i,
	input		wire					flush_i,

	//MMU��Ľӿ�
	input		wire					mmu_ce_i,
	input		wire[`RegBus]			mmu_data_i,
	input		wire[`RegBus]			mmu_addr_i,
	input		wire					mmu_we_i,
	input		wire[15:0]				mmu_select_i,
	output		reg[`RegBus]			mmu_data_o,
	output		reg						mmu_ack_o,

	//Wishbone��Ľӿ�
	input		wire[`RegBus]			wishbone_data_i,
	input		wire					wishbone_ack_i,
	output		reg[`RegBus]			wishbone_addr_o,
	output		reg[`RegBus]			wishbone_data_o,
	output		reg						wishbone_we_o,
	output		reg[15:0]				wishbone_select_o,

	output		reg						stallreq
	);

	reg[1:0] wishbone_state;								//����Wishbone���߽ӿ�ģ���״̬
	reg[`RegBus] rd_buf;									//�Ĵ�ͨ��Wishbone���߷��ʵ�������

	/*********************		��һ�Σ�����״̬ת����ʱ���·		*********************/
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			wishbone_state <= `WB_IDLE;
			wishbone_addr_o <= `ZeroWord;
			wishbone_data_o <= `ZeroWord;
			wishbone_we_o <= `WriteDisable;
			wishbone_select_o <= 4'b0000;
			rd_buf <= `ZeroWord;
		end else begin
			case (wishbone_state)
				`WB_IDLE: begin								//WB_IDLE״̬
					if ((mmu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						wishbone_addr_o <= mmu_addr_i;
						wishbone_data_o <= mmu_data_i;
						wishbone_we_o <= mmu_we_i;
						wishbone_select_o <= mmu_select_i;
						wishbone_state <= `WB_BUSY;			//����WB_BUSY״̬
					end
				end
				`WB_BUSY: begin								//WB_BUSY״̬
					if (wishbone_ack_i == 1'b1) begin
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_select_o <= 4'b0000;
						wishbone_state <= `WB_IDLE;
						if (mmu_we_i == `WriteDisable) begin
							rd_buf <= wishbone_data_i;
						end
						if (stall_i != 6'b000000) begin		//����WB_WAIT_FOR_STALL״̬
							wishbone_state <= `WB_WAIT_FOR_STALL;
						end
					end else if (flush_i == `True_v) begin
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_select_o <= 4'b0000;
						wishbone_state <= `WB_IDLE;			//����WB_IDLE״̬
						rd_buf <= `ZeroWord;
					end
				end
				`WB_WAIT_FOR_STALL: begin					//WB_WAIT_FOR_STALL״̬
					if (stall_i == 6'b000000) begin
						wishbone_state <= `WB_IDLE;			//����WB_IDLE״̬
					end
				end
				default: begin
				end
			endcase
		end
	end

	/*********************		�ڶ��Σ����������ӿ��źŸ�ֵ����ϵ�·		*********************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			stallreq <= `NoStop;
			mmu_data_o <= `ZeroWord;
			mmu_ack_o <= 1'b1;
		end else begin
			stallreq <= `NoStop;
			mmu_data_o <= `ZeroWord;
			mmu_ack_o <= wishbone_ack_i;
			case (wishbone_state)
				`WB_IDLE: begin								//WB_IDLE״̬
					if ((mmu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						stallreq <= `Stop;
						mmu_data_o <= `ZeroWord;
					end
				end
				`WB_BUSY: begin								//WB_BUSY״̬
					if (wishbone_ack_i == 1'b1) begin
						stallreq <= `NoStop;
						if (wishbone_we_o == `WriteDisable) begin
							mmu_data_o <= wishbone_data_i;
						end else begin
							mmu_data_o <= `ZeroWord;
						end
					end else begin
						stallreq <= `Stop;
						mmu_data_o <= `ZeroWord;
					end
				end
				`WB_WAIT_FOR_STALL: begin					//WB_WAIT_FOR_STALL״̬
					stallreq <= `NoStop;
					mmu_data_o <= rd_buf;
				end
				default: begin
				end
			endcase
		end
	end

endmodule
