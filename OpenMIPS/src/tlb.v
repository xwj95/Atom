`include "defines.v"

module tlb(
	input		wire					rst,

	input		wire[`RegBus]			mmu_addr,
	input		wire					mmu_write,
	input		wire					tlb_ce,
	output		reg[`RegBus]			tlb_addr,
	output		reg[15:0]				tlb_select,

	output		reg						tlb_we,
	output		reg[`TLBIndexBus]		tlb_index,
	output		reg[`TLBDataBus]		tlb_data,

	output		reg						excepttype_is_tlbm,
	output		reg						excepttype_is_tlbl,
	output		reg						excepttype_is_tlbs
	);

	reg[`TLBIndexNum-1:0] tlb_reg[`TLBDataBus];
	reg[`TLBIndexBus] tlb_find;
	reg[`TLBDataBus] tlb_item;

	/*********************		第一段：虚拟地址映射		*********************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			tlb_addr <= `ZeroWord;
			tlb_reg[0] <= 64'h0000000000000000;
			tlb_reg[1] <= 64'h0000000000000000;
			tlb_reg[2] <= 64'h0000000000000000;
			tlb_reg[3] <= 64'h0000000000000000;
			tlb_reg[4] <= 64'h0000000000000000;
			tlb_reg[5] <= 64'h0000000000000000;
			tlb_reg[6] <= 64'h0000000000000000;
			tlb_reg[7] <= 64'h0000000000000000;
			tlb_reg[8] <= 64'h0000000000000000;
			tlb_reg[9] <= 64'h0000000000000000;
			tlb_reg[10] <= 64'h0000000000000000;
			tlb_reg[11] <= 64'h0000000000000000;
			tlb_reg[12] <= 64'h0000000000000000;
			tlb_reg[13] <= 64'h0000000000000000;
			tlb_reg[14] <= 64'h0000000000000000;
			tlb_reg[15] <= 64'h0000000000000000;
			excepttype_is_tlbm <= `False_v;
			excepttype_is_tlbl <= `False_v;
			excepttype_is_tlbs <= `False_v;
		end else begin
			tlb_addr <= `ZeroWord;
			excepttype_is_tlbm <= `False_v;						//默认没有发生内存修改异常
			excepttype_is_tlbl <= `False_v;						//默认没有发生读未在TLB中映射的内存地址异常
			excepttype_is_tlbs <= `False_v;						//默认没有发生写未在TLB中映射的内存地址异常
			if (mmu_addr[31:30] == 2'b10) begin					//虚拟地址在[0x80000000, 0xbfffffff]范围内，不进行地址映射
				tlb_addr <= {2'b00, mmu_addr[29:0]};
			end else begin
				tlb_addr <= mmu_addr;

				tlb_item <= tlb_reg[0];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0000;
				end
				tlb_item <= tlb_reg[1];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0001;
				end
				tlb_item <= tlb_reg[2];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0010;
				end
				tlb_item <= tlb_reg[3];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0011;
				end
				tlb_item <= tlb_reg[4];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0100;
				end
				tlb_item <= tlb_reg[5];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0101;
				end
				tlb_item <= tlb_reg[6];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0110;
				end
				tlb_item <= tlb_reg[7];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b0111;
				end
				tlb_item <= tlb_reg[8];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1000;
				end
				tlb_item <= tlb_reg[9];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1001;
				end
				tlb_item <= tlb_reg[10];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1010;
				end
				tlb_item <= tlb_reg[11];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1011;
				end
				tlb_item <= tlb_reg[12];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1100;
				end
				tlb_item <= tlb_reg[13];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1101;
				end
				tlb_item <= tlb_reg[14];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1110;
				end
				tlb_item <= tlb_reg[15];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_find <= 4'b1111;
				end

				tlb_item <= tlb_reg[tlb_find];
				if (tlb_item[62:44] == mmu_addr[31:13]) begin
					tlb_addr[11:0] <= mmu_addr[11:0];
					if (mmu_addr[12] == 1'b1) begin
						tlb_addr[31:12] <= tlb_item[43:24];
						if ((tlb_item[23] == 1'b0) && (mmu_write == 1'b1)) begin
							excepttype_is_tlbm <= `True_v;
						end
					end else begin
						tlb_addr[31:12] <= tlb_item[21:2];
						if ((tlb_item[1] == 1'b0) && (mmu_write == 1'b1)) begin
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

			if (tlb_we == `WriteEnable) begin
				tlb_reg[tlb_index] <= tlb_data;					//TLB表项操作
			end
		end
	end

	/*********************		第二段：物理地址划分		*********************/
	always @ (*) begin
		tlb_select <= 16'b0000000000000000;
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
		end
	end

endmodule
