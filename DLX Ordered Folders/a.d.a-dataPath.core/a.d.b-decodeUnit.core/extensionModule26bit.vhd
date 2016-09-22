library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extensionModule26bit is
	port(
		i : in std_logic_vector(25 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end extensionModule26bit;

architecture Behavioral of extensionModule26bit is

begin
	o <= (31 downto 26 => i(25))& i;
end Behavioral;