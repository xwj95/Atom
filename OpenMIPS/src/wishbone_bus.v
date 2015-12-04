`include "defines.v"

module wishbone_bus(
	input		wire					clk,
	input		wire					rst,

	//来自ctrl模块
	input		wire[5:0]				stall_i,
	input		wire					flush_i,

	//MMU侧的接口
	input		wire					mmu_ce_i,
	input		wire[`RegBus]			mmu_data_i,
	input		wire[`RegBus]			mmu_addr_i,
	input		wire					mmu_we_i,
	input		wire[15:0]				mmu_select_i,
	output		reg[`RegBus]			mmu_data_o,
	output		reg						mmu_ack_o,

	//Wishbone侧的接口
	input		wire[`RegBus]			wishbone_data_i,
	input		wire					wishbone_ack_i,
	output		reg[`RegBus]			wishbone_addr_o,
	output		reg[`RegBus]			wishbone_data_o,
	output		reg						wishbone_we_o,
	output		reg[15:0]				wishbone_select_o,

	output		reg						stallreq
	);

	reg[1:0] wishbone_state;								//保存Wishbone总线接口模块的状态
	reg[`RegBus] rd_buf;									//寄存通过Wishbone总线访问到的数据

	/*********************		第一段：控制状态转化的时序电路		*********************/
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
				`WB_IDLE: begin								//WB_IDLE状态
					if ((mmu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						wishbone_addr_o <= mmu_addr_i;
						wishbone_data_o <= mmu_data_i;
						wishbone_we_o <= mmu_we_i;
						wishbone_select_o <= mmu_select_i;
						wishbone_state <= `WB_BUSY;			//进入WB_BUSY状态
					end
				end
				`WB_BUSY: begin								//WB_BUSY状态
					if (wishbone_ack_i == 1'b1) begin
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_select_o <= 4'b0000;
						wishbone_state <= `WB_IDLE;
						if (mmu_we_i == `WriteDisable) begin
							rd_buf <= wishbone_data_i;
						end
						if (stall_i != 6'b000000) begin		//进入WB_WAIT_FOR_STALL状态
							wishbone_state <= `WB_WAIT_FOR_STALL;
						end
					end else if (flush_i == `True_v) begin
						wishbone_addr_o <= `ZeroWord;
						wishbone_data_o <= `ZeroWord;
						wishbone_we_o <= `WriteDisable;
						wishbone_select_o <= 4'b0000;
						wishbone_state <= `WB_IDLE;			//进入WB_IDLE状态
						rd_buf <= `ZeroWord;
					end
				end
				`WB_WAIT_FOR_STALL: begin					//WB_WAIT_FOR_STALL状态
					if (stall_i == 6'b000000) begin
						wishbone_state <= `WB_IDLE;			//进入WB_IDLE状态
					end
				end
				default: begin
				end
			endcase
		end
	end

	/*********************		第二段：给处理器接口信号赋值的组合电路		*********************/
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
				`WB_IDLE: begin								//WB_IDLE状态
					if ((mmu_ce_i == 1'b1) && (flush_i == `False_v)) begin
						stallreq <= `Stop;
						mmu_data_o <= `ZeroWord;
					end
				end
				`WB_BUSY: begin								//WB_BUSY状态
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
				`WB_WAIT_FOR_STALL: begin					//WB_WAIT_FOR_STALL状态
					stallreq <= `NoStop;
					mmu_data_o <= rd_buf;
				end
				default: begin
				end
			endcase
		end
	end

endmodule
