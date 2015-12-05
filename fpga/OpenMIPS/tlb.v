`include "defines.v"

module tlb(
	input		wire					clk,
	input		wire					rst,

	input		wire[`RegBus]			mmu_addr,
	input		wire					mmu_write,
	input		wire					tlb_ce,
	output		reg[`RegBus]			tlb_addr,
	output		reg[15:0]				tlb_select,

	input		wire					tlb_we,
	input		wire[`TLBIndexBus]		tlb_index,
	input		wire[`TLBDataBus]		tlb_data,

	output		reg						excepttype_is_tlbm,
	output		reg						excepttype_is_tlbl,
	output		reg						excepttype_is_tlbs
	);

	reg[`TLBDataBus] tlb_reg[0:`TLBIndexNum-1];
	reg[`TLBIndexBus] tlb_find;

	/*********************		第一段：TLB表项写操作		*********************/
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			tlb_reg[0] <= {`TLBDataWidth{1'b0}};
			tlb_reg[1] <= {`TLBDataWidth{1'b0}};
			tlb_reg[2] <= {`TLBDataWidth{1'b0}};
			tlb_reg[3] <= {`TLBDataWidth{1'b0}};
			tlb_reg[4] <= {`TLBDataWidth{1'b0}};
			tlb_reg[5] <= {`TLBDataWidth{1'b0}};
			tlb_reg[6] <= {`TLBDataWidth{1'b0}};
			tlb_reg[7] <= {`TLBDataWidth{1'b0}};
			tlb_reg[8] <= {`TLBDataWidth{1'b0}};
			tlb_reg[9] <= {`TLBDataWidth{1'b0}};
			tlb_reg[10] <= {`TLBDataWidth{1'b0}};
			tlb_reg[11] <= {`TLBDataWidth{1'b0}};
			tlb_reg[12] <= {`TLBDataWidth{1'b0}};
			tlb_reg[13] <= {`TLBDataWidth{1'b0}};
			tlb_reg[14] <= {`TLBDataWidth{1'b0}};
			tlb_reg[15] <= {`TLBDataWidth{1'b0}};
		end else begin
			if (tlb_we == `WriteEnable) begin
				tlb_reg[tlb_index] <= tlb_data;
			end
		end
	end
	/*********************		第二段：虚拟地址映射		*********************/
	always @ (*) begin
		tlb_find <= 4'b0000;
		if (rst == `RstEnable) begin
			tlb_addr <= `ZeroWord;
			excepttype_is_tlbm <= `False_v;
			excepttype_is_tlbl <= `False_v;
			excepttype_is_tlbs <= `False_v;
		end else begin
			tlb_addr <= mmu_addr;
			excepttype_is_tlbm <= `False_v;						//默认没有发生内存修改异常
			excepttype_is_tlbl <= `False_v;						//默认没有发生读未在TLB中映射的内存地址异常
			excepttype_is_tlbs <= `False_v;						//默认没有发生写未在TLB中映射的内存地址异常
			if (tlb_ce == `ChipEnable) begin
				if (mmu_addr[31:30] == 2'b10) begin				//虚拟地址在[0x80000000, 0xbfffffff]范围内，不进行地址映射
					tlb_addr <= {2'b00, mmu_addr[29:0]};
				end else begin
					tlb_addr <= mmu_addr;

					if (tlb_reg[0][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0000;
					end
					if (tlb_reg[1][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0001;
					end
					if (tlb_reg[2][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0010;
					end
					if (tlb_reg[3][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0011;
					end
					if (tlb_reg[4][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0100;
					end
					if (tlb_reg[5][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0101;
					end
					if (tlb_reg[6][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0110;
					end
					if (tlb_reg[7][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b0111;
					end
					if (tlb_reg[8][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1000;
					end
					if (tlb_reg[9][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1001;
					end
					if (tlb_reg[10][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1010;
					end
					if (tlb_reg[11][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1011;
					end
					if (tlb_reg[12][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1100;
					end
					if (tlb_reg[13][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1101;
					end
					if (tlb_reg[14][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1110;
					end
					if (tlb_reg[15][62:44] == mmu_addr[31:13]) begin
						tlb_find <= 4'b1111;
					end

					if (tlb_reg[tlb_find][62:44] == mmu_addr[31:13]) begin
						tlb_addr[11:0] <= mmu_addr[11:0];
						if (mmu_addr[12] == 1'b1) begin
							tlb_addr[31:12] <= tlb_reg[tlb_find][43:24];
							if ((tlb_reg[tlb_find][23] == 1'b0) && (mmu_write == 1'b1)) begin
								excepttype_is_tlbm <= `True_v;
							end
						end else begin
							tlb_addr[31:12] <= tlb_reg[tlb_find][21:2];
							if ((tlb_reg[tlb_find][1] == 1'b0) && (mmu_write == 1'b1)) begin
								excepttype_is_tlbm <= `True_v;
							end
						end
					end else begin
						tlb_addr <= `ZeroWord;
						if (mmu_write == `True_v) begin
							excepttype_is_tlbs <= `True_v;
						end else begin
							excepttype_is_tlbl <= `True_v;
						end
					end
				end
			end
		end
	end

	/*********************		第三段：物理地址划分		*********************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			tlb_select <= `WB_SELECT_ZERO;
		end else begin
			if ((tlb_addr >= 32'h00000000) && (tlb_addr <= 32'h007fffff)) begin
				tlb_select <= `WB_SELECT_RAM;
			end else if ((tlb_addr >= 32'h1fc00000) && (tlb_addr <= 32'h1fc00fff)) begin
				tlb_select <= `WB_SELECT_ROM;
			end else if ((tlb_addr >= 32'h1e000000) && (tlb_addr <= 32'h1effffff)) begin
				tlb_select <= `WB_SELECT_FLASH;
			end else if ((tlb_addr >= 32'h1a000000) && (tlb_addr <= 32'h1a096000)) begin
				tlb_select <= `WB_SELECT_FLASH;
			end else if (tlb_addr == 32'h1fd003f8) begin
				tlb_select <= `WB_SELECT_UART;
			end else if (tlb_addr == 32'h1fd003fc) begin
				tlb_select <= `WB_SELECT_UART_STAT;
			end else if (tlb_addr == 32'h1fd00400) begin
				tlb_select <= `WB_SELECT_DIGSEG;
			end else if (tlb_addr == 32'h0f000000) begin
				tlb_select <= `WB_SELECT_PS2;
			end else begin
				tlb_select <= `WB_SELECT_ZERO;
			end
		end
	end

endmodule
