//ʱ�䵥λ��1ns��������1ps
`timescale 1ns / 1ps
`include "defines.v"

module openmips_min_sopc_tb();

	// Inputs
	reg CLOCK_50;
	reg rst;

	//ÿ��10ns��CLOCK_50�źŷ�תһ�Σ�����һ��������20ns����Ӧ50MHz
	initial begin
		CLOCK_50 = 1'b0;
		forever #10 CLOCK_50 = ~CLOCK_50;
	end
	
	initial begin
		rst = `RstEnable;
		#195 rst = `RstDisable;
		#1000 $stop;
	end
	
	//������СSOPC
	openmips_min_sopc openmips_min_sopc0 (
		.clk(CLOCK_50),
		.rst(rst)
	);
      
endmodule
