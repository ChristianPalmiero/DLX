library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity RCA is 
	generic (Nbit: integer:= 4);
		-- DRCAS : 	Time := 0 ns;
	        -- DRCAC : 	Time := 0 ns);
	Port (	A:	in	std_logic_vector(Nbit-1 downto 0);
		B:	in	std_logic_vector(Nbit-1 downto 0);
		Ci:	in	std_logic;
		S:	out	std_logic_vector(Nbit-1 downto 0);
		Co:	out	std_logic);
end RCA; 



architecture BEHAVIORAL of RCA is

signal tmp: std_logic_vector(Nbit downto 0);
begin

  tmp<=(('0'&A) + B + Ci);--after DRCAS;
  s<=tmp(Nbit-1 downto 0);
  co<=tmp(Nbit);


end BEHAVIORAL;

configuration CFG_RCA_BEHAVIORAL of RCA is
  for BEHAVIORAL 
  end for;
end CFG_RCA_BEHAVIORAL;
