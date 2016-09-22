
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sum_gen is
generic (nbit: integer:= 4; xbit: integer:= 32 );
port (	c: in std_logic_vector (xbit/nbit-1 downto 0);
	a,b: in std_logic_vector (xbit-1 downto 0);
	s: out std_logic_vector (xbit-1 downto 0 ));
end sum_gen;




architecture structural of sum_gen is


component carry_select is
generic (nbit: integer:= 4 );
port (	c: in std_logic;
	a,b: in std_logic_vector (nbit-1 downto 0);
	s: out std_logic_vector (nbit-1 downto 0) );
end component;

begin

 
  carry_select_gen: for i in 0 to xbit/nbit-1 generate 
    carry_selecti : carry_select   generic map (nbit=>nbit) 
	  
	  port map (c(i), a(((i+1)*nbit)-1 downto i*nbit), b(((i+1)*nbit)-1 downto i*nbit), s(((i+1)*nbit)-1 downto i*nbit)); 
  end generate;

end structural;

