----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    	15:58:22 05/21/2016 
-- Design Name: 
-- Module Name:    	nandWithEn - Behavioral 
-- Project Name:		DLX 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nandWithEn is
	generic (
		data_size : integer :=32
	);
	port(
		operand_a : in std_logic_vector(data_size-1 downto 0);
		operand_b : in std_logic_vector(data_size-1 downto 0);
		enable : in std_logic;
		output : out std_logic_vector(data_size-1 downto 0)
	);
end nandWithEn;

architecture Behavioral of nandWithEn is

begin
	process(operand_a,operand_b,enable)
	variable tmp : std_logic;
	begin
		if(enable = '1')then
			for I in data_size-1 downto 0 loop
				tmp := operand_a(I);
				tmp := tmp nand operand_b(I);
				output(I) <= tmp;
			end loop;
		else output <= (others => '1');
		end if;
	end process;
end Behavioral;

