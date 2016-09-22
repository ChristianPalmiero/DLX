library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PG is
	port ( P_SX, P_DX, G_SX,C_DX: IN std_logic;
	P_OUT, G_OUT: OUT std_logic);
end PG;

architecture Behavioral of PG is

begin
	P_OUT<=P_SX and P_DX;
	G_OUT<=g_sx or (p_sx and c_dx);

end Behavioral;

