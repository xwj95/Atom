library verilog;
use verilog.vl_types.all;
entity wishbone_bus is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall_i         : in     vl_logic_vector(5 downto 0);
        flush_i         : in     vl_logic;
        mmu_ce_i        : in     vl_logic;
        mmu_data_i      : in     vl_logic_vector(31 downto 0);
        mmu_addr_i      : in     vl_logic_vector(31 downto 0);
        mmu_we_i        : in     vl_logic;
        mmu_select_i    : in     vl_logic_vector(15 downto 0);
        mmu_data_o      : out    vl_logic_vector(31 downto 0);
        mmu_ack_o       : out    vl_logic;
        wishbone_data_i : in     vl_logic_vector(31 downto 0);
        wishbone_ack_i  : in     vl_logic;
        wishbone_addr_o : out    vl_logic_vector(31 downto 0);
        wishbone_data_o : out    vl_logic_vector(31 downto 0);
        wishbone_we_o   : out    vl_logic;
        wishbone_select_o: out    vl_logic_vector(15 downto 0);
        wishbone_stb_o  : out    vl_logic;
        wishbone_cyc_o  : out    vl_logic;
        stallreq        : out    vl_logic
    );
end wishbone_bus;
