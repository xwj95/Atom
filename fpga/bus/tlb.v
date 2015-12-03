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

	/*********************		第一段：TLB表项写操作		*********************/
	always @ (*) begin
		if (rst == `RstEnable) begin
		end else begin
			if (tlb_we == `WriteEnable) begin
				tlb_reg[tlb_index] <= tlb_data;
			end
		end
	end

	/*********************		第二段：虚拟地址映射		*********************/
	genvar i;
	generate
		for (i = 0; i < `TLBIndexNum; i = i + 1) begin: tlb_clear
			always @ (*) begin
				if (rst == `RstEnable) begin
					tlb_reg[i] <= 64'h0000000000000000;
				end
			end
		end
	endgenerate

	generate
		for (i = 0; i < `TLBIndexNum; i = i + 1) begin: tlb_search
			always @ (*) begin
				tlb_item <= tlb_reg[i];
				if (tlb_item[62:44] == mmu_addr[32:14]) begin
					tlb_find <= i;
				end
			end
		end
	endgenerate

	always @ (*) begin
		if (rst == `RstEnable) begin
			tlb_addr <= `ZeroWord;
			tlb_select <= 16'b0000000000000000;
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
		end
	end

	/*********************		第三段：物理地址划分		*********************/
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
