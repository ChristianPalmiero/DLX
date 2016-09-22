library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;


entity Adder is
	 port ( 
		A: in std_logic_vector(31 downto 0); 
		B: in std_logic_vector(31 downto 0); 
		CI: in std_logic; 
		O: out std_logic_vector(31 downto 0); 
		CO: out std_logic 
	);
end Adder;

architecture Behavioral of Adder is

begin
	process(A,B,CI)
		 variable sum: integer;
		 variable sum_vector: std_logic_vector(32 downto 0); 
	begin
		sum := conv_integer(A) + conv_integer(B) + conv_integer(CI);
		sum_vector := conv_std_logic_vector(sum, 33);
		O <= sum_vector(31 downto 0);
		CO <= sum_vector(32);
	end process;

end Behavioral;

