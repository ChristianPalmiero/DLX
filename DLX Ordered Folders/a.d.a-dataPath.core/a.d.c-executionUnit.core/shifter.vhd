library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
	generic (
		NBIT: integer := 32
	);
	port (
		left_right: in std_logic;	-- LEFT/RIGHT
		logic_Arith : in std_logic;	-- LOGIC/ARITHMETIC
		shift_rot : in std_logic;	-- SHIFT/ROTATE
		a : in std_logic_vector(NBIT-1 downto 0);
		b : in std_logic_vector(NBIT-1 downto 0);
		o : out std_logic_vector(NBIT-1 downto 0)
	);
end Shifter;


architecture beh of Shifter is

	constant B_SIZE : integer := 5;
	
begin
	P0: process (a, b, left_right, logic_arith, shift_rot) is
	begin
		if shift_rot = '1' then

			if left_right = '1' then
				o <= to_StdLogicVector((to_bitvector(a)) ror (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
			else
				o <= to_StdLogicVector((to_bitvector(a)) rol (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
			end if;
		else

			if left_right = '1' then

				if logic_arith = '1' then
					o <= to_StdLogicVector((to_bitvector(a)) sra (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
				else
					o <= to_StdLogicVector((to_bitvector(a)) srl (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
				end if;				
			else

				if logic_arith = '1' then
					o <= to_StdLogicVector((to_bitvector(a)) sla (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
				else
					o <= to_StdLogicVector((to_bitvector(a)) sll (to_integer(unsigned(b(B_SIZE-1 downto 0)))));
				end if;
			end if;
		end if;
end process;
end Beh;