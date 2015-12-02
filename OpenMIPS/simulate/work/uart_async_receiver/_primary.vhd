library verilog;
use verilog.vl_types.all;
entity uart_async_receiver is
    generic(
        ClkFrequency    : integer := 25000000;
        Baud            : integer := 115200;
        Oversampling    : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        RxD             : in     vl_logic;
        RxD_data_ready  : out    vl_logic;
        RxD_waiting_data: out    vl_logic;
        RxD_data        : out    vl_logic_vector(7 downto 0);
        ack             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ClkFrequency : constant is 1;
    attribute mti_svvh_generic_type of Baud : constant is 1;
    attribute mti_svvh_generic_type of Oversampling : constant is 1;
end uart_async_receiver;
