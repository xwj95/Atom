library verilog;
use verilog.vl_types.all;
entity digseg_driver is
    port(
        data            : in     vl_logic_vector(3 downto 0);
        seg             : out    vl_logic_vector(0 to 6);
        ack             : out    vl_logic
    );
end digseg_driver;
