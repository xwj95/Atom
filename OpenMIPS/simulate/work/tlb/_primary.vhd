library verilog;
use verilog.vl_types.all;
entity tlb is
    port(
        rst             : in     vl_logic;
        mmu_addr        : in     vl_logic_vector(31 downto 0);
        mmu_write       : in     vl_logic;
        tlb_ce          : in     vl_logic;
        tlb_addr        : out    vl_logic_vector(31 downto 0);
        tlb_select      : out    vl_logic_vector(15 downto 0);
        tlb_we          : out    vl_logic;
        tlb_index       : out    vl_logic_vector(3 downto 0);
        tlb_data        : out    vl_logic_vector(63 downto 0);
        excepttype_is_tlbm: out    vl_logic;
        excepttype_is_tlbl: out    vl_logic;
        excepttype_is_tlbs: out    vl_logic
    );
end tlb;
