library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memoryUnit is
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
end memoryUnit;

architecture Behavioral of memoryUnit is

component regWithEnable_5bit 
	port(
		input : in std_logic_vector(4 downto 0);
		en : in std_logic;
		clock,reset : in std_logic;
		output : out std_logic_vector(4 downto 0)
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

begin

address_memory <= alu_result;

RE : regWithEnable_5bit port map(
								clock => clock,
								reset => reset,
								en => enable,
								input => EX_MEM_Rd,
								output => MEM_WB_Rd
							);
							
RE_1 : regWithEnable port map (
								clock => clock,
								reset => reset,
								en => enable,
								input => data_from_memory,
								output => data_op1
							);

RE_2 : regWithEnable port map (
								clock => clock,
								reset => reset,
								en => enable,
								input => alu_result,
								output => data_op2
							);

end Behavioral;