32'h00000000: begin bus_data_i <= 32'h34018000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000001: begin bus_data_i <= 32'h00010c00; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000002: begin bus_data_i <= 32'h34210010; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000003: begin bus_data_i <= 32'h34028000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000004: begin bus_data_i <= 32'h00021400; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000005: begin bus_data_i <= 32'h34420001; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000006: begin bus_data_i <= 32'h34030000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000007: begin bus_data_i <= 32'h00411821; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000008: begin bus_data_i <= 32'h34030000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000009: begin bus_data_i <= 32'h00411820; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000a: begin bus_data_i <= 32'h00231822; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000b: begin bus_data_i <= 32'h00621823; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000c: begin bus_data_i <= 32'h20630002; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000d: begin bus_data_i <= 32'h34030000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000e: begin bus_data_i <= 32'h24638000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000000f: begin bus_data_i <= 32'h3401ffff; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000010: begin bus_data_i <= 32'h00010c00; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000011: begin bus_data_i <= 32'h0020102a; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000012: begin bus_data_i <= 32'h0020102b; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000013: begin bus_data_i <= 32'h28228000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000014: begin bus_data_i <= 32'h2c228000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000015: begin bus_data_i <= 32'h3c010000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000016: begin bus_data_i <= 32'h70221021; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000017: begin bus_data_i <= 32'h70221020; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000018: begin bus_data_i <= 32'h3c01ffff; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000019: begin bus_data_i <= 32'h3421ffff; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001a: begin bus_data_i <= 32'h70221020; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001b: begin bus_data_i <= 32'h70221021; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001c: begin bus_data_i <= 32'h3c01a100; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001d: begin bus_data_i <= 32'h70221020; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001e: begin bus_data_i <= 32'h70221021; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000001f: begin bus_data_i <= 32'h3c011100; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000020: begin bus_data_i <= 32'h70221020; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000021: begin bus_data_i <= 32'h70221021; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000022: begin bus_data_i <= 32'h3401ffff; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000023: begin bus_data_i <= 32'h00010c00; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000024: begin bus_data_i <= 32'h3421fffb; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000025: begin bus_data_i <= 32'h34020006; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000026: begin bus_data_i <= 32'h70221802; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000027: begin bus_data_i <= 32'h00220018; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000028: begin bus_data_i <= 32'h00220019; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h00000029: begin bus_data_i <= 32'h00000000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end
32'h0000002a: begin bus_data_i <= 32'h00000000; bus_addr_i <= {12'b0, pc[19:0]}; pc <= pc + 1'b1; end