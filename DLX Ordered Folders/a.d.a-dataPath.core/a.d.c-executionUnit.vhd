library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity executionUnit is
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
		--EX_MEM_rd : in std_logic_vector(4 downto 0);
		MEM_WB_rd : in std_logic_vector(4 downto 0);
		ID_EX_Rd : in std_logic_vector(4 downto 0);
		ID_EX_Rs : in std_logic_vector(4 downto 0);
		ID_EX_Rt : in std_logic_vector(4 downto 0);
		--from cu
		--enable for register
		enable : in std_logic;
		--mux pc (0) or operand A (1)
		sel_1 : in std_logic;
		--mux imm (0) or operand B (1)
		sel_2 : in std_logic;
		--mux for ex_mem_rd = id_exe_rt (0) or id_exe_rd (1)
		sel_3 : in std_logic;
		--func
		func : in std_logic_vector(10 downto 0);
		
		EX_MEM_rd : inout std_logic_vector(4 downto 0);
		--alu out
		out_res_operand_one : out std_logic_vector(31 downto 0);
		--input operand_b
		out_res_operand_two : out std_logic_vector(31 downto 0);
		--next PC
		next_pc : out std_logic_vector(31 downto 0);
		--not(jump)/jump
		jump : out std_logic;
		multi_cycle_operation : out std_logic
	);
end executionUnit;

architecture Structural of executionUnit is

component cu_exe 
	port(
		reset : in std_logic;
		func : in std_logic_vector(10 downto 0);
		busy_div : in std_logic;
		multi_cycle_operation : out std_logic;
		enable : out std_logic;
		sel_signal_5X1 : out std_logic_vector(2 downto 0);
		sel_signal_2X1 : out std_logic;
		start_div : out std_logic;
		cmd_t2 : out std_logic_vector(3 downto 0); 
		carry_in : out std_logic;
		left_right : out std_logic;
		logic_Arith : out std_logic;
		shift_rot : out std_logic;
		sel_comparator : out std_logic_vector(2 downto 0)
	);
end component;

component regWithEnable_5bit 
	port(
		input : in std_logic_vector(4 downto 0);
		en : in std_logic;
		clock,reset : in std_logic;
		output : out std_logic_vector(4 downto 0)
	);
end component;

component mux_2_1_5bit 
	port(
		a : in std_logic_vector(4 downto 0);
		b : in std_logic_vector(4 downto 0);
		sel : in std_logic;
		o : out std_logic_vector(4 downto 0)
		);
end component;

component DIVIDER is
	generic(N_op : INTEGER := 32);
	port(
	  CLK, START, RESET : in STD_LOGIC;
	  BUSY : out STD_LOGIC;
	  DIVIDEND, DIVISOR : in STD_LOGIC_VECTOR(N_op-1 downto 0);
	  QUOTIENT, RESIDUAL : out STD_LOGIC_VECTOR(N_op-1 downto 0)
	);
end component;

component booths_mul 
	generic (N_bit : natural := 16);
	port (
			multiplier,multiplicand : in std_logic_vector(N_bit-1 downto 0);
			product : out std_logic_vector(2*N_bit-1 downto 0)
	);
end component;

component regWithEnable 
	port(
		input : in std_logic_vector(31 downto 0);
		en : in std_logic;
		clock,reset : in std_logic;
		output : out std_logic_vector(31 downto 0)
	);
end component;

component mux5x1
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		c : in std_logic_vector(31 downto 0);
		d : in std_logic_vector(31 downto 0);
		e : in std_logic_vector(31 downto 0);
		enable : in std_logic;
		sel : in std_logic_vector(2 downto 0);
		out_res : out std_logic_vector(31 downto 0)
	);
end component;

component mux4_1 
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		c : in std_logic_vector(31 downto 0);
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic;
		sel : in std_logic_vector(1 downto 0);
		out_res : out std_logic_vector(31 downto 0)
	);
end component;

component mux3_1 
	port(
		operand_one : in std_logic_vector(31 downto 0);
		operand_two : in std_logic_vector(31 downto 0);
		operand_three : in std_logic_vector(31 downto 0);
		sel : in std_logic_vector(1 downto 0);
		out_res : out std_logic_vector(31 downto 0)
	);
