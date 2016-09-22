library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pentium4_adder is

generic ( XBIT: integer:=32;
			NBIT: integer:=4 );
port (
	A,B: in std_logic_vector (XBIT-1 downto 0);
	C_0: in std_logic;
	S: out std_logic_vector (XBIT-1 downto 0);
	Cout: out std_logic
	);
end pentium4_adder;
architecture structural of pentium4_adder is

component sum_gen 
generic (NBIT: integer:= 4; XBIT: integer:=32);
port (	C: in std_logic_vector (XBIT/NBIT-1 downto 0);
	A,B: in std_logic_vector (XBIT-1 downto 0);
	S: out std_logic_vector (XBIT-1 downto 0 ));
end component;

component MUX21_GENERIC 
	Generic (NBIT: integer:= 32
		);
	Port (	A:	in	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		S:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0)
		);
end component;



component carry_gen is
generic (NBIT: integer:=4 ; XBIT: integer:= 32 );
port (A,B: in std_logic_vector (XBIT-1 downto 0);
	C_0: in std_logic;
	C_OUT: out std_logic_vector (XBIT/NBIT-1 downto 0));
end component;



signal C_gen,RC: std_logic_vector (XBIT/NBIT downto 0);
signal b_sub,exit_muxA,exit_muxB,Aadded : std_logic_vector (XBIT-1 downto 0);

begin

c_gen(0)<='0';
b_sub<= not(b);
Aadded<=A+1;
MX: MUX21_generic port map (B,b_sub,c_0,exit_muxB);
MY: MUX21_generic port map (A,Aadded,c_0,exit_muxA);
M1: carry_gen generic map (NBIT=>nbit, XBIT=>XBIT)port map (exit_muxA, exit_muxB, '0', C_gen(XBIT/NBIT downto 1)); 
M2: sum_gen generic map (NBIT=>nbit, XBIT=>XBIT) port map (C_gen(XBIT/NBIT-1 downto 0), exit_muxA, exit_muxB, S); 
cout<=C_gen(XBIT/NBIT);

end structural;
