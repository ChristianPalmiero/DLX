library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity regWithEnable_5bit is
	port(
		input : in std_logic_vector(4 downto 0);
		en : in std_logic;
		clock,reset : in std_logic;
		output : out std_logic_vector(4 downto 0)
	);
end regWithEnable_5bit;

architecture Behavioral of regWithEnable_5bit is
	signal R: std_logic_vector(4 downto 0);
begin
RegProcess: process(clock)
	begin
	if(clock = '1' and clock'event)then
		if(reset = '1')then
			R <= (others => '0');
		elsif(en = '1')then
			R <= input;
		end if;
	end if;
end process;

output <= R;

end Behavioral;
