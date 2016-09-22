library ieee; 
use ieee.std_logic_1164.all;


--NBIT: #bits for each single carry select
--XBIT: #bits of operands
--XBIT/NBIT: #bits carry out generated 

entity carry_gen is 
generic (nbit: integer:= 4; xbit: integer:= 32 ); 
port (a,b: in std_logic_vector (xbit-1 downto 0);
	c_0: in std_logic;
	c_out: out std_logic_vector (xbit/nbit-1 downto 0)); 
end carry_gen;




architecture structural of carry_gen is

component pre_proc is
port ( a,b: in std_logic;
	p,g: out std_logic);
end component;

component pg is
port ( p_sx, p_dx, g_sx,c_dx: in std_logic;
	p_out, g_out: out std_logic);
end component;


component G_block is
port ( p_sx, g_sx,c_dx: in std_logic; 
	g_out: out std_logic);
end component;


function lograd2 ( arg: integer ) return integer ;

function lograd2 ( arg: integer )  return integer is


	variable temp    : integer := arg;
	variable result : integer := 0;
begin

while temp > 1 loop
result := result + 1;
temp    := temp / 2;
end loop;

      return result;
 end function lograd2 ;
 

type SignalVector is array ( lograd2(XBIT)+1 downto 0) of std_logic_vector (XBIT-1 downto 0); 
signal P,G: SignalVector;


begin
rows: for row in 0 to lograd2(XBIT)generate 

	r_0: if row =0 generate 				
		f_0: for col in 0 to XBIT-1 generate
		PG_NET: pre_proc port map (A (col), B(col), P(row+1)(col), G(row+1)(col) );
		end generate f_0;
	end generate r_0; 

	r_1: if row=1 generate 						
		f_1: for i in 0 to XBIT/2-1 generate
		
			G_1: if (i=0) generate
			c_last_1: G_block port map (P(row)(i*2+1),G(row)(i*2+1),G(row)(i*2),G(row+1)(i*2+1) );--
			end generate G_1;

			PG_1: if ( i/=0 ) generate
			c_1: PG port map (P(row)(i*2+1),P(row)(i*2),G(row)(i*2+1),G(row)(2*i),P(row+1)(i*2+1),G(row+1)(i*2+1) );
			end generate PG_1;

		end generate f_1;
	end generate r_1;

	r_2: if row=2 generate --fill the third one
		f_2:for i in 0 to XBIT/4-1 generate 

			G_2: if (i=0) generate
			c_last_2: G_block port map (P(row)(i*4+3),G(row)(i*4+3),G(row)(i*4+1),G(row+1)(i*4+3)  );--c4
			end generate G_2;

			PG_2: if ( i/=0 ) generate 
			c_2: PG port map (P(row)(i*4+3),P(row)(i*4+1),G(row)(i*4+3),G(row)(i*4+1),P(row+1)(i*4+3),G(row+1)(i*4+3) );
			end generate PG_2;
		
		end generate f_2;
	end generate r_2;

 
case_gen: if row/=0 and row /=1 and row/=2 generate

	r_gen: for i in 1 to XBIT/(4*2*2**(row-3)) generate 

		bl_1: if i=1 generate 
			fV_0: for j in 1 to 2**(row-3) generate --first block of signal lines
				G(row+1)( (i-1)*2**(row-3)*2*4+(j-1)*4+3 )<=G(row)( (i-1)*2**(row-3)*2*4+(j-1)*4+3  ); 
				P(row+1)( (i-1)*2**(row-3)*2*4+(j-1)*4+3 )<=P(row)( (i-1)*2**(row-3)*2*4+(j-1)*4+3  ); 
			end generate fV_0;
			fG_0: for j in 2**(row-3)+1 to 2**(row-3)*2 generate 		-- components G
c_last_gen: G_block port map ( P(row)( (i-1)*2**(row-3)*2*4+(j-1)*4+3 ), G(row)((i-1)*2**(row-3)*2*4+(j-1)*4+3), G(row)((i-1)*2**(row-3)*2*4+(2**(row-3)-1)*4+3), G(row+1)((i-1)*2**(row-3)*2*4+(j-1)*4+3)  );
			end generate fG_0;
		end generate bl_1;
		
		bl_gen: if i/=1 generate 									
			fV_1: for j in 1 to 2**(row-3) generate 
				G(row+1)( (i-1)*2**(row-3)*2*4+(j-1)*4+3 )<=G(row)( (i-1)*2**(row-3)*2*4+(j-1)*4+3  ); 
				P(row+1)( (i-1)*2**(row-3)*2*4+(j-1)*4+3 )<=P(row)( (i-1)*2**(row-3)*2*4+(j-1)*4+3  );
			end generate fV_1;

			fPG_1: for j in 2**(row-3)+1 to 2**(row-3)*2 generate --block PG
			c_g: PG port map (P(row)((i-1)*2**(row-3)*2*4+(j-1)*4+3), P(row)((i-1)*2**(row-3)*2*4+(2**(row-3)-1)*4+3), G(row)((i-1)*2**(row-3)*2*4+(j-1)*4+3),G(row)((i-1)*2**(row-3)*2*4+(2**(row-3)-1)*4+3), P(row+1)((i-1)*2**(row-3)*2*4+(j-1)*4+3),G(row+1)((i-1)*2**(row-3)*2*4+(j-1)*4+3) );
			end generate fPG_1;
		end generate bl_gen;
	end generate r_gen;


end generate case_gen;

end generate rows;


save: for i in 0 to xbit/nbit-1 generate 			
C_out(i)<=G(lograd2(XBIT)+1)((i+1)*NBIT-1 );
end generate save;
	

end structural;



