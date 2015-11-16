`include "defines.v"

module pc_reg(
	input		wire					clk,
	input		wire					rst,
	input		wire[5:0]				stall, //来自控制模块CTRL
	input		wire					branch_flag_i,
	input		wire[`RegBus]			branch_target_address_i,
	output		reg[`InstAddrBus]		pc,
	output		reg						ce
    );
    
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;					//复位时指令存储器禁用
		end else begin
			ce <= `ChipEnable;					//复位结束后，指令存储器使能
		end
	end
	
	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;					//指令存储器禁用时，PC为0
		end else if (stall[0] == `NoStop) begin
			if (branch_flag_i == `Branch) begin
				pc <= branch_target_address_i;
			end else begin
				pc <= pc + 4'h4;					//指令存储器使能时，PC的值每时钟周期加4
			end
		end
	end

endmodule
