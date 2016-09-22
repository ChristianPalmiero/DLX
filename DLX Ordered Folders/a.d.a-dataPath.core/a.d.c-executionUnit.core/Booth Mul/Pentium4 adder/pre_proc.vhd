
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity pre_proc is
	port (a,b: in std_logic;
			p,g: out std_logic
			);
end pre_proc;

architecture Behavioral of pre_proc is

begin

	p<=a xor b;
	g<=a and b;

end Behavioral;

