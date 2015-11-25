----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:20:55 11/04/2015 
-- Design Name: 
-- Module Name:    serial - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serial is
    Port ( clk : in  STD_LOGIC;
           TxD : out  STD_LOGIC;
			  TxD_data : in STD_LOGIC_VECTOR(7 downto 0);
			  
			  RxD_data : out STD_LOGIC_VECTOR(7 downto 0);
           RxD : in  STD_LOGIC;
			  
			  ram_en : out std_logic;
			  indicator : out std_logic_vector(1 downto 0)
			  );
end serial;

architecture Behavioral of serial is


signal clk_div2 : std_logic; -- 2分频 25MHz
signal clk_div4 : std_logic; -- 4分频 12.5MHz
signal clk_div8 : std_logic; -- 8分频 6.25MHz

signal count : std_logic_vector(3 downto 0);-- clock计数
signal state : std_logic_vector(1 downto 0);-- 读写串口状态
signal RxD_endofpacket : std_logic := '0';


signal RxD_data_buffer : STD_LOGIC_VECTOR(7 downto 0);
signal TxD_data_buffer : STD_LOGIC_VECTOR(7 downto 0);
signal TxD_start : STD_LOGIC := '0';
signal TxD_busy : STD_LOGIC := '0';
signal RxD_data_ready : STD_LOGIC := '0';
signal RxD_idle : std_logic := '1';


component async_transmitter
    port(clk: in std_logic; TxD_start: in std_logic; TxD_data: in std_logic_vector(7 downto 0); TxD: out std_logic; TxD_busy: out std_logic);
end component;


component async_receiver
    port(clk: in std_logic; RxD: in std_logic; RxD_data_ready: out std_logic; RxD_data: out std_logic_vector(7 downto 0); RxD_endofpacket : out std_logic; RxD_idle : out std_logic);
end component;

begin
	
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (count = "1111") then
				count <= "0000";
			else
				count <= std_logic_vector(to_unsigned(to_integer(unsigned( count )) + 1, 4));
			end if;
		end if;
	end process;
	
	clk_div2 <= count(0);
	clk_div4 <= count(1);
	clk_div8 <= count(2);
	
	RxD_data <= RxD_data_buffer;
	
	u3: async_receiver port map(clk => clk_div2, RxD => RxD, RxD_data_ready => RxD_data_ready, RxD_data => RxD_data_buffer, RxD_endofpacket => RxD_endofpacket, RxD_idle => RxD_idle);  
	u4: async_transmitter port map(clk => clk_div2, Txd => TxD, TxD_start => TxD_start, TxD_data => TxD_data_buffer, Txd_busy => Txd_busy);

	ram_en <= '1';
	
	indicator <= state;
	
	
	process(clk_div2, state)
	begin
      if (clk_div2'event and clk_div2 = '1') then
			case (state) is
				-- 控制复位
				when "00" =>
					if (RxD = '0') then
						state <= "01";
					else
						state <= "00";
					end if;
				-- 读入
				when "01" =>
					if (RxD_data_ready = '1') then
						TxD_start <= '1';
						TxD_data_buffer <= std_logic_vector( unsigned(RxD_data_buffer) + 1 );
						state <= "10";
					else
						state <= "01";
					end if;
				-- 输出
				when "10" =>
					if (TxD_start = '0' and TxD_busy = '0') then
						state <= "00";
					else
						TxD_start <= '0';
						state <= "10";
					end if;
				when others =>
					state <= "00";
			end case;
		end if;
	end process;
end Behavioral;

