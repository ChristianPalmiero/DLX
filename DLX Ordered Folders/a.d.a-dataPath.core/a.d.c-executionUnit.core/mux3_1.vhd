library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux3_1 is
	port(
		operand_one : in std_logic_vector(31 downto 0);
		operand_two : in std_logic_vector(31 downto 0);
		operand_three : in std_logic_vector(31 downto 0);
		sel : in std_logic_vector(1 downto 0);
		out_res : out std_logic_vector(31 downto 0)
	);
end mux3_1;

architecture Behavioral of mux3_1 is

begin
	process(operand_one,operand_two,operand_three,sel)
	begin
		 case sel is
	    when "00" =>	out_res <= operand_one;
	    when "01" =>	out_res <= operand_two;
	    when "10" =>	out_res <= operand_three;
	    when others => out_res <= (others => 'Z');
		end case;
	end process;
end Behavioral;

