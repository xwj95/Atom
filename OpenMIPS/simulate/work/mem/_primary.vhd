library verilog;
use verilog.vl_types.all;
entity mem is
    port(
        rst             : in     vl_logic;
        wd_i            : in     vl_logic_vector(4 downto 0);
        wreg_i          : in     vl_logic;
        wdata_i         : in     vl_logic_vector(31 downto 0);
        hi_i            : in     vl_logic_vector(31 downto 0);
        lo_i            : in     vl_logic_vector(31 downto 0);
        whilo_i         : in     vl_logic;
        aluop_i         : in     vl_logic_vector(7 downto 0);
        mem_addr_i      : in     vl_logic_vector(31 downto 0);
        reg2_i          : in     vl_logic_vector(31 downto 0);
        mem_data_i      : in     vl_logic_vector(31 downto 0);
        cp0_reg_we_i    : in     vl_logic;
        cp0_reg_write_addr_i: in     vl_logic_vector(4 downto 0);
        cp0_reg_data_i  : in     vl_logic_vector(31 downto 0);
        wd_o            : out    vl_logic_vector(4 downto 0);
        wreg_o          : out    vl_logic;
        wdata_o         : out    vl_logic_vector(31 downto 0);
        hi_o            : out    vl_logic_vector(31 downto 0);
        lo_o            : out    vl_logic_vector(31 downto 0);
        whilo_o         : out    vl_logic;
        cp0_reg_we_o    : out    vl_logic;
        cp0_reg_write_addr_o: out    vl_logic_vector(4 downto 0);
        cp0_reg_data_o  : out    vl_logic_vector(31 downto 0);
        mem_addr_o      : out    vl_logic_vector(31 downto 0);
        mem_we_o        : out    vl_logic;
        mem_sel_o       : out    vl_logic_vector(3 downto 0);
        mem_data_o      : out    vl_logic_vector(31 downto 0);
        mem_ce_o        : out    vl_logic
    );
end mem;
