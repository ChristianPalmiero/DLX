library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionRegister is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end InstructionRegister;

architecture Behavioral of InstructionRegister is
	signal R : std_logic_vector(31 downto 0);

begin
	process (clock)
	begin
		if(clock = '1' and clock'event)then
			if(reset = '1')then
				R <= "01010100000000000000000000000000";		-- NOP
			elsif(load = '1')then
				R <= i;
			end if;
		end if;
	end process;

	o <= R;
	
end Behavioral;

