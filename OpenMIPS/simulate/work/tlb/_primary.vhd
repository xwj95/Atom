library verilog;
use verilog.vl_types.all;
entity tlb is
    port(
        rst             : in     vl_logic;
        mmu_addr        : in     vl_logic_vector(31 downto 0);
        tlb_addr        : out    vl_logic_vector(31 downto 0);
        tlb_select      : out    vl_logic_vector(15 downto 0)
    );
end tlb;
