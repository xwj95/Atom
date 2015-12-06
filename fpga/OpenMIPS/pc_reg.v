`include "defines.v"

module pc_reg(
	input		wire					clk,
	input		wire					rst,
	input		wire[5:0]				stall,		//���Կ���ģ��CTRL
	input		wire					flush,
	input		wire[`RegBus]			new_pc,
	input		wire					branch_flag_i,
	input		wire[`RegBus]			branch_target_address_i,
	output		reg[`InstAddrBus]		pc,
	output		reg						ce
	);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;						//��λʱָ��洢������
		end else begin
			ce <= `ChipEnable;						//��λ������ָ��洢��ʹ��
		end
	end

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= 32'h00000004;						//ָ��洢������ʱ��PCΪ0
		end else begin
			if (flush == 1'b1) begin				//�����ź�flushΪ1��ʾ�쳣����������CTRLģ��������쳣����������ڵ�ַnew_pc��ȡִָ��
				pc <= new_pc;
			end else if (stall[0] == `NoStop) begin
				if (branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end else begin
					pc <= pc + 4'h4;				//ָ��洢��ʹ��ʱ��PC��ֵÿʱ�����ڼ�4
				end
			end
		end
	end

endmodule
