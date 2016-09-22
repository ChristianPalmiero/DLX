library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extensionModule is
	port(
		i : in std_logic_vector(15 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end extensionModule;

architecture Behavioral of extensionModule is

begin
	o <= (31 downto 16 => i(15))& i;
end Behavioral;