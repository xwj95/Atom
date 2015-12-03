library verilog;
use verilog.vl_types.all;
entity openmips_min_sopc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        baseram_addr    : out    vl_logic_vector(19 downto 0);
        baseram_data    : inout  vl_logic_vector(31 downto 0);
        baseram_ce      : out    vl_logic;
        baseram_oe      : out    vl_logic;
        baseram_we      : out    vl_logic;
        extram_addr     : out    vl_logic_vector(19 downto 0);
        extram_data     : inout  vl_logic_vector(31 downto 0);
        extram_ce       : out    vl_logic;
        extram_oe       : out    vl_logic;
        extram_we       : out    vl_logic;
        flash_addr      : out    vl_logic_vector(22 downto 0);
        flash_data      : inout  vl_logic_vector(15 downto 0);
        flash_ctl       : out    vl_logic_vector(7 downto 0);
        com_TxD         : out    vl_logic;
        com_RxD         : in     vl_logic;
        segdisp0        : out    vl_logic_vector(0 to 6);
        segdisp1        : out    vl_logic_vector(0 to 6)
    );
end openmips_min_sopc;
