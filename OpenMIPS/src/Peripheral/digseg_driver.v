module digseg_driver(
	input bus_clk_i,
	input bus_rst_i,
	input [31:0] bus_addr_i,
	input [31:0] bus_data_i,
	output reg[31:0] bus_data_o,
	input bus_select_i,
	input bus_we_i,
	output bus_ack_o
	);

	reg[0:6] seg;

	always @(*) begin
		bus_data_o <= {25'b0, seg};
		case (bus_data_i[3:0])
			4'b0000: seg = 7'b1111110;
			4'b0001: seg = 7'b0110000;
			4'b0010: seg = 7'b1101101;
			4'b0011: seg = 7'b1111001;
			4'b0100: seg = 7'b0110011;
			4'b0101: seg = 7'b1011011;
			4'b0110: seg = 7'b1011111;
			4'b0111: seg = 7'b1110000;
			4'b1000: seg = 7'b1111111;
			4'b1001: seg = 7'b1110011;
			4'b1010: seg = 7'b1110111;
			4'b1011: seg = 7'b0011111;
			4'b1100: seg = 7'b1001110;
			4'b1101: seg = 7'b0111101;
			4'b1110: seg = 7'b1001111;
			4'b1111: seg = 7'b1000111;
		endcase
		bus_ack_o <= 1'b1;
	end
endmodule

