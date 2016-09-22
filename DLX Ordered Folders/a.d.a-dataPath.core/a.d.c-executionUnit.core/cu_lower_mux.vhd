library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cu_lower_mux is
	port(
			EX_MEM_write : in std_logic;
			MEM_WB_write : in std_logic;
			EX_MEM_Rd : in std_logic_vector(4 downto 0);
			ID_EX_Rt : in std_logic_vector(4 downto 0);
			MEM_WB_Rd : in std_logic_vector(4 downto 0);
			
			sel_lower_mux : out std_logic_vector(1 downto 0)
	);	
end cu_lower_mux;

architecture Behavioral of cu_lower_mux is

begin
	process(EX_MEM_write,EX_MEM_Rd,ID_EX_Rt,MEM_WB_write,MEM_WB_Rd)
	begin
		if((EX_MEM_write = '1') and (EX_MEM_Rd = ID_EX_Rt))then
			-- TAKE FORWARD EXE
			sel_lower_mux <= "01";
		elsif ((MEM_WB_write = '1') and (MEM_WB_Rd = ID_EX_Rt) and ((EX_MEM_Rd /= ID_EX_Rt) or (EX_MEM_write = '0'))) then
			-- TAKE FORWARD MEM
			sel_lower_mux <= "10";
		else 
			-- TAKE OPERAND B
			sel_lower_mux <= "00";
		end if;
	end process;
end Behavioral;

