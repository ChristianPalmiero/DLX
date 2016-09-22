
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity G_block is
port ( P_SX, G_SX,C_DX: IN std_logic; 
	G_OUT: OUT std_logic);
end G_block;

architecture Behavioral of G_block is

begin
		G_OUT<=g_sx or (p_sx and c_DX);

end Behavioral;

