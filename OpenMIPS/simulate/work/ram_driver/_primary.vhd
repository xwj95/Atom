library verilog;
use verilog.vl_types.all;
entity ram_driver is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        enable          : in     vl_logic;
        read_enable     : in     vl_logic;
        write_enable    : in     vl_logic;
        addr            : in     vl_logic_vector(20 downto 0);
        data_in         : in     vl_logic_vector(31 downto 0);
        data_out        : out    vl_logic_vector(31 downto 0);
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
        ack             : out    vl_logic
    );
end ram_driver;
