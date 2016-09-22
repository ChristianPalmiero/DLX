library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cu_exe is
	port(
		reset : in std_logic;
		func : in std_logic_vector(10 downto 0);
		busy_div : in std_logic;
		
		--if this signal asserted the hazard unit introduce a nop
		multi_cycle_operation : out std_logic;
		
		--mux5X1
		-- 000 = ADDER
		-- 001 = T2 LOGIC
		-- 010 = MUL
		-- 011 = SHIFTER
		-- 100 = COMPARATOR
		enable : out std_logic;
		sel_signal_5X1 : out std_logic_vector(2 downto 0);
		
		--mux2X1
		-- 1 = DIV
		-- 0 = OTHER OPERATIONS
		sel_signal_2X1 : out std_logic;
		
		--div
		start_div : out std_logic;
		
		--t2
		-- 1000 -> and
		-- 0111 -> nand
		-- 1110 -> or
		-- 0001 -> nor
		-- 0110 -> xor
		-- 1001 -> xnor
		cmd_t2 : out std_logic_vector(3 downto 0); 
		
		--add/sub
		carry_in : out std_logic;
		
		--shifter
		left_right : out std_logic;
		logic_Arith : out std_logic;
		shift_rot : out std_logic;
		
		--comparator
		-- 000 -> equal
		-- 001 -> not equal
		-- 010 -> greater
		-- 011 -> greater equal
		-- 100 -> less
		-- 101 -> less equal
		sel_comparator : out std_logic_vector(2 downto 0)
	);
		
end cu_exe;

architecture Behavioral of cu_exe is

begin

	s_proc : process(reset,func)
	begin
		
		-- RESET
		if (reset = '1') then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '0';
			sel_signal_5X1 <= "000";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';
			--comparator
			sel_comparator <= "111";
		
		-- ADD
		elsif (func = "00000000001") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "000";
			--mux2X1
			sel_signal_2X1 <= '0';			
			-- multi cycle operation
			multi_cycle_operation <= '0';
			--comparator
			sel_comparator <= "111";				
		
		-- SUB
		elsif (func = "00000000010") then
			--add/sub
			carry_in <= '1';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "000";
			--mux2X1
			sel_signal_2X1 <= '0';		
			-- multi cycle operation
			multi_cycle_operation <= '0';	
			--comparator
			sel_comparator <= "111";

		-- AND
		elsif (func = "00000000011") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "1000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "001";
			--mux2X1
			sel_signal_2X1 <= '0';	
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- MULT
		elsif (func = "00000000100") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "010";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- DIV
		elsif (func = "00000000101") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			--if the division has already started, keep working; otherwise, let the division start
			if (busy_div = '1') then
				start_div <= '0';
			else
				start_div <= '1';
			end if;
			--mux4x1
			enable <= '0';
			sel_signal_5X1 <= "000";
			--mux2X1
			sel_signal_2X1 <= '1';
			-- multi cycle operation
			multi_cycle_operation <= '1';		
			--comparator
			sel_comparator <= "111";

		-- OR
		elsif (func = "00000000110") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "1110";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "001";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';			
			--comparator
			sel_comparator <= "111";

		-- XOR
		elsif (func = "00000000111") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0110";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "001";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- EQUAL
		elsif (func = "00000001000") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "000";			
		
		-- NOT EQUAL
		elsif (func = "00000001001") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "001";				
		
		-- GREATER
		elsif (func = "00000001010") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "010";				
		
		-- GREATER EQUAL
		elsif (func = "00000001011") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "011";	

		-- LESS
		elsif (func = "00000001100") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "100";	

		-- LESS EQUAL
		elsif (func = "00000001101") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "100";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "101";	

		-- LOGIC LEFT SHIFT
		elsif (func = "00000001110") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- LOGIC RIGHT SHIFT
		elsif (func = "00000001111") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '1';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- ARITH LEFT SHIFT
		elsif (func = "00000010000") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '1';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- ARITH RIGHT SHIFT
		elsif (func = "00000010001") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '1';
			logic_Arith <= '1';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";			
		
		-- ROTATE LEFT 
		elsif (func = "00000010010") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '1';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";

		-- ROTATE RIGHT 
		elsif (func = "00000010011") then
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '1';
			logic_Arith <= '0';
			shift_rot <= '1';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '1';
			sel_signal_5X1 <= "011";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';		
			--comparator
			sel_comparator <= "111";	

		else
			--add/sub
			carry_in <= '0';
			--shifter
			left_right <= '0';
			logic_Arith <= '0';
			shift_rot <= '0';
			--t2
			cmd_t2 <= "0000";
			--div
			start_div <= '0';
			--mux4x1
			enable <= '0';
			sel_signal_5X1 <= "000";
			--mux2X1
			sel_signal_2X1 <= '0';
			-- multi cycle operation
			multi_cycle_operation <= '0';
			--comparator
			sel_comparator <= "111";
		
		end if;
	end process;
	
end Behavioral;
