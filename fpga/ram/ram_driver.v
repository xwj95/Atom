module ram_driver(
	input clk,
	input enable,
	input enable_read,
	input enable_write,
	
	input [20:0] addr,
	input [31:0] data_in,
	output [31:0] data_out,

	output reg write_finished,
	output read_ready,

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
	reg [20:0] addr_latch = 0;
	reg [31:0] data_latch = 0;

	wire [20:0] addr_to_dev = enable_read ? addr : addr_latch;
	wire ram_selector = addr_to_dev[20];

	reg ram_oe = 1, ram_we = 1;

	assign baseram_ce = ~(enable & ~ram_selector),
		extram_ce = ~(enable & ram_selector),
		baseram_oe = ~(enable & ~ram_selector & ~ram_oe),
		extram_oe = ~(enable & ram_selector & ~ram_oe),
		baseram_we = ~(enable & ~ram_selector & ~ram_we),
		extram_we = ~(enable & ram_selector & ~ram_we);

	assign data_out = ram_selector ? extram_data : baseram_data;

	assign baseram_data = baseram_oe ? data_latch : {32{1'bz}},
		extram_data = extram_oe ? data_latch : {32{1'bz}},
		baseram_addr = addr_to_dev[19:0],
		extram_addr = addr_to_dev[19:0];

	reg [1:0] state;
	reg [2:0] read_wait;
	localparam IDLE = 2'b00, READ = 2'b01, WRITE0 = 2'b11, WRITE1 = 2'b10;

	assign read_ready = (state == READ && read_wait[2]);

	always @ (posedge clk) begin
		case (state)
			IDLE: begin
				write_finished <= 0;
				if (enable & enable_read) begin
					ram_oe <= 0;
					state <= READ;
					read_wait <= 0;
				end else if (enable & enable_write) begin
					addr_latch <= addr;
					data_latch <= data_in;
					ram_oe <= 1;
					state <= WRITE0;
				end else begin
					ram_oe <= 1;
				end
			end
			READ: begin
				if (!read_wait[2]) begin
					read_wait <= read_wait + 1'b1;
				end else if (!enable_read) begin
					state <= IDLE;
					ram_oe <= 1;
					read_wait <= 0;
				end
			end
			WRITE0: begin
				state <= WRITE1;
			end
			WRITE1: begin
				write_finished <= 1;
				state <= IDLE;
			end

		endcase
	end

	always @ (negedge clk) begin
		ram_we <= (state != WRITE0);
	end

endmodule
