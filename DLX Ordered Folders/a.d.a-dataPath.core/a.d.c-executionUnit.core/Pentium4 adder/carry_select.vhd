

library ieee; 
use ieee.std_logic_1164.all;


entity carry_select is
generic (NBIT: integer:= 32;
	Xbit: integer:=4);
port (C: in std_logic;
	A,B: in std_logic_vector (NBIT-1 downto 0);
	S: out std_logic_vector (NBIT-1 downto 0) );
end carry_select;

architecture structural of carry_select is


signal out_0, out_1: std_logic_vector (NBIT-1 downto 0);
signal c_out_0,c_out_1: std_logic;

component RCA is
Generic (NBIT: integer:= 4);
Port (		A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Co:	Out	std_logic);
end component; 

component MUX21_GENERIC is
Generic (NBIT: integer:= 4);
		
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0) ;
		B:	In	std_logic_vector(NBIT-1 downto 0);
		S:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end component;

begin

RCA_0: RCA 
generic map (NBIT=>4)
port map(A, B,'0', out_0, c_out_0);

RCA_1: RCA 
generic map (NBIT=>4)
port map(A, B,'1', out_1, c_out_1);

MUX: MUX21_GENERIC 
generic map (NBIT=>4)
port map(out_0, out_1, C, S);

end structural;