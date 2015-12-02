library verilog;
use verilog.vl_types.all;
entity \bus\ is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wishbone_addr_i : in     vl_logic_vector(31 downto 0);
        wishbone_data_i : in     vl_logic_vector(31 downto 0);
        wishbone_we_i   : in     vl_logic;
        wishbone_sel_i  : in     vl_logic_vector(3 downto 0);
        wishbone_stb_i  : in     vl_logic;
        wishbone_cyc_i  : in     vl_logic;
        wishbone_select_i: in     vl_logic_vector(15 downto 0);
        wishbone_data_o : out    vl_logic_vector(31 downto 0);
        wishbone_ack_o  : out    vl_logic;
        ram_baseram_addr: out    vl_logic_vector(19 downto 0);
        ram_baseram_data: inout  vl_logic_vector(31 downto 0);
        ram_baseram_ce  : out    vl_logic;
        ram_baseram_oe  : out    vl_logic;
        ram_baseram_we  : out    vl_logic;
        ram_extram_addr : out    vl_logic_vector(19 downto 0);
        ram_extram_data : inout  vl_logic_vector(31 downto 0);
        ram_extram_ce   : out    vl_logic;
        ram_extram_oe   : out    vl_logic;
        ram_extram_we   : out    vl_logic;
        rom_inst        : out    vl_logic;
        flash_busy      : out    vl_logic;
        flash_addr      : out    vl_logic_vector(22 downto 0);
        flash_data      : inout  vl_logic_vector(15 downto 0);
        flash_ctl       : out    vl_logic_vector(7 downto 0);
        uart_TxD_busy   : out    vl_logic;
        uart_RxD_data_ready: out    vl_logic;
        uart_com_TxD    : out    vl_logic;
        uart_com_RxD    : in     vl_logic;
        digseg_seg      : out    vl_logic_vector(0 to 6)
    );
end \bus\;