end component;

component Mux2X1 
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		sel : in std_logic;
		o : out std_logic_vector(31 downto 0)
		);
end component;

component pentium4_adder 
generic ( 
			XBIT: integer:=32;
			NBIT: integer:=4 
		);
port (
	A,B: in std_logic_vector (XBIT-1 downto 0);
	C_0: in std_logic;
	S: out std_logic_vector (XBIT-1 downto 0);
	Cout: out std_logic
	);
end component;

component comparator
	port(	A: IN std_logic_vector(31 downto 0);
			B: IN std_logic_vector(31 downto 0);
			Sel: IN std_logic_vector(2 downto 0);
			O: out std_logic_vector(31 downto 0)
			);
end component;

component positive_latch_on_000 
	port(
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic_vector(2 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end component;

component positive_latch_on_001 
	port(
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic_vector(2 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end component;

component positive_latch_on_010 
	port(
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic_vector(2 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end component;

component positive_latch_on_100 
	port(
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic_vector(2 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end component;

component positive_latch_on_011 
	port(
		d : in std_logic_vector(31 downto 0);
		enable : in std_logic_vector(2 downto 0);
		q : out std_logic_vector(31 downto 0)
	);
end component;

component logicUnitT2 
	generic (
		data_size : integer := 32
	);
	port (
		operand_a : in std_logic_vector(data_size-1 downto 0);
		operand_b : in std_logic_vector(data_size-1 downto 0);
		type_op : in std_logic_vector(3 downto 0);
		result : out std_logic_vector(data_size-1 downto 0)
	);
end component;

component Shifter 
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
end component;

component forwarding_unit 
		port(
			--EX/MEM data equation
			EX_MEM_write : in std_logic;
			EX_MEM_Rd : in std_logic_vector(4 downto 0);
			ID_EX_Rs : in std_logic_vector(4 downto 0);
			ID_EX_Rt : in std_logic_vector(4 downto 0);
			
			--MEM/WB data equation
			MEM_WB_write : in std_logic;
			MEM_WB_Rd : in std_logic_vector(4 downto 0);
			--ID_EX_Rs : in std_logic_vector(4 downto 0);
			--EX_MEM_Rd : in std_logic_vector(4 downto 0);
			--EX_MEM_write : in std_logic;
			--ID_EX_Rt : in std_logic_vector(4 downto 0);
			
			sel_mux_high : out std_logic_vector(1 downto 0);
			sel_mux_low : out std_logic_vector(1 downto 0)
		);
								
end component;


--signal sel_from_forward_unit : std_logic_vector(1 downto 0) := (others => '0');
signal mux_to_mux_high : std_logic_vector(31 downto 0);
signal mux_to_mux_low : std_logic_vector(31 downto 0);
signal from_latch_to_adder_op1 : std_logic_vector(31 downto 0);
signal from_mux_add_or_sub_to_adder_op2 : std_logic_vector(31 downto 0);
signal from_latch_to_logict2_op1 : std_logic_vector(31 downto 0);
signal from_latch_to_mul_op1 : std_logic_vector(31 downto 0);
signal from_latch_to_mul_op2 : std_logic_vector(31 downto 0);
signal from_latch_to_logict2_op2 : std_logic_vector(31 downto 0);
signal from_adder_to_mux : std_logic_vector(31 downto 0);
signal from_logict2_to_mux : std_logic_vector(31 downto 0);
signal from_mul_to_mux : std_logic_vector(31 downto 0);
signal from_latch_to_shifter_op1 : std_logic_vector(31 downto 0);
signal from_latch_to_shifter_op2 : std_logic_vector(31 downto 0);
signal from_latch_to_comparator_op1 : std_logic_vector(31 downto 0);
signal from_latch_to_comparator_op2 : std_logic_vector(31 downto 0);
signal from_shifter_to_mux : std_logic_vector(31 downto 0);
signal from_comparator_to_mux : std_logic_vector(31 downto 0);
signal from_mux4_1_to_reg : std_logic_vector(31 downto 0);
signal from_mux_2_1_to_latch_high : std_logic_vector(31 downto 0);
signal from_mux_2_1_to_latch_low : std_logic_vector(31 downto 0);
signal quotient : std_logic_vector(31 downto 0);
signal reminder : std_logic_vector(31 downto 0);
signal from_mux_4_1_to_mux_2_1 : std_logic_vector(31 downto 0);
signal from_mux_2_1_to_reg : std_logic_vector(31 downto 0);
signal sel_mux_3_1_high : std_logic_vector(1 downto 0);
signal sel_mux_3_1_low : std_logic_vector(1 downto 0);
signal EX_MEM_rd_next : std_logic_vector(4 downto 0);
signal signal_cmd_t2 : std_logic_vector(3 downto 0);
signal carry_in :  std_logic;
signal left_right : std_logic;
signal logic_Arith : std_logic;
signal shift_rot : std_logic;
signal start_div : std_logic;
signal enable_mux_4_1 : std_logic;
signal sel_signal_5_1, sel_comparator : std_logic_vector(2 downto 0);
signal sel_signal_2_1 : std_logic;
signal from_latch_to_mux_sub_or_add : std_logic_vector(31 downto 0);
signal operand_Shifted : std_logic_vector(31 downto 0);
signal busy : std_logic;


begin

RE_2 : regWithEnable port map(
							input => mux_to_mux_low,
							en => enable,
							clock => clock,
							reset => reset,
							output => out_res_operand_two
						);

CU_EX : cu_exe port map (
				func => func,
				reset => reset,
				busy_div => busy,
				multi_cycle_operation => multi_cycle_operation,
				enable => enable_mux_4_1,
				sel_signal_5X1 => sel_signal_5_1,
				sel_signal_2X1 => sel_signal_2_1,
				start_div => start_div,
				cmd_t2 => signal_cmd_t2,
				carry_in => carry_in,
				left_right => left_right,
				logic_Arith => logic_Arith,
				shift_rot => shift_rot,
				sel_comparator => sel_comparator
			);

RE_1 : regWithEnable_5bit port map(
							input => EX_MEM_rd_next,
							en => enable,
							clock => clock,
							reset => reset,
							output => EX_MEM_rd
						);

M6 : mux_2_1_5bit port map(
							a => ID_EX_Rd,
							b => ID_EX_Rt,
							sel => sel_3,
							o => EX_MEM_rd_next
						);

FU : forwarding_unit port map(
							EX_MEM_write => EX_MEM_write,
							EX_MEM_Rd => EX_MEM_rd,
							ID_EX_Rs => ID_EX_Rs,
							ID_EX_Rt => ID_EX_Rt,
							MEM_WB_write => MEM_WB_write,
							MEM_WB_Rd => MEM_WB_rd,
							sel_mux_high => sel_mux_3_1_high,
							sel_mux_low => sel_mux_3_1_low
						);
							
M5 : Mux2X1 port map(
							a => quotient,
							b => from_mux_4_1_to_mux_2_1,
							sel => sel_signal_2_1, 
							o => from_mux_2_1_to_reg
						);

DM : divider port map(
							clk => clock,
							start => start_div,
							reset => reset,
							busy => busy,
							dividend => from_mux_2_1_to_latch_high,
							divisor => from_mux_2_1_to_latch_low,
							quotient => quotient,
							residual => reminder
						);

RE : regWithEnable port map(
							input => from_mux_2_1_to_reg,
							en => enable,
							clock => clock,
							reset => reset,
							output => out_res_operand_one
						);

SF : Shifter port map(
							left_right => left_right,
							logic_Arith => logic_Arith,
							shift_rot => shift_rot,
							a => from_latch_to_shifter_op1,
							b => from_latch_to_shifter_op2,
							o => from_shifter_to_mux
						);

BM : booths_mul port map(
						multiplier => from_latch_to_mul_op2(15 downto 0),
						multiplicand => from_latch_to_mul_op1(15 downto 0),
						product => from_mul_to_mux
						);

M4 : mux5x1 port map(
							a => from_adder_to_mux,
							b => from_logict2_to_mux,
							c => from_mul_to_mux,
							d => from_shifter_to_mux,
							e => from_comparator_to_mux,
							enable => enable_mux_4_1,
							sel => sel_signal_5_1, 
							out_res => from_mux_4_1_to_mux_2_1
						);

T2 : logicUnitT2 port map(
								operand_a => from_latch_to_logict2_op1,
								operand_b => from_latch_to_logict2_op2,
								type_op => signal_cmd_t2,
								result => from_logict2_to_mux
							);

PL0 : positive_latch_on_000 port map(
										d => from_mux_2_1_to_latch_high,
										enable => sel_signal_5_1,
										q => from_latch_to_adder_op1
									);
									
PL1 : positive_latch_on_000 port map(
										d => from_mux_2_1_to_latch_low,
										enable => sel_signal_5_1,
										q => from_latch_to_mux_sub_or_add
									);


PL2 : positive_latch_on_001 port map(
										d => from_mux_2_1_to_latch_high,
										enable => sel_signal_5_1,
										q => from_latch_to_logict2_op1
									);

PL3 : positive_latch_on_001 port map(
										d => from_mux_2_1_to_latch_low,
										enable => sel_signal_5_1,
										q => from_latch_to_logict2_op2
									);
PL4 : positive_latch_on_010 port map(
										d => from_mux_2_1_to_latch_high,
										enable => sel_signal_5_1,
										q => from_latch_to_mul_op1
									);

PL5 : positive_latch_on_010 port map(
										d => from_mux_2_1_to_latch_low,
										enable => sel_signal_5_1,
										q => from_latch_to_mul_op2
									);
PL6 : positive_latch_on_011 port map(
										d => from_mux_2_1_to_latch_high,
										enable => sel_signal_5_1,
										q => from_latch_to_shifter_op1
									);

PL7 : positive_latch_on_011 port map(
										d => from_mux_2_1_to_latch_low,
										enable => sel_signal_5_1,
										q => from_latch_to_shifter_op2
									);

PL8 : positive_latch_on_100 port map(
										d => from_mux_2_1_to_latch_high,
										enable => sel_signal_5_1,
										q => from_latch_to_comparator_op1
									);

PL9 : positive_latch_on_100 port map(
										d => from_mux_2_1_to_latch_low,
										enable => sel_signal_5_1,
										q => from_latch_to_comparator_op2
									);
									
COMP : comparator port map(
									A => from_latch_to_comparator_op1,
									B => from_latch_to_comparator_op2,
									Sel => sel_comparator,
									O => from_comparator_to_mux
									);

P4 : pentium4_adder port map(
										A => from_latch_to_adder_op1,
										B => from_latch_to_mux_sub_or_add,
										C_0 => carry_in,
										S => from_adder_to_mux,
										cout => open
									);
									
BRANCH_ADDER : pentium4_adder port map(
										A => operand_pc,
										B => operand_shifted,
										C_0 => '0',
										S => next_pc,
										cout => open
									);

M2 : Mux2X1 port map(
							a => mux_to_mux_high,
							b => operand_pc,
							sel => sel_1, 
							o => from_mux_2_1_to_latch_high
						);

M3 : Mux2X1 port map(
							a => mux_to_mux_low,
							b => operand_imm,
							sel => sel_2, 
							o => from_mux_2_1_to_latch_low
						);

M0 : mux3_1 port map(
							operand_one => operand_a,
							operand_two => forward_exe,
							operand_three => forward_mem,
							sel => sel_mux_3_1_high,
							out_res => mux_to_mux_high  
							);
							
M1 : mux3_1 port map(
							operand_one => operand_b,
							operand_two => forward_exe,
							operand_three => forward_mem,
							sel => sel_mux_3_1_low,
							out_res => mux_to_mux_low 
							);
							
jump<=from_comparator_to_mux(0);
operand_shifted<=to_StdLogicVector((to_bitvector(operand_imm)) sra 2);
end Structural;