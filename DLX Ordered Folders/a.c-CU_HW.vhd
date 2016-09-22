library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity CU_HW is
	generic (
		MICROCODE_MEM_SIZE : integer := 2**6-1; --Microcode Memory Size
		OPCODE_SIZE : integer := 6; --Opcode Size
		FUNC_SIZE : integer := 11; --Func Size
		CW_LENGTH : integer := 18 --It does not take into account the FUNC field for the EXE_CU, which is computed in a different way
	);
	port (
		clock : in std_logic; --Clock
		reset : in std_logic; --Active high reset
		stall : in std_logic; --From Hazard Unit (STALL IF stall='0')
		jump  : in std_logic; --From comparator output, used for branches
		opcode : in std_logic_vector(OPCODE_SIZE-1 downto 0); --Opcode instruction
		func : in std_logic_vector(FUNC_SIZE-1 downto 0); --Type of instruction

		--Output control signals
		
		--DECODE
		en1 : out std_logic; --Decode registers enable
		en2 : out std_logic; --PortA read enable
		en3 : out std_logic; --PortB read enable
		sel_ext : out std_logic; --Mux (IMM26/IMM16) selection signal
		
		--EXECUTION
		hazard_condition : out std_logic; --Hazard condition (1 if the istruction is a LOAD)
		sel1 : out std_logic; --Mux (PC/A) selection signal
		sel2 : out std_logic; --Mux (IMM/B) selection signal
		sel3 : out std_logic; --Mux (RT i-type/RD r-type) selection signal
		en5 : out std_logic;  --Exe registers enable
		exe_func : out std_logic_vector(FUNC_SIZE-1 downto 0); --FUNC field for the EXE_CU
		sel0 : out std_logic; --Mux (PC+1/NPC) selection signal
		
		--MEMORY
		ex_mem_write : out std_logic; --1 if the instruction writes on RF
		en6 : out std_logic; --Memory registers enable
		write_data_mem : out std_logic; --Memory write enable
		read_data_mem : out std_logic; --Memory read enable
		
		--WRITEBACK
		en4 : out std_logic;  --PortA write enable
		en7 : out std_logic;	 --Writeback register enable
		sel4 : out std_logic;  --Mux (ALU/MEM) selection signal
		mem_wb_write : out std_logic --1 if the instruction writes on RF
	);
end CU_HW;

architecture CU_HW_beh of CU_HW is
	
	type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE-1) of std_logic_vector(CW_LENGTH-1 downto 0);
	
	signal cw_mem : mem_array := (	
					"111101111011001101", -- R-Type
					"111101111011001101", -- MULT/DIV
					"100000001101000100", -- J
					"100000001101000100", -- JAL
					"111101101001000100", -- BEQZ
					"111101101001000100", -- BNEZ
					"000000000000000000", 
					"000000000000000000", 
					"110101001011001101", -- ADDI
					"000000000000000000", 
					"110101001011001101", -- SUBI
					"000000000000000000", 
					"110101001011001101", -- ANDI
					"110101001011001101", -- ORI
					"110101001011001101", -- XORI
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"110101001011001101", -- SLLI					
					"000000000000000000", -- NOP
					"110101001011001101", -- SRLI
					"000000000000000000", 
					"110101001011001101", -- SEQI
					"110101001011001101", -- SNEI
					"110101001011001101", -- SLTI
					"110101001011001101", -- SGTI
					"110101001011001101", -- SLEI
					"110101001011001101", -- SGEI
					"000000000000000000", 					
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"110111001011011111", -- LW
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 					
					"000000000000000000", 
					"000000000000000000", 
					"111101001001100010", -- SW
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 
					"000000000000000000", 			
					"000000000000000000", 					
					"000000000000000000");
					
					
	signal IR_opcode : std_logic_vector(OPCODE_SIZE-1 downto 0); --Register for latch opcode part
	signal IR_opcode_two : std_logic_vector(OPCODE_SIZE-1 downto 0);
	signal IR_func : std_logic_vector(FUNC_SIZE-1 downto 0); --Register for latch func part
	signal cw  : std_logic_vector(CW_LENGTH-1 downto 0); --Full control word
	signal exe_control_unit : std_logic_vector(FUNC_SIZE-1 downto 0); --FUNC field for the EXE_CU computed by the process
	
	signal cw_temp   : std_logic_vector(CW_LENGTH-1 downto 0);
	signal cw_jump  : std_logic_vector(CW_LENGTH-1 downto 0);

	--Control word pipeline registers
	signal cw2 : std_logic_vector(CW_LENGTH-5 downto 0);  	--ID/EX
	signal cw2_real : std_logic_vector(CW_LENGTH-5 downto 0);
	signal cw_br : std_logic_vector(CW_LENGTH-5 downto 0);
	signal cw3 : std_logic_vector(CW_LENGTH-11 downto 0);  	--EX/MEM
	signal cw4 : std_logic_vector(CW_LENGTH-15 downto 0); 	--MEM/WB

	--Registers for pipelining the FUNC std_logic_vector for the EXE_CU
	signal FuncCode1 : std_logic_vector(FUNC_SIZE-1 downto 0);
	signal FuncCode2 : std_logic_vector(FUNC_SIZE-1 downto 0);
	
	--Branch FSM states
	type TYPE_STATE is (S0, S1, S2, S3, S4, S5);
	signal CURRENT_STATE : TYPE_STATE;
	signal NEXT_STATE : TYPE_STATE;
	signal CURRENT_STATE2 : TYPE_STATE;
	signal NEXT_STATE2 : TYPE_STATE;	

