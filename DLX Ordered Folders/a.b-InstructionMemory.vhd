----------------------------------------------------------------------------------
-- Additional Comments: asynchronous ROM memory with active high reset
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
	port (
    --clock   : in  std_logic;
    --we      : in  std_logic;
	 Reset: in std_logic;
    address : in  std_logic_vector(31 downto 0);
    --datain  : in  std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
end InstructionMemory;

architecture Behavioral of InstructionMemory is

	type rom_type is array (0 to 17) of std_logic_vector(31 downto 0);
	signal rom : rom_type := 
									(
"00100000000000010000000000000100","10001100001000100000000000000100","10101100010000010000000000010100","10001100010001010000000000010100","00100000101001000000000000001111","00100000000001110000000000000000","00001011111111111111111111100100","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000",
"01010100000000000000000000000000","01010100000000000000000000000000","01010100000000000000000000000000"
									 );
	
begin

--	RamProc: process(clock) is
--	begin
--		if (clock = '1' and clock'event) then
--			if we = '1' then
--				ram(to_integer(unsigned(address))) <= datain;
--			end if;
--		end if;
--	end process RamProc;

--	process(Reset) is
--	begin
--		if (Reset='1') then
--			rom <= (others =>(others =>'0'));
--		end if;
--	end process;
	
	dataout <= rom(to_integer(unsigned(address)));

end Behavioral;
