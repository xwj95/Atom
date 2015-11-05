`include "defines.v"
module id(
	input		wire					rst,
	input		wire[`InstAddrBus]		pc_i,
	input		wire[`InstBus]			inst_i,
	
	//读取的Regfile的值
	input		wire[`RegBus]			reg1_data_i,
	input		wire[`RegBus]			reg2_data_i,

	//处于执行阶段的指令的运算结果
	input		wire					ex_wreg_i,
	input		wire[`RegBus]			ex_wdata_i,
	input		wire[`RegBus]			ex_wd_i,

	//处于访存阶段的指令的运算结果
	input		wire					mem_wreg_i,
	input		wire[`RegBus]			mem_wdata_i,
	input		wire[`RegBus]			mem_wd_i,
	
	//输出到Regfile的信息
	output		reg						reg1_read_o,
	output		reg						reg2_read_o,
	output		reg[`RegAddrBus]		reg1_addr_o,
	output		reg[`RegAddrBus]		reg2_addr_o,
	
	//送到执行阶段的信息
	output		reg[`AluOpBus]			aluop_o,
	output		reg[`AluSelBus]			alusel_o,
	//送到执行阶段的源操作数1、源操作数2
	output		reg[`RegBus]			reg1_o,
	output		reg[`RegBus]			reg2_o,
	output		reg[`RegAddrBus]		wd_o,
	output		reg						wreg_o
    );
	
	//取得指令的指令码，功能码
	wire[5:0] op = inst_i[31:26];
	wire[4:0] op2 = inst_i[10:6];
	wire[5:0] op3 = inst_i[5:0];
	wire[4:0] op4 = inst_i[20:16];
	 
	//保存指令执行需要的立即数
	reg[`RegBus] imm;
	 
	//指示指令是否有效
	reg instvalid;
	 
/************				第一段：对指令进行译码				************/
	always @ (*) begin
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;
		end else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];		//默认通过Regfile读端口1读取的寄存器地址
			reg2_addr_o <= inst_i[20:16];		//默认通过Regfile读端口2读取的寄存器地址
			imm <= `ZeroWord;
			
			case (op)
				`EXE_SPECIAL_INST: begin		//指令码是SPECIAL
					case (op2)
						5'b00000: begin				//依据功能码判断是哪种指令
							case (op3)
								`EXE_OR: begin			//or指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_OR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_AND: begin			//and指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_AND_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_XOR: begin			//xor指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_XOR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_NOR: begin			//nor指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_NOR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_SLLV: begin		//sllv指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SLL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_SRLV: begin		//slrv指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SRL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_SRAV: begin		//srav指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SRA_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 1'b1;
									reg2_read_o <= 1'b1;
									instvalid <= `InstValid;
								end
								`EXE_CACHE: begin		//cache指令
									wreg_o <= `WriteEnable;
									aluop_o <= `EXE_SLL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= 0'b1;
									reg2_read_o <= 0'b1;
									instvalid <= `InstValid;
								end
								default: begin
								end
							endcase
						end
						`EXE_ORI: begin			//ori指令
							//ori指令需要将结果写入目的寄存器，所以wreg_o为WriteEnable
							wreg_o <= `WriteEnable;
							
							//运算的子类型是逻辑“或”运算
							aluop_o <= `EXE_OR_OP;
							
							//运算类型是逻辑运算
							alusel_o <= `EXE_RES_LOGIC;
							
							//需要通过Regfile的读端口1读取寄存器
							reg1_read_o <= 1'b1;
							
							//不需要通过Regfile的读端口2读取寄存器
							reg2_read_o <= 1'b0;
							
							//指令执行需要的立即数
							imm <= {16'h0, inst_i[15:0]};
							
							//指令执行要写的目的寄存器地址
							wd_o <= inst_i[20:16];
							
							//ori指令是有效指令
							instvalid <= `InstValid;
						end
						`EXE_ANDI: begin		//andi指令
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_AND_OP;
							alusel_o <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b0;
							imm <= {16'h0, inst_i[15:0]};
							wd_o <= inst_i[20:16];
							instvalid <= `InstValid;
						end
						`EXE_XORI: begin		//xori指令
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_XOR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b0;
							imm <= {16'h0, inst_i[15:0]};
							wd_o <= inst_i[20:16];
							instvalid <= `InstValid;
						end
						`EXE_LUI: begin			//lui指令
							wreg_o <= `WriteEnable;
							aluop_o <= `EXE_OR_OP;
							alusel_o <= `EXE_RES_LOGIC;
							reg1_read_o <= 1'b1;
							reg2_read_o <= 1'b0;
							imm <= {inst_i[15:0], 16'h0};
							wd_o <= inst_i[20:16];
							instvalid <= `InstValid;
						end
						default: begin
						end
					endcase
				end
				default: begin
				end
			endcase
			
			if (inst_i[31:21] == 11'b00000000000) begin
				if (op3 == `EXE_SLL) begin		//sll指令
					wreg_o <= `WriteEnable;
					aluop_o <= `EXE_SLL_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= 1'b0;
					reg2_read_o <= 1'b1;
					imm[4:0] <= inst_i[10:6];
					wd_o <= inst_i[15:11];
					instvalid <= `InstValid;
				end else if (op3 == `EXE_SRL) begin		//srl指令
					wreg_o <= `WriteEnable;
					aluop_o <= `EXE_SRL_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= 1'b0;
					reg2_read_o <= 1'b1;
					imm[4:0] <= inst_i[10:6];
					wd_o <= inst_i[15:11];
					instvalid <= `InstValid;
				end else if (op3 == `EXE_SRA) begin		//sra指令
					wreg_o <= `WriteEnable;
					aluop_o <= `EXE_SRA_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= 1'b0;
					reg2_read_o <= 1'b1;
					imm[4:0] <= inst_i[10:6];
					wd_o <= inst_i[15:11];
					instvalid <= `InstValid;
				end
			end
		end		//if
	end		//always
	
/************			第二段：确定进行运算的源操作数2			************/
	//给reg1_o赋值的过程增加了两种情况：
	//1. 如果Regfile模块读端口1要读取的寄存器就是执行阶段要写的目的寄存器，
	//   那么直接把执行阶段的结果ex_wdata_i作为reg1_o的值；
	//2. 如果Regfile模块读端口1要读取的寄存器就是访存阶段要写的目的寄存器，
	//   那么直接把访存阶段的结果mem_wdata_i作为reg1_o的值；
	always @ (*) begin
		if (rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
			reg1_o <= ex_wdata_i;
		end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
			reg1_o <= mem_wdata_i;
		end else if (reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;				//Regfile读端口1的输出值
		end else if (reg1_read_o == 1'b0) begin
			reg1_o <= imm;						//立即数
		end else begin
			reg1_o <= `ZeroWord;
		end
	end
		
/************			第三段：确定进行运算的源操作数2			************/
	//给reg2_o赋值的过程增加了两种情况：
	//1. 如果Regfile模块读端口2要读取的寄存器就是执行阶段要写的目的寄存器，
	//   那么直接把执行阶段的结果ex_wdata_i作为reg2_o的值；
	//2. 如果Regfile模块读端口2要读取的寄存器就是访存阶段要写的目的寄存器，
	//   那么直接把访存阶段的结果mem_wdata_i作为reg2_o的值；
	always @ (*) begin
		if (rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
			reg2_o <= ex_wdata_i;
		end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
			reg2_o <= mem_wdata_i;
		end else if (reg2_read_o == 1'b1) begin
			reg2_o <= reg2_data_i;				//Regfile读端口2的输出值
		end else if (reg2_read_o == 1'b0) begin
			reg2_o <= imm;						//立即数
		end else begin
			reg2_o <= `ZeroWord;
		end
	end

endmodule
