library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX21_GENERIC is
	Generic (NBIT: integer:= 16
		);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		S:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0)
		);
end MUX21_GENERIC;




architecture BEHAVIORAL of MUX21_GENERIC is

begin
	Y <= A when S='0' else B;

end BEHAVIORAL;





configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;


