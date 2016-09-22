----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux5x1 is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		c : in std_logic_vector(31 downto 0);
		d : in std_logic_vector(31 downto 0);
		e : in std_logic_vector(31 downto 0);
		enable : in std_logic;
		sel : in std_logic_vector(2 downto 0);
		out_res : out std_logic_vector(31 downto 0)
	);
end mux5x1;

architecture Behavioral of mux5x1 is

begin
process(a,b,c,d,e,sel,enable)
	begin
	if (enable = '1')then
       case sel is
	    when "000" =>	out_res <= a;
	    when "001" =>	out_res <= b;
	    when "010" =>	out_res <= c;
	    when "011" =>	out_res <= d;
		 when "100" => out_res <= e;
	    when others => out_res <= (others => 'Z');
	end case;
	else out_res <= (others => 'Z');
	end if;
   end process;

end Behavioral;