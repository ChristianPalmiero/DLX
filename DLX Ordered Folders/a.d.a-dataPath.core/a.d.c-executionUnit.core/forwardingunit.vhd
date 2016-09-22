---------------------------------------------------------------
--This unit detects EX/MEM hazards and MEM/WB hazards
---------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarding_unit is
		port(
			--EX/MEM data equations
			EX_MEM_write : in std_logic;
			EX_MEM_Rd : in std_logic_vector(4 downto 0);
			ID_EX_Rs : in std_logic_vector(4 downto 0);
			ID_EX_Rt : in std_logic_vector(4 downto 0);
			
			--MEM/WB data equations
			MEM_WB_write : in std_logic;
			MEM_WB_Rd : in std_logic_vector(4 downto 0);
			--ID_EX_Rs : in std_logic_vector(4 downto 0);
			--EX_MEM_Rd : in std_logic_vector(4 downto 0);
			--EX_MEM_write : in std_logic;
			--ID_EX_Rt : in std_logic_vector(4 downto 0);
			
			sel_mux_high : out std_logic_vector(1 downto 0);
			sel_mux_low : out std_logic_vector(1 downto 0)
		);
								
end forwarding_unit;

architecture Structural of forwarding_unit is

signal out_cu_upper_mux : std_logic_vector(1 downto 0);
signal out_cu_lower_mux : std_logic_vector(1 downto 0);


component cu_upper_mux 
	port(
		EX_MEM_write : in std_logic;
		MEM_WB_write : in std_logic;
		MEM_WB_Rd : in std_logic_vector(4 downto 0);
		EX_MEM_Rd : in std_logic_vector(4 downto 0);
		ID_EX_Rs : in std_logic_vector(4 downto 0);
		
		sel_upper_mux : out std_logic_vector(1 downto 0)
	);
		
end component;


component cu_lower_mux 
	port(
			EX_MEM_write : in std_logic;
			MEM_WB_write : in std_logic;
			EX_MEM_Rd : in std_logic_vector(4 downto 0);
			ID_EX_Rt : in std_logic_vector(4 downto 0);
			MEM_WB_Rd : in std_logic_vector(4 downto 0);
			
			sel_lower_mux : out std_logic_vector(1 downto 0)
	);	
end component;


begin

CU_U_M : cu_upper_mux port map(
										EX_MEM_write => EX_MEM_write,
										MEM_WB_write => MEM_WB_write,
										MEM_WB_Rd => MEM_WB_Rd,
										EX_MEM_Rd => EX_MEM_Rd,
										ID_EX_Rs => ID_EX_Rs,
										sel_upper_mux => out_cu_upper_mux
									);
									
CU_L_M : cu_lower_mux port map(
										EX_MEM_write => EX_MEM_write,
										MEM_WB_write => MEM_WB_write,
										EX_MEM_Rd => EX_MEM_Rd,
										ID_EX_Rt => ID_EX_Rt,
										MEM_WB_Rd => MEM_WB_Rd,
										sel_lower_mux => out_cu_lower_mux
									);


sel_mux_high <= out_cu_upper_mux;
sel_mux_low <= out_cu_lower_mux;

end Structural;