library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodeUnit is
	port(
		------***INPUT***------
		clock,reset : in std_logic;
		en1 : in std_logic;
		--en for RF
		read_enable_portA : in std_logic;
		--en for RF
		read_enable_portB : in std_logic;
		--en for RF
		write_enable_portW : in std_logic;
		--from IR register
		instructionWord : in std_logic_vector(31 downto 0);
		--for hazard unit tell me if the previous instruction will
		--write on RF
		ID_EX_MemRead : in std_logic;
		--destination address for the previous instruction
		ID_EX_RT_Address : in std_logic_vector(4 downto 0);
		--data to be written in RF
		writeData : in std_logic_vector(31 downto 0);
		--address for RF
		writeAddress : in std_logic_vector(4 downto 0);
		--next PC 
		pc : in std_logic_vector(31 downto 0);
		--selection signal for extender modules
		sel_ext : in std_logic;
		--multy cylce op
		multi_cycle_operation : in std_logic;
		
		------***OUTPUT***------
		--control signal for fetch stage
		enable_signal_PC_IF_ID : out std_logic;
		--conditioning signal
		selectNop : out std_logic;
		--end conditioning signal
		outRT : out std_logic_vector(4 downto 0);
		outRD : out std_logic_vector(4 downto 0);
		outRS : out std_logic_vector(4 downto 0);
		outIMM : out std_logic_vector(31 downto 0);
		outPC : out std_logic_vector(31 downto 0);
		outA : out std_logic_vector(31 downto 0);
		outB : out std_logic_vector(31 downto 0)
	);
end decodeUnit;

architecture Structural of decodeUnit is

component Mux2X1 is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		sel : in std_logic;
		o : out std_logic_vector(31 downto 0)
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

component regWithEnable_5bit is
	port(
		input : in std_logic_vector(4 downto 0);
		en : in std_logic;
		clock,reset : in std_logic;
		output : out std_logic_vector(4 downto 0)
	);
end component;

component register_file 
	port(
		data_in_port_w : in std_logic_vector(31 downto 0);
		data_out_port_a : out std_logic_vector(31 downto 0);
		data_out_port_b : out std_logic_vector(31 downto 0);
		address_port_a : in std_logic_vector(4 downto 0);
		address_port_b : in std_logic_vector(4 downto 0);
		address_port_w : in std_logic_vector(4 downto 0);
		r_signal_port_a : in std_logic;
		r_signal_port_b : in std_logic;
		w_signal : in std_logic;
		reset, enable : in std_logic
	);
end component;

component hazardUnit 
	port(
		RS_address : in std_logic_vector(4 downto 0);
		RT_address : in std_logic_vector(4 downto 0);
		RT_address_ID_EX : in std_logic_vector(4 downto 0);
		MemRead_ID_EX : in std_logic;
		multi_cycle_operation : in std_logic;
		enable_signal : out std_logic;
		sel1 : out std_logic
	);
end component;

component extensionModule 
	port(
		i : in std_logic_vector(15 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end component;

component extensionModule26bit 
	port(
		i : in std_logic_vector(25 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
end component;

signal fromFirstExtToImm, fromSecExtToImm, fromMuxToImm : std_logic_vector(31 downto 0);
signal fromPortAToRegA : std_logic_vector(31 downto 0);
signal fromPortBToRegB : std_logic_vector(31 downto 0);

begin

IMM : regWithEnable port map(	input => fromMuxToImm,
										en => en1,
										clock => clock,
										reset => reset,
										output => outIMM
									);
PC_R : regWithEnable port map(	input => pc,
											en => en1,
											clock => clock,
											reset => reset,
											output => outPC
										);
OP_A : regWithEnable port map(	input => fromPortAToRegA,
											en => en1,
											clock => clock,
											reset => reset,
											output => outA
									);
OP_B : regWithEnable port map(	input => fromPortBToRegB,
											en => en1,
											clock => clock,
											reset => reset,
											output => outB
									);
OP_RD : regWithEnable_5bit port map(	input => instructionWord(15 downto 11),
											en => en1,
											clock => clock,
											reset => reset,
											output => outRD
									);		
OP_RS : regWithEnable_5bit port map(	input => instructionWord(25 downto 21),
											en => en1,
											clock => clock,
											reset => reset,
											output => outRS
									);
OP_RT : regWithEnable_5bit port map(	input => instructionWord(20 downto 16),
											en => en1,
											clock => clock,
											reset => reset,
											output => outRT
									);									
HU : hazardUnit port map(  RS_address => instructionWord(25 downto 21),
									RT_address => instructionWord(20 downto 16),
									RT_address_ID_EX => ID_EX_RT_Address,
									MemRead_ID_EX => ID_EX_MemRead,
									multi_cycle_operation => multi_cycle_operation,
									enable_signal => enable_signal_PC_IF_ID,
									sel1 => selectNop
								);
RF : register_file port map(	data_in_port_w => writeData,
										data_out_port_a => fromPortAToRegA, 
										data_out_port_b => fromPortBToRegB,
										address_port_a => instructionWord(25 downto 21),
										address_port_b => instructionWord(20 downto 16),
										address_port_w => writeAddress,
										r_signal_port_a => read_enable_portA,
										r_signal_port_b => read_enable_portB,
										w_signal => write_enable_portW,
										reset => reset,
										enable => en1
									);
EXT1 : extensionModule port map(	i => instructionWord(15 downto 0),
											o => fromFirstExtToImm
										);
EXT2 : extensionModule26bit port map(	i => instructionWord(25 downto 0),
											o => fromSecExtToImm
										);
MUXEXT: Mux2X1 port map(
							a => fromFirstExtToImm,
							b => fromSecExtToImm,
							sel => sel_ext, 
							o => fromMuxToImm
						);
end Structural;
