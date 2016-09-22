library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dataPath is

	port(
		------***INPUT***------
		---COMMAND SIGNAL---
		sel0 : in std_logic;
		sel1 : in std_logic;
		sel2 : in std_logic;
		sel3 : in std_logic;
		sel4 : in std_logic;
		sel_ext : in std_logic;
		--decode registers enable
		en1 : in std_logic;
		--port a rf enable
		en2 : in std_logic;
		--port b rf enable
		en3 : in std_logic;
		--port w rf enble
		en4 : in std_logic;
		--enable exe registers
		en5 : in std_logic;
		--enable for mem registers
		en6 : in std_logic;
		--enable for wb register
		en7 : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		hazard_condition : in std_logic;
		func : in std_logic_vector(10 downto 0);
		EX_MEM_write : in std_logic;
		MEM_WB_write : in std_logic;
		from_instruction_memory : in std_logic_vector(31 downto 0);
		datain : in std_logic_vector(31 downto 0);
		
		------***OUTPUT***------
		hazard_detected : out std_logic;
		jump : out std_logic;
		pc_to_im : out std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0);
		address_data_memory : out std_logic_vector(31 downto 0);
		dataout : out std_logic_vector(31 downto 0);
		debug : out std_logic_vector(31 downto 0)
	);
		
end dataPath;

