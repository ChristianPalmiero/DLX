library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_signed.ALL;

entity comparator is
	port(	A: IN std_logic_vector(31 downto 0);
			B: IN std_logic_vector(31 downto 0);
			Sel: IN std_logic_vector(2 downto 0);
			O: out std_logic_vector(31 downto 0)
			);
end comparator;

architecture Behavioral of comparator is
begin 
	process(A,B,Sel)
	begin 
			-- 000 -> equal
			-- 001 -> not equal
			-- 010 -> greater
			-- 011 -> greater equal
			-- 100 -> less
			-- 101 -> less equal
		 case sel is
			 when "000" =>	
				if (A=B) then
					o <= (0 => '1', others=>'0');
				else
					o <= (others=>'0');
				end if;
			 when "001" =>	
				if (A=B) then
					o <= (others=>'0');
				else
					o <= (0 => '1', others=>'0');
				end if;
			 when "010" =>	
				if (A>B) then
					o <= (0 => '1', others=>'0');
				else
					o <= (others=>'0');
				end if;
			 when "011" =>	
				if (A>=B) then
					o <= (0 => '1', others=>'0');
				else
					o <= (others=>'0');
				end if;
			 when "100" => 
				if (A<B) then
					o <= (0 => '1', others=>'0');
				else
					o <= (others=>'0');
				end if;
			 when "101" => 
				if (A<=B) then
					o <= (0 => '1', others=>'0');
				else
					o <= (others=>'0');
				end if;
			 when others => 
				o <= (others=>'0');
		 end case;
	end process;
end Behavioral;