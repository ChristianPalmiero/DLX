library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


 
entity generator is
	
	generic (N_bit : natural := 32);
	port(
			multiplicant : in std_logic_vector(N_bit-1 downto 0);
			
			N_shift: in integer;
		
			select_signal : in std_logic_vector(2 downto 0);
			
			Out_value : out std_logic_vector(2*N_bit-1 downto 0)
	);
	
end generator;

architecture Structural of generator is

signal from_gen_to_mux_one : std_logic_vector(2*N_bit-1 downto 0);
signal from_gen_to_mux_two : std_logic_vector(2*N_bit-1 downto 0);
signal from_gen_to_mux_three : std_logic_vector(2*N_bit-1 downto 0);
signal from_gen_to_mux_four : std_logic_vector(2*N_bit-1 downto 0);
signal from_gen_to_mux_five : std_logic_vector(2*N_bit-1 downto 0);

component gen_circuit is

	generic (N_bit : natural := 32);
	port(
			operand : in std_logic_vector(N_bit-1 downto 0);
			shift : in integer;
			out1: out std_logic_vector(2*N_bit-1 downto 0);
			out2 : out std_logic_vector(2*N_bit-1 downto 0);
			out3 : out std_logic_vector(2*N_bit-1 downto 0);
			out4 : out std_logic_vector(2*N_bit-1 downto 0);
			out5 : out std_logic_vector(2*N_bit-1 downto 0)
	);
	
end component;

component mux5_1 is

	generic (N_bit : natural := 32);
	port(
		in1 : in std_logic_vector(2*N_bit-1 downto 0);
		in2 : in std_logic_vector(2*N_bit-1 downto 0);
		in3 : in std_logic_vector(2*N_bit-1 downto 0);
		in4 : in std_logic_vector(2*N_bit-1 downto 0);
		in5 : in std_logic_vector(2*N_bit-1 downto 0);
		s : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(2*N_bit-1 downto 0)
	);
end component;


begin

G0: gen_circuit generic map (N_bit=>N_bit) port map (multiplicant,N_shift,from_gen_to_mux_one,from_gen_to_mux_two,
	from_gen_to_mux_three,from_gen_to_mux_four,from_gen_to_mux_five);

M0: mux5_1 generic map (N_bit=>N_bit) port map (from_gen_to_mux_one,from_gen_to_mux_two,from_gen_to_mux_three,
	from_gen_to_mux_four,from_gen_to_mux_five,select_signal,Out_value);


end Structural;

