`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:24:10 11/24/2015 
// Design Name: 
// Module Name:    cpld 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cpld(
	input		wire		IC0,
	input		wire		IC1,
	output	reg		RxD,
	output	reg		TxD
    );
	 always @ (*) begin
		RxD <= IC0;
		TxD <= IC1;
	 end
	 


endmodule
