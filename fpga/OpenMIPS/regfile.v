`include "defines.v"

module regfile(
	input		wire					clk,
	input		wire					rst,
	
	//写端�
	input		wire					we,
	input		wire[`RegAddrBus]		waddr,
	input		wire[`RegBus]			wdata,
	
	//读端�
	input		wire					re1,
	input		wire[`RegAddrBus]		raddr1,
	output		reg[`RegBus]			rdata1,
	
	//读端�
	input		wire					re2,
	input		wire[`RegAddrBus]		raddr2,
	output		reg[`RegBus]			rdata2,

	input		wire[`RegAddrBus] 		select,
	output 		reg[`RegBus]			output_data
	);

/************			第一段：定义32�2位寄存器		************/
	reg[`RegBus]	regs[0:`RegNum-1];

	always @ (posedge clk) begin
		output_data <= regs[select];
	end


/************			第二段：写操�			************/
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end

/************			第三段：读端�的读操作			************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			rdata1 <= `ZeroWord;
		end else if (raddr1 == `RegNumLog2'h0) begin
			rdata1 <= `ZeroWord;
		end else if ((raddr1 == waddr) &&
					(we == `WriteEnable) &&
					(re1 == `ReadEnable)) begin
			//raddr1是读操作，waddr是写地址、we是写使能、wdata是要写入的数�			rdata1 <= wdata;
		end else if (re1 == `ReadEnable) begin
			rdata1 <= regs[raddr1];
		end else begin
			rdata1 <= `ZeroWord;
		end
	end

/************			第四段：读端�的读操作			************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			rdata2 <= `ZeroWord;
		end else if (raddr2 == `RegNumLog2'h0) begin
			rdata2 <= `ZeroWord;
		end else if ((raddr2 == waddr) &&
					(we == `WriteEnable) &&
					(re2 == `ReadEnable)) begin
			//raddr2是读操作，waddr是写地址、we是写使能、wdata是要写入的数�			rdata2 <= wdata;
		end else if (re2 == `ReadEnable) begin
			rdata2 <= regs[raddr2];
		end else begin
			rdata2 <= `ZeroWord;
		end
	end

endmodule
