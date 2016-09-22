
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux5_1 is
	generic (N_bit : natural := 32);
	port(
		in1 : in std_logic_vector(2*N_bit-1 downto 0);
		in2 : in std_logic_vector(2*N_bit-1 downto 0);
		in3 : in std_logic_vector(2*N_bit-1 downto 0);
		in4 : in std_logic_vector(2*N_bit-1 downto 0);
		in5 : in std_logic_vector(2*N_bit-1 downto 0);
		s : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(2*N_bit-1 downto 0)
	);
end mux5_1;

architecture Behavioral of mux5_1 is


begin
	process(s,in1,in2,in3,in4,in5) is
	begin
	case s is 
	when "000" => output <=in1;
	when "001" => output <=in2;
	when "010" => output <=in2;
	when "011" => output <=in4;
	when "100" => output <=in5;
	when "101" => output <=in3;
	when "110" => output <=in3;
	when "111" => output <=in1;
	when others =>output <=(others=>'Z');
	end case;
	end process;
	 

end Behavioral;
