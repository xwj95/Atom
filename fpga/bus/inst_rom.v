`include "defines.v"
module inst_rom(
	input		wire						ce,
	input		wire[`InstAddrBus]			addr,
	output		reg[`InstBus]				inst, 
	output 		reg 						ack
	);

	//定义一个数组，大小是InstMemNum，元素宽度是InstBus
	reg[`InstBus]	inst_mem[0:`InstMemNum-1];

	//当复位信号无效时，根据输入的地址，给出指令存储器ROM中对应的元素
	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
			ack <= 1'b0;
		end else begin
			inst <= 32'h11111111;
			//inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
			ack <= 1'b1;
		end
	end

endmodule