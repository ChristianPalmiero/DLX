library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity writeBacKUnit is
	port(
		clock, reset, enable, sel_4 : in std_logic;
		data_from_memory : in std_logic_vector(31 downto 0);
		data_from_alu : in std_logic_vector(31 downto 0);
		write_back_value : out std_logic_vector(31 downto 0);
		debug : out std_logic_vector(31 downto 0)
	);
end writeBacKUnit;

architecture Behavioral of writeBacKUnit is

component Mux2X1 
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

signal from_mux_to_out : std_logic_vector(31 downto 0);

begin

M0 : Mux2X1 port map(
						a => data_from_memory,
						b => data_from_alu,
						o => from_mux_to_out,
						sel => sel_4
					);
					
RE_DEBUG : regWithEnable port map (
								clock => clock,
								reset => reset,
								en => enable,
								input => from_mux_to_out,
								output => debug
							);

write_back_value <= from_mux_to_out;

end Behavioral;