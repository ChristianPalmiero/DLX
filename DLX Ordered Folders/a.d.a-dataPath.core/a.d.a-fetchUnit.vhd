library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fetchUnit is
	port(
		------***INPUT***------
		--MUX control signal
		sel0 : in std_logic;
		--PC and IR enable: this signal comes from the Decode Hazard Unit
		en0 : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		--datapath signals
		--signal coming form IRMemory, input to IR register
		fromInstructionMemory : in std_logic_vector(31 downto 0);
		--signal representing the value of PC when branch is taken, input to MUX2X1
		next_PC : in std_logic_vector(31 downto 0);
		------***OUTPUT***------
		--Pc used as address in instruction memory IRMemory
		PcToInstructionMemory : out std_logic_vector(31 downto 0);
		--New instruction for the decode stage
		InstructionToDecode : out std_logic_vector(31 downto 0);
		--NPC for the decode stage, if the instruction is a jump or branch
		--NPC is necessary to compute the target address
		pcToDecode : out std_logic_vector(31 downto 0)
	);		
end fetchUnit;

architecture Behavioral of fetchUnit is

	--regsiter with load 
	component regWithLoad32bit is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
	end component;
	--IR
	component InstructionRegister is
	port(
		clock,reset,load : in std_logic;
		i : in std_logic_vector(31 downto 0);
		o : out std_logic_vector(31 downto 0)
	);
	end component;
	--mux 2X1
	component Mux2X1 
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		sel : in std_logic;
		o : out std_logic_vector(31 downto 0)
		);
	end component;
	--adder for PC
	component Adder 
	 port ( 
		A: in std_logic_vector(31 downto 0); 
		B: in std_logic_vector(31 downto 0); 
		CI: in std_logic; 
		O: out std_logic_vector(31 downto 0); 
		CO: out std_logic 
	);
	end component;
	
	--signal byFour : std_logic_vector(31 downto 0) := (2 => '1', others => '0');
	--in questo caso aggiungo sempre piu uno al PC: la memoria viene infatti letta sequenzialmente
	signal byFour : std_logic_vector(31 downto 0) := (0 => '1', others => '0');
	
	--signals
	signal fromMuxToPc : std_logic_vector(31 downto 0); 
	signal fromPcToAdder : std_logic_vector(31 downto 0);
	signal fromAdderToMux : std_logic_vector(31 downto 0); 

begin

PC : regWithLoad32bit port map(clock,reset,en0,fromMuxToPc,fromPcToAdder);
IR : InstructionRegister port map(clock,reset,en0,fromInstructionMemory,InstructionToDecode);
MUX : Mux2X1 port map(a => next_PC,b => fromAdderToMux,sel => sel0,o => fromMuxToPc);
A : Adder port map(A => fromPcToAdder,B => byFour,CI => '0',O => fromAdderToMux,CO => open);

PcToInstructionMemory <= fromPcToAdder;
PcToDecode <= fromPcToAdder;

end Behavioral;
