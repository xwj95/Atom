`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:51 11/26/2015 
// Design Name: 
// Module Name:    Atom 
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
module Atom(

	//时钟复位

	input		wire						Reset,
	input		wire						CLK_From_Key,
	input		wire						CLK11M00592,
	input		wire						CLK50M,

/*	//基本内存

	output		wire[`RamAddrBus]			BaseRamAddr,
	inout		wire[`RamDataBus]			BaseRamData,
	output		reg							BaseRamCE,
	output		reg							BaseRamOE,
	output		reg							BaseRamWE,
*/
	//七段数码管

	output		reg[`DYPNum]				DYP0,
	output		reg[`DYPNum]				DYP1,
/*
	//以太网

	inout		wire[`ENetBus]				ENet_D,
	input		wire						ENet_CMD,
	input		wire						ENet_CS,
	input		wire						ENet_INT,
	input		wire						ENet_IOR,
	input		wire						ENet_IOW,
	input		wire						ENet_RESET,
	input		wire						ENet25M,

	//扩展内存

	output		wire[`RamAddrBus]			ExtRamAddr,
	inout		wire[`RamDataBus]			ExtRamData,
	output		reg							ExtRamCE,
	output		reg							ExtRamOE,
	output		reg							ExtRamWE,

	//Flash

	output		reg[`FlashAddrBus]			Flash_A,
	inout		wire[`FlashDataBus]			Flash_D,
	output		reg							Flash_BYTE,
	output		reg[2:0]					Flash_CE,
	output		reg							Flash_OE,
	output		reg							Flash_RP,
	output		reg							Flash_STS,
	output		reg							Flash_VPEN,
	output		reg							Flash_WE,
*/
	//自复位开关

	input		wire[`KeyNum]				FPGA_Key,

	//发光二极管

	output		reg[`LEDNum]				FPGA_LED,

	//CPLD互连线

	inout		wire[`CPLDBus]				InterConn,
/*
	//USB OTG

	output		reg[`OTGAddrBus]			OTG_A,
	inout		wire[`OTGDataBus]			OTG_D,
	output		reg							OTG_CS,
	output		reg[1:0]					OTG_DACK,
	output		reg[1:0]					OTG_DREQ,
	output		reg							OTG_FSPEED,
	output		reg[1:0]					OTG_INT,
	output		reg							OTG_LSPEED,
	output		reg							OTG_OE,
	output		reg							OTG_RESET,
	output		reg							OTG_WE,
*/
	//开关

	input		wire[`SWNum]				SW_DIP
/*
	//USB串口

	input		wire						U_RXD,
	output		reg							U_TXD,

	//VGA

	output		reg[`VGANum]				VGA_B,
	output		reg[`VGANum]				VGA_G,
	output		reg[`VGANum]				VGA_R,
	output		reg							VGA_Vhvnc,
	output		reg							VGA_Hhvnc
*/
	);

	always @ (*) begin
		FPGA_LED[13:0] <= SW_DIP[13:0];
		FPGA_LED[14] <= Reset;
		FPGA_LED[15] <= CLK_From_Key;
		DYP0 <= 7'b1111110;
		DYP1 <= 7'b0111101;
	end

endmodule