begin
	
	--JUMP FSM
	P_OPC : process (CLOCK, RESET)
	begin
		if (RESET='1') then
			CURRENT_STATE <= S0 ;
		elsif(CLOCK ='1' and CLOCK'EVENT) then
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process;
	
	P_NEXT_STATE : process (CURRENT_STATE, IR_OPCODE, JUMP)
	begin
		case CURRENT_STATE is
			when S0 => 
				if(IR_OPCODE="000010" or IR_OPCODE="000011") then
					NEXT_STATE <= S1;
				else
					NEXT_STATE <= S0;
				end if;
			when S1 => NEXT_STATE <= S2;
			when S2 => NEXT_STATE <= S0;
			when others => NEXT_STATE <= S0;
		end case;
	end process;
	
	P_OUTPUT : process (CURRENT_STATE)
	begin
		case CURRENT_STATE is
			when S0 => cw_jump <= (others => '1');
			when S1 => cw_jump <= (others => '0');
			when S2 => cw_jump <= (others => '0');
			when others => cw_jump <= (others => '1');
		end case;
	end process;
	
	--BRANCH FSM
	B_OPC : process (CLOCK, RESET)
	begin
		if (RESET='1') then
			CURRENT_STATE2 <= S3 ;
		elsif(CLOCK ='1' and CLOCK'EVENT) then
			CURRENT_STATE2 <= NEXT_STATE2;
		end if;
	end process;
	
	B_NEXT_STATE : process (CURRENT_STATE2, IR_OPCODE_TWO, JUMP)
	begin
		case CURRENT_STATE2 is
			when S3 => 
				if((IR_OPCODE_TWO="000100" or IR_OPCODE_TWO="000101") and JUMP='1') then
					NEXT_STATE2 <= S4;
				else
					NEXT_STATE2 <= S3;
				end if;
			when S4 => NEXT_STATE2 <= S5;
			when S5 => NEXT_STATE2 <= S3;
			when others => NEXT_STATE2 <= S3;
		end case;
	end process;
	
	B_OUTPUT : process (CURRENT_STATE2)
	begin
		case CURRENT_STATE2 is
			when S3 => cw_br <= (others => '1');
			when S4 => cw_br <= (others => '0');
			when S5 => cw_br <= (others => '0');
			when others => cw_br <= (others => '1');
		end case;
	end process;
			
	--HAZARD UNIT
	STALL_P : process(IR_opcode,stall)
	begin
		--STALL
		if (stall='1') then
			cw_temp <= cw_mem(conv_integer(IR_opcode));
		else
			cw_temp <= (others=>'0');
		end if;
	end process;
	
	--CONTROL WORD
	IR_opcode <= opcode;
	IR_func <= func;
	cw <= cw_temp and cw_jump;
	cw2_real <= cw2 and cw_br;
	
	--DECODE
	en1 <= cw (CW_LENGTH-1);
	en2 <= cw (CW_LENGTH-2);
	en3 <= cw (CW_LENGTH-3);
	sel_ext <= cw (CW_LENGTH-4);

	--EXECUTION
	hazard_condition <= cw2_real (CW_LENGTH-5);
	sel1 <= cw2_real (CW_LENGTH-6);
	sel2 <= cw2_real (CW_LENGTH-7);
	sel3 <= cw2_real (CW_LENGTH-8);
	en5  <= cw2_real (CW_LENGTH-9);
	process(jump,cw2_real,IR_OPCODE_TWO)
	begin
		if((IR_OPCODE_TWO="000100" or IR_OPCODE_TWO="000101") and JUMP='1') then
			sel0<='1';
		else
			sel0<=cw2_real (CW_LENGTH-10);
		end if;
	end process;
	--update FUNC std_logic_vector for EXE_CU
	exe_func <= FuncCode2;
	
	--MEMORY
	ex_mem_write <= cw3 (CW_LENGTH-11);
	en6 <= cw3 (CW_LENGTH-12);
	write_data_mem <= cw3 (CW_LENGTH-13);
	read_data_mem <= cw3 (CW_LENGTH-14);
	
	--WRITE BACK
	en4 <= cw4 (CW_LENGTH-15);
	en7 <= cw4 (CW_LENGTH-16);
	sel4 <= cw4 (CW_LENGTH-17);
	mem_wb_write <= cw4 (CW_LENGTH-18);
	
	--process that control the cw throught the pipeline
	CW_PIPE : process(clock)
	begin
		if (clock = '1' and clock'event) then
			if (reset = '1') then
				cw2 <= (others => '0');
				cw3 <= (others => '0');
				cw4 <= (others => '0');
				FuncCode2 <= (others => '0');
				IR_OPCODE_TWO <= (others => '0');
			else
				cw2 <= cw (CW_LENGTH-5 downto 0);
				cw3 <= cw2_real (CW_LENGTH-11 downto 0);
				cw4 <= cw3 (CW_LENGTH-15 downto 0);
				FuncCode2 <= FuncCode1;
				IR_OPCODE_TWO <= IR_OPCODE;
			end if;
		end if;
	end process CW_PIPE;
	
	--this process generate the FUNC std_logic_vector for EXE_CU updating FuncCode1
	--if the instruction is a R-type we obtain FuncCode1 observing the func field
	--for the other operation we observe the opcode field
	FUNC_PROCESS : process(IR_opcode,IR_func)
	variable IRopcode : std_logic_vector(5 downto 0);
	variable IRfunc : std_logic_vector(10 downto 0);
	begin
		IRopcode:= IR_opcode;
		IRfunc := IR_func;
		case IRopcode is
			when "000000" => --R-type instruction
				case IRfunc is
					when "00000100000" => FuncCode1 <= "00000000001";	--ADD
					when "00000100100" => FuncCode1 <= "00000000011";	--AND
					when "00000100101" => FuncCode1 <= "00000000110";	--OR
					when "00000101101" => FuncCode1 <= "00000001011";	--SGE
					when "00000101100" => FuncCode1 <= "00000001101";	--SLE
					when "00000000100" => FuncCode1 <= "00000001110";	--SLL
					when "00000101001" => FuncCode1 <= "00000001001";	--SNE
					when "00000000110" => FuncCode1 <= "00000010001";	--SRL
					when "00000100010" => FuncCode1 <= "00000000010";	--SUB
					when "00000100110" => FuncCode1 <= "00000000111";	--XOR
					when "00000101000" => FuncCode1 <= "00000001000";	--SEQ
					when "00000101011" => FuncCode1 <= "00000001010";	--SGT
					when "00000101010" => FuncCode1 <= "00000001100";	--SLT
					when others => FuncCode1 <= "00000000000";
				end case;
			when "000001" => --MULT/DIV
				case IRfunc is
					when "00000001110" => FuncCode1 <= "00000000100";	--MULT
					when "00000001111" => FuncCode1 <= "00000000101";	--DIV		
					when others => FuncCode1 <= "00000000000";
				end case;
			when "001000" => --ADDI
				FuncCode1 <= "00000000001";
			when "001100" => --ANDI
				FuncCode1 <= "00000000011";
			when "010101" => --NOP
				FuncCode1 <= "00000000000";
			when "001101" => --ORI
				FuncCode1 <= "00000000110";
			when "011101" => --SGEI
				FuncCode1 <= "00000001011";
			when "011100" => --SLEI
				FuncCode1 <= "00000001101";
			when "010100" => --SLLI
				FuncCode1 <= "00000001110";
			when "011001" => --SNEI
				FuncCode1 <= "00000001001";
			when "010110" => --SRLI
				FuncCode1 <= "00000010001";
			when "001010" => --SUBI
				FuncCode1 <= "00000000010";				
			when "001110" => --XORI
				FuncCode1 <= "00000000111";
			when "100011" => --LW
				FuncCode1 <= "00000000001";
			when "101011" => --SW
				FuncCode1 <= "00000000001";
			when "011000" => --SEQI
				FuncCode1 <= "00000001000";
			when "011011" => --SGTI
				FuncCode1 <= "00000001010";
			when "011010" => --SLTI
				FuncCode1 <= "00000001100";
			when "000100" => --BEQZ
				FuncCode1 <= "00000001000";
			when "000101" => --BNEZ
				FuncCode1 <= "00000001001";				
			when others =>
				FuncCode1 <= "00000000000";
		end case;
	end process;
	
end CU_HW_beh;
