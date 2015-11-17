library verilog;
use verilog.vl_types.all;
entity openmips is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        int_i           : in     vl_logic_vector(5 downto 0);
        rom_data_i      : in     vl_logic_vector(31 downto 0);
        rom_addr_o      : out    vl_logic_vector(31 downto 0);
        rom_ce_o        : out    vl_logic;
        ram_data_i      : in     vl_logic_vector(31 downto 0);
        ram_addr_o      : out    vl_logic_vector(31 downto 0);
        ram_data_o      : out    vl_logic_vector(31 downto 0);
        ram_we_o        : out    vl_logic;
        ram_sel_o       : out    vl_logic_vector(3 downto 0);
        ram_ce_o        : out    vl_logic_vector(3 downto 0);
        timer_int_o     : out    vl_logic
    );
end openmips;
