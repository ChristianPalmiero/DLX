library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mux_2_1_5bit is
	port(
		a : in std_logic_vector(4 downto 0);
		b : in std_logic_vector(4 downto 0);
		sel : in std_logic;
		o : out std_logic_vector(4 downto 0)
		);
end mux_2_1_5bit;

architecture Behavioral of mux_2_1_5bit is

begin
	process(a,b,sel)
	begin
		if(sel = '1')then
			o <= a;
		else o <= b;
		end if;
	end process;
end Behavioral;

