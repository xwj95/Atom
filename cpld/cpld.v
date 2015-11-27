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
	input		wire		RXD1,
	output		reg			TXD1,
	input		wire		RXD2,
	output		reg			TXD2,
	input		wire		PS2KB_CLOCK,
	input		wire		PS2KB_DATA,

	output		reg			IC0,
	input		reg			IC1,
	output		reg			IC2,
	input		reg			IC3,
	output		reg			IC4,
	output		reg			IC5
	);
	always @ (*) begin
		IC0 <= RXD1;
		TXD1 <= IC1;
		IC2 <= RXD2;
		TXD3 <= IC3;
		IC4 <= PS2KB_CLOCK;
		IC5 <= PS2KB_DATA;
	end

endmodule
