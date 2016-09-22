
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity gen_circuit is

	generic (N_bit : natural := 32);
	port(
			operand : in std_logic_vector(N_bit-1 downto 0);
			shift : in integer;
			out1: out std_logic_vector(2*N_bit-1 downto 0);
			out2 : out std_logic_vector(2*N_bit-1 downto 0);
			out3 : out std_logic_vector(2*N_bit-1 downto 0);
			out4 : out std_logic_vector(2*N_bit-1 downto 0);
			out5 : out std_logic_vector(2*N_bit-1 downto 0)
	);
	
end gen_circuit;

architecture Behavioral of gen_circuit is

subtype dataword is std_logic_vector(2*N_bit-1 downto 0);


constant upper_bound : natural := N_bit-2;

function vrol (d : dataword; s : integer)
		return dataword is
	variable n: integer;
	variable tpmd : dataword;
	begin
		n := s; 
		tpmd := d;
		l2 : for i in 1 to upper_bound loop
					tpmd := tpmd (2*N_bit-2 downto 0) & '0';
				exit l2 when i >= n;
		end loop;
		return tpmd;
	end vrol;
	
begin

	process(operand,shift)
	
		variable temp : std_logic_vector(2*N_bit-1 downto 0);
		variable not_temp : std_logic_vector(2*N_bit-1 downto 0);
		variable extension : std_logic_vector(N_bit-1 downto 0);
		
	begin
	
		
		extension := (others => operand(N_bit-1));
		temp := extension & operand; 
		
		
		out1<= (others => '0');
		
		
		if(shift /= 0) then
			temp := vrol(temp,shift);
		end if;
		out2 <= temp;
		
		not_temp := not temp;
		out3 <= std_logic_vector(unsigned(not_temp) + 1);

		
		out4 <= temp(2*N_bit-2 downto 0)&'0';
		
		not_temp := std_logic_vector(unsigned(not_temp) + 1);
		out5 <= not_temp(2*N_bit-2 downto 0)&'0';
		
	end process;

end Behavioral;

