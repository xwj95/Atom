module ram_test (
	input clk,
	input enable_read_key,
	input enable_write_key,
	input [3:0] user_data,
	input [7:0] user_addr,
	output [0:6] segdisp0,
	output reg [2:0] led,

	output [19:0] baseram_addr,
	inout [31:0] baseram_data,
	output baseram_ce,
	output baseram_oe,
	output baseram_we,
	output [19:0] extram_addr,
	inout [31:0] extram_data,
	output extram_ce,
	output extram_oe,
	output extram_we
	);

	reg clk2;
	reg cnt = 1'b0;
	always @ (posedge clk) begin
		if (cnt == 1'b1) begin
			clk2 <= ~clk2;
			cnt <= 1'b0;
		end else begin
			cnt <= 1'b1;
		end
	end

	wire[31:0] data_from_ram;
	reg[3:0] data_to_show;
	digseg_driver digseg_show_data(data_to_show[3:0], segdisp0);

	reg enable_write_key_prev, enable_read_key_prev;
	assign mode_change_to_write = ~enable_write_key_prev & enable_write_key,
		mode_change_to_read = ~enable_read_key_prev & enable_read_key;

	always @ (posedge clk2) begin
		enable_write_key_prev <= enable_write_key;
		enable_read_key_prev <= enable_read_key;
	end

	wire write_finished, read_ready;
	always @(posedge clk2) begin
		if (mode_change_to_write)
			led[0] <= ~led[0];
		if (write_finished)
			led[1] <= ~led[1];
		if (read_ready) begin
			led[2] <= ~led[2];
			data_to_show <= data_from_ram[3:0];
		end
	end

	ram_driver ram_driver_inst(
		clk2, 1'b1,
		mode_change_to_read, mode_change_to_write, 
		{user_addr[7], 12'b0, user_addr}, {28'b0, user_data}, 
		data_from_ram, write_finished, read_ready, 
		baseram_addr, baseram_data, baseram_ce, baseram_oe, baseram_we, 
		extram_addr, extram_data, extram_ce, extram_oe, extram_we
	);

endmodule