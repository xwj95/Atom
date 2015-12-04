library verilog;
use verilog.vl_types.all;
entity mmu is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        if_ce_i         : in     vl_logic;
        if_data_i       : in     vl_logic_vector(31 downto 0);
        if_addr_i       : in     vl_logic_vector(31 downto 0);
        if_we_i         : in     vl_logic;
        if_sel_i        : in     vl_logic_vector(3 downto 0);
        if_data_o       : out    vl_logic_vector(31 downto 0);
        stall_req_if    : out    vl_logic;
        mem_ce_i        : in     vl_logic;
        mem_data_i      : in     vl_logic_vector(31 downto 0);
        mem_addr_i      : in     vl_logic_vector(31 downto 0);
        mem_we_i        : in     vl_logic;
        mem_sel_i       : in     vl_logic_vector(3 downto 0);
        mem_data_o      : out    vl_logic_vector(31 downto 0);
        stall_req_mem   : out    vl_logic;
        tlb_ce          : out    vl_logic;
        tlb_write_o     : out    vl_logic;
        tlb_addr_o      : out    vl_logic_vector(31 downto 0);
        tlb_addr_i      : in     vl_logic_vector(31 downto 0);
        tlb_select_i    : in     vl_logic_vector(15 downto 0);
        tlb_excepttype_is_tlbm_i: in     vl_logic;
        tlb_excepttype_is_tlbl_i: in     vl_logic;
        tlb_excepttype_is_tlbs_i: in     vl_logic;
        mmu_ce_o        : out    vl_logic;
        mmu_data_o      : out    vl_logic_vector(31 downto 0);
        mmu_addr_o      : out    vl_logic_vector(31 downto 0);
        mmu_we_o        : out    vl_logic;
        mmu_select_o    : out    vl_logic_vector(15 downto 0);
        mmu_data_i      : in     vl_logic_vector(31 downto 0);
        mmu_ack_i       : in     vl_logic;
        stall_req       : in     vl_logic
    );
end mmu;
