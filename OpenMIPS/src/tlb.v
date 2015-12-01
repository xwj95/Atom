`include "defines.v"

module tlb(
	input		wire					rst,

	input		wire[`RegBus]			mmu_addr,
	output		reg[`RegBus]			tlb_addr,
	output		reg[15:0]				tlb_select
	);

	always @ (*) begin
		tlb_addr <= mmu_addr;
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
