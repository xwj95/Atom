module ramtest (
	input clk,    // Clock
	input rst,

	input [7:0] user_addr,
	input [3:0] user_data,

	output [0:6] segdisp0,

	input read_enable, 
	input write_enable,

	output reg [19:0] baseram_addr, 
	inout [31:0] baseram_data,
	output reg baseram_ce, 
	output reg baseram_oe, 
	output reg baseram_we 
	);

	wire[31:0] data_from_ram;
	reg[3:0] data_out;
	digseg_driver digseg_show_data(data_out[3:0], segdisp0);

	reg[2:0] state;	
	localparam IDLE = 3'b000, READ1 = 3'b001, READ2 = 3'b010, READ3 = 3'b011,
		WRITE1 = 3'b100, WRITE2 = 3'b101, WRITE3 = 3'b110;

	reg [31:0] data_latch = 0;

	assign baseram_data = baseram_oe ? data_latch : {32{1'bz}};

	always @ (posedge clk) begin
		if (rst == 1'b0) begin
			state <= IDLE;
			baseram_ce <= 1'b1;
			baseram_we <= 1'b1;
			baseram_oe <= 1'b1;
		end
		case (state)
			IDLE: begin
				baseram_ce <= 1'b1;
				if (read_enable == 1'b0) begin
					state <= READ1;
				end else if (write_enable == 1'b0) begin
					state <= WRITE1;
				end
			end
			READ1: begin
				baseram_ce <= 1'b0;
				baseram_oe <= 1'b0;
				baseram_we <= 1'b1;
				baseram_addr <= {12'b0, user_addr};
				state <= READ2;
			end
			READ2: begin
				data_out <= baseram_data[3:0];
				state <= READ3;
			end
			READ3: begin
				baseram_ce <= 1'b1;
				baseram_oe <= 1'b1;
				baseram_we <= 1'b1;
				state <= IDLE;
			end
			WRITE1: begin
				baseram_ce <= 1'b0;
				baseram_oe <= 1'b1;
				baseram_we <= 1'b1;
				baseram_addr <= {12'b0, user_addr};
				data_latch <= {28'b0, user_data};
				state <= WRITE2;
			end
			WRITE2: begin
				baseram_we <= 1'b0;
				state <= WRITE3;
			end
			WRITE3: begin
				baseram_ce <= 1'b1;
				baseram_we <= 1'b1;
				baseram_oe <= 1'b1;
				state <= IDLE;
			end
			default: begin
				state <= IDLE;
			end
		endcase
	end


endmodule