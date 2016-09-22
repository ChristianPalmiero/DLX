library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logicUnitT2 is
	generic (
		data_size : integer := 32
	);
	port (
		operand_a : in std_logic_vector(data_size-1 downto 0);
		operand_b : in std_logic_vector(data_size-1 downto 0);
		type_op : in std_logic_vector(3 downto 0);
		result : out std_logic_vector(data_size-1 downto 0)
	);
end logicUnitT2;

architecture Behavioral of logicUnitT2 is

	component nandWithEn 
	generic (
		data_size : integer :=32
	);
	port(
		operand_a : in std_logic_vector(data_size-1 downto 0);
		operand_b : in std_logic_vector(data_size-1 downto 0);
		enable : in std_logic;
		output : out std_logic_vector(data_size-1 downto 0)
	);
	end component;

	signal partial_result_l0 : std_logic_vector(data_size-1 downto 0);
	signal partial_result_l1 : std_logic_vector(data_size-1 downto 0);
	signal partial_result_l2 : std_logic_vector(data_size-1 downto 0);
	signal partial_result_l3 : std_logic_vector(data_size-1 downto 0);
	signal notA, notB : std_logic_vector(data_size-1 downto 0);
	
begin

notA <= not (operand_a);
notB <= not (operand_b);

n0 : nandWithEn generic map(data_size => data_size) 
			port map(
						operand_a => notA,
						operand_b => notB,
						enable => type_op(0),
						output => partial_result_l0
			);
n1 : nandWithEn generic map(data_size => data_size) 
			port map(
						operand_a => operand_a,
						operand_b => notB,
						enable => type_op(1),
						output => partial_result_l1
			);
n2 : nandWithEn generic map(data_size => data_size) 
			port map(
						operand_a => notA,
						operand_b => operand_b,
						enable => type_op(2),
						output => partial_result_l2
			);
n3 : nandWithEn generic map(data_size => data_size) 
			port map(
						operand_a => operand_a,
						operand_b => operand_b,
						enable => type_op(3),
						output => partial_result_l3
			);

process(partial_result_l0,partial_result_l1,partial_result_l2,partial_result_l3)	
	variable tmp_one : std_logic;
	variable tmp_two : std_logic;
begin
	for I in data_size-1 downto 0 loop
				tmp_one := not (partial_result_l0(I)) or not (partial_result_l1(I));
				tmp_two := not (partial_result_l2(I)) or not (partial_result_l3(I));
				result(I) <= tmp_one or tmp_two;
	end loop;
end process;

end Behavioral;

