library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity hazardUnit is
	port(
		--Input--
		RS_address : in std_logic_vector(4 downto 0);
		RT_address : in std_logic_vector(4 downto 0);
		--RT address of the instruction in exe stage
		RT_address_ID_EX : in std_logic_vector(4 downto 0);
		--Tell me if the instruction in the exe stage will read from Memory (ex: load)
		MemRead_ID_EX : in std_logic;
		multi_cycle_operation : in std_logic;
		
		--Output--
		--This signal is used as enable for pc and all the register in the IF/ID stage
		--If an hazard is detected, this signal will prevent pc and all the other registers to update their values
		--We are introducing a stall in the pipeline
		enable_signal : out std_logic;
		--this signal controls a mux that inject a nop in the ID/EXE stage
		sel1 : out std_logic
	);
		
end hazardUnit;

architecture Behavioral of hazardUnit is
	
begin
	c_state : process(RS_address,RT_address,RT_address_ID_EX,MemRead_ID_EX, multi_cycle_operation)
	begin
		--HAZARD
		if((MemRead_ID_EX = '1' and ((RT_address_ID_EX = RS_address)or (RT_address_ID_EX = RT_address))) or multi_cycle_operation = '1')then	
			--disabling pc and the other registers
			enable_signal <= '0';
			--introducing a nop
			sel1 <= '0';		
		else
			--pc and other registers NOT disabled
			enable_signal <= '1';
			--not introducing nop
			sel1 <= '1';
		end if;
	end process;

end Behavioral;