architecture Structural of dataPath is
	
	component memoryUnit 
	port(
		clock : in std_logic;
		reset : in std_logic;
		enable : in std_logic;
		alu_result : in std_logic_vector(31 downto 0);
		data_from_memory : in std_logic_vector(31 downto 0);
		EX_MEM_Rd : in std_logic_vector(4 downto 0);
		address_memory : out std_logic_vector(31 downto 0);
		data_op1 : out std_logic_vector(31 downto 0);
		data_op2 : out std_logic_vector(31 downto 0);
		MEM_WB_Rd : out std_logic_vector(4 downto 0)
	);
	end component;
	
	component writeBacKUnit 
	port(
		clock, reset, enable, sel_4 : in std_logic;
		data_from_memory : in std_logic_vector(31 downto 0);
		data_from_alu : in std_logic_vector(31 downto 0);
		write_back_value : out std_logic_vector(31 downto 0);
		debug : out std_logic_vector(31 downto 0)
	);
	end component;
	

	component fetchUnit 
	port(
		sel0 : in std_logic;
		en0 : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		fromInstructionMemory : in std_logic_vector(31 downto 0);
		next_PC : in std_logic_vector(31 downto 0);
		PcToInstructionMemory : out std_logic_vector(31 downto 0);
		InstructionToDecode : out std_logic_vector(31 downto 0);
		pcToDecode : out std_logic_vector(31 downto 0)
	);
	
	end component;
	
	
	component decodeUnit 
	port(
		clock,reset : in std_logic;
		en1 : in std_logic;
		read_enable_portA : in std_logic;
		read_enable_portB : in std_logic;
		write_enable_portW : in std_logic;
		instructionWord : in std_logic_vector(31 downto 0);
		ID_EX_MemRead : in std_logic;
		ID_EX_RT_Address : in std_logic_vector(4 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		writeAddress : in std_logic_vector(4 downto 0);
		pc : in std_logic_vector(31 downto 0);
		sel_ext : in std_logic;
		multi_cycle_operation : in std_logic;
		enable_signal_PC_IF_ID : out std_logic;
		selectNop : out std_logic;
		outRT : out std_logic_vector(4 downto 0);
		outRD : out std_logic_vector(4 downto 0);
		outRS : out std_logic_vector(4 downto 0);
		outIMM : out std_logic_vector(31 downto 0);
		outPC : out std_logic_vector(31 downto 0);
		outA : out std_logic_vector(31 downto 0);
		outB : out std_logic_vector(31 downto 0)
	);
	end component;

	component executionUnit 
	port(
		clock : in std_logic;
		reset : in std_logic;
		operand_a : in std_logic_vector(31 downto 0);
		operand_b : in std_logic_vector(31 downto 0);
		operand_imm : in std_logic_vector(31 downto 0);
		operand_pc : in std_logic_vector(31 downto 0);
		forward_exe : in std_logic_vector(31 downto 0);
		forward_mem : in std_logic_vector(31 downto 0);
		EX_MEM_write : in std_logic;
		MEM_WB_write : in std_logic;
		MEM_WB_rd : in std_logic_vector(4 downto 0);
		ID_EX_Rd : in std_logic_vector(4 downto 0);
		ID_EX_Rs : in std_logic_vector(4 downto 0);
		ID_EX_Rt : in std_logic_vector(4 downto 0);
		enable : in std_logic;
		sel_1 : in std_logic;
		sel_2 : in std_logic;
		sel_3 : in std_logic;
		func : in std_logic_vector(10 downto 0);
		EX_MEM_rd : inout std_logic_vector(4 downto 0);
		out_res_operand_one : out std_logic_vector(31 downto 0);
		out_res_operand_two : out std_logic_vector(31 downto 0);
		next_pc : out std_logic_vector(31 downto 0);
		jump : out std_logic;
		multi_cycle_operation : out std_logic
	);
		
	end component;


	--NOTICE for now tied to ground
	signal all_zero : std_logic_vector(31 downto 0) := (others => '0');
	signal all_zero_5bit : std_logic_vector(4 downto 0) := (others => '0');
	signal bit_zero : std_logic := '0';
	signal all_zero_11bit : std_logic_vector(10 downto 0) := (others => '0');
	---------------------------------------------------------------------
	
	signal instructionWord_ToDecode : std_logic_vector(31 downto 0);
	signal NPC_to_decode : std_logic_vector(31 downto 0);
	signal disable_fetch_register : std_logic;
	signal operand_A : std_logic_vector(31 downto 0);
	signal operand_B : std_logic_vector(31 downto 0);
	signal operand_IMM : std_logic_vector(31 downto 0);
	signal operand_PC : std_logic_vector(31 downto 0);
	signal ID_EX_Rd : std_logic_vector(4 downto 0);
	signal ID_EX_Rs : std_logic_vector(4 downto 0);
	signal ID_EX_Rt : std_logic_vector(4 downto 0);
	signal multi_cycle_operation : std_logic;
	signal operand_res_alu : std_logic_vector(31 downto 0);
	signal EX_MEM_RD : std_logic_vector(4 downto 0);
	signal next_pc : std_logic_vector(31 downto 0);
	signal MEM_WB_RD : std_logic_vector(4 downto 0);
	signal write_back_op1 : std_logic_vector(31 downto 0);
	signal write_back_op2 : std_logic_vector(31 downto 0);
	signal forward_mem : std_logic_vector(31 downto 0);
	
begin

WB : writeBacKUnit port map(
								clock => clock,
								reset => reset,
								enable => en7,
								sel_4 => sel4,
								data_from_memory => write_back_op1,
								data_from_alu => write_back_op2,
								write_back_value => forward_mem,
								debug => debug
							);
									
MU : memoryUnit port map(
									clock => clock,
									reset => reset,
									enable => en6,
									alu_result => operand_res_alu,
									data_from_memory => datain,
									EX_MEM_Rd => EX_MEM_RD,
									address_memory => address_data_memory,
									data_op1 => write_back_op1,
									data_op2 => write_back_op2,
									MEM_WB_Rd => MEM_WB_RD
								);

EU : executionUnit port map (
									clock => clock,
									reset => reset,
									operand_a => operand_A,
									operand_b => operand_B,
									operand_imm => operand_IMM,
									operand_pc => operand_PC,
									forward_exe => operand_res_alu,
									forward_mem => forward_mem,
									EX_MEM_write => EX_MEM_write,
									MEM_WB_write => MEM_WB_write,
									MEM_WB_rd => MEM_WB_RD,
									ID_EX_Rd => ID_EX_Rd,
									ID_EX_Rs => ID_EX_Rs,
									ID_EX_Rt => ID_EX_Rt,
									enable => en5,
									sel_1 => sel1,
									sel_2 => sel2,
									sel_3 => sel3,
									func => func,
									EX_MEM_rd => EX_MEM_RD,
									out_res_operand_one => operand_res_alu,
									out_res_operand_two => dataout,
									next_pc => next_pc,
									jump => jump,
									multi_cycle_operation => multi_cycle_operation
								);

DU : decodeUnit port map (	clock => clock,
									reset => reset,
									multi_cycle_operation => multi_cycle_operation,
									en1 => en1,
									read_enable_portA => en2,
									read_enable_portB => en3,
									write_enable_portW => en4,
									instructionWord => instructionWord_ToDecode,
									ID_EX_MemRead => hazard_condition,
									ID_EX_RT_Address => ID_EX_Rt,
									writeData => forward_mem,
									writeAddress => MEM_WB_RD,
									pc => NPC_to_decode,
									sel_ext => sel_ext,
									enable_signal_PC_IF_ID => disable_fetch_register,
									selectNop => hazard_detected,
									outRT => ID_EX_Rt,
									outRD => ID_EX_Rd,
									outRS => ID_EX_Rs,
									outIMM => operand_IMM,
									outPC => operand_PC,
									outA => operand_A,
									outB => operand_B
								);

FU : fetchUnit port map (	sel0 => sel0,
									en0 => disable_fetch_register,
									clock => clock,
									reset => reset,
									fromInstructionMemory => from_instruction_memory,
									next_PC => next_pc,
									PcToInstructionMemory => pc_to_im,
									InstructionToDecode => instructionWord_ToDecode,
									pcToDecode => NPC_to_decode
 								);
								
instruction <= instructionWord_ToDecode;
																
end Structural;