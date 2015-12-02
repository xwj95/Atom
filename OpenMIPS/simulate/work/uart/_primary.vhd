library verilog;
use verilog.vl_types.all;
entity uart is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0);
        TxD_start       : in     vl_logic;
        TxD_busy        : out    vl_logic;
        RxD_data_ready  : out    vl_logic;
        com_TxD         : out    vl_logic;
        com_RxD         : in     vl_logic;
        ack             : out    vl_logic
    );
end uart;
