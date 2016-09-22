library ieee;
use ieee.std_logic_1164.all;

entity DLX is
  port (
    Clock : in std_logic;
    Reset : in std_logic;		-- Active High
	 Debug_Out : out std_logic_vector(31 downto 0)
	 ); 
end DLX;

architecture Structural of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
  
  -- Datapath 
  component dataPath is
	port(
		sel0 : in std_logic;
		sel1 : in std_logic;
		sel2 : in std_logic;
		sel3 : in std_logic;
		sel4 : in std_logic;
		sel_ext : in std_logic;
		en1 : in std_logic;
		en2 : in std_logic;
		en3 : in std_logic;
		en4 : in std_logic;
		en5 : in std_logic;
		en6 : in std_logic;
		en7 : in std_logic;
		clock : in std_logic;
		reset : in std_logic;
		hazard_condition : in std_logic;
		func : in std_logic_vector(10 downto 0);
		EX_MEM_write : in std_logic;
		MEM_WB_write : in std_logic;
		from_instruction_memory : in std_logic_vector(31 downto 0);
		datain : in std_logic_vector(31 downto 0);
		hazard_detected : out std_logic;
		jump : out std_logic;
		pc_to_im : out std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0);
		address_data_memory : out std_logic_vector(31 downto 0);
		dataout : out std_logic_vector(31 downto 0);
		debug : out std_logic_vector(31 downto 0)
	);
	end component;
  
  -- Control Unit
  component CU_HW is
	generic (
		MICROCODE_MEM_SIZE : integer := 2**6-1;
		OPCODE_SIZE : integer := 6;
		FUNC_SIZE : integer := 11; 
		CW_LENGTH : integer := 18
	);
	port (
		clock : in std_logic;
		reset : in std_logic;
		stall : in std_logic;
		jump  : in std_logic;
		opcode : in std_logic_vector(OPCODE_SIZE-1 downto 0); 
		func : in std_logic_vector(FUNC_SIZE-1 downto 0);
		en1 : out std_logic; 
		en2 : out std_logic; 
		en3 : out std_logic; 
		sel_ext : out std_logic; 
		hazard_condition : out std_logic; 
		sel1 : out std_logic; 
		sel2 : out std_logic; 
		sel3 : out std_logic; 
		en5 : out std_logic;  
		exe_func : out std_logic_vector(FUNC_SIZE-1 downto 0); 
		sel0 : out std_logic; 
		ex_mem_write : out std_logic;
		en6 : out std_logic; 
		write_data_mem : out std_logic;
		read_data_mem : out std_logic;
		en4 : out std_logic;  
		en7 : out std_logic;	 
		sel4 : out std_logic; 
		mem_wb_write : out std_logic
	);
	end component;
	
	-- Memories
	component DataMemory 
	port (
	 clock	: in  std_logic;
	 reset 	: in 	std_logic;
    we      : in  std_logic;
	 re		: in  std_logic;
    address : in  std_logic_vector(31 downto 0);
    datain  : in  std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
	);
	end component;

	component InstructionMemory 
	port (
	 Reset: in std_logic;
    address : in  std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
	);
	end component;

  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------
 
  signal SEL0 : std_logic;
  signal SEL1 : std_logic;
  signal SEL2 : std_logic;
  signal SEL3 : std_logic;
  signal SEL4 : std_logic;
  signal SEL_EXT : std_logic;
  signal WRITE_DATA_MEM : std_logic;
  signal READ_DATA_MEM : std_logic;
  signal EN1 : std_logic;
  signal EN2 : std_logic;
  signal EN3 : std_logic;
  signal EN4 : std_logic;
  signal EN5 : std_logic;
  signal EN6 : std_logic;
  signal EN7 : std_logic;
  signal HAZARD_CONDITION : std_logic;
  signal FUNC : std_logic_vector(10 downto 0);
  signal EX_MEM_WRITE : std_logic;
  signal MEM_WB_WRITE : std_logic;
  signal	HAZARD_DETECTED : std_logic;
  signal FROM_INSTRUCTION_MEMORY : std_logic_vector(31 downto 0);
  signal ADDRESS_DATA_MEMORY : std_logic_vector(31 downto 0);
  signal DATAIN_MEM : std_logic_vector(31 downto 0);
  signal JUMP : std_logic;
  signal PC_TO_IM : std_logic_vector(31 downto 0);
  signal INSTRUCTION : std_logic_vector(31 downto 0);
  signal DATAOUT_MEM : std_logic_vector(31 downto 0);
  signal DEBUG : std_logic_vector(31 downto 0);

  begin

    -- Control Unit Instantiation
    CU: CU_HW
      port map (
          Clock             => Clock,
          Reset             => Reset,
          Stall             => Hazard_detected,
			 Jump  				 => Jump,
          Opcode			    => Instruction(31 downto 26),
          Func				    => Instruction(10 downto 0),
          En1					 => En1,
			 En2					 => En2,
			 En3					 => En3,
			 Sel_Ext				 => Sel_Ext,
			 Hazard_Condition  => Hazard_Condition,
			 Sel1              => Sel1,
			 Sel2              => Sel2,
			 Sel3              => Sel3,
			 En5					 => En5,
			 Exe_Func			 => Func,
			 Ex_Mem_Write	    => Ex_Mem_Write,
			 Sel0				    => Sel0,
			 En6					 => En6,
			 Write_Data_Mem	 => Write_Data_Mem,
			 Read_Data_Mem	 	 => Read_Data_Mem,
			 En4					 => En4,
			 En7					 => En7,
			 Sel4				    => Sel4,
			 Mem_Wb_Write	    => Mem_Wb_Write
			 );
	
	 -- Datapath Instantiation
	 DP : datapath
		port map (
			 sel0 				 => sel0,
			 sel1 				 => sel1,
			 sel2 				 => sel2,
			 sel3 				 => sel3,
			 sel4 		  	 	 => sel4,
			 sel_ext 			 => sel_ext,
			 en1 					 => en1,
			 en2					 => en2,
			 en3 					 => en3,
			 en4 					 => en4,
			 en5 					 => en5,
			 en6 					 => en6,
			 en7 					 => en7,
			 clock 				 => clock,
			 reset 				 => reset,
			 hazard_condition  => hazard_condition,
			 func 				 => func,
			 EX_MEM_write 		 => EX_MEM_write,
			 MEM_WB_write      => MEM_WB_write,
			 from_instruction_memory => from_instruction_memory,
			 datain 				 => datain_mem,
			 hazard_detected   => hazard_detected,
			 jump   				 => jump,
			 pc_to_im			 => pc_to_im,
			 instruction 		 => instruction,
			 address_data_memory => address_data_memory,
			 dataout			    => dataout_mem,
			 debug 				 => debug
			 );
			 
		-- Memories Instantiation	 
		DM : DataMemory port map(
			 clock				 => clock,
		    reset 				 => reset,
			 we 					 => write_data_mem,
			 re					 => read_data_mem,
			 address				 => address_data_memory,
			 datain 				 => DATAout_MEM,
			 dataout 			 => DATAin_MEM
			 );

		IM : InstructionMemory port map(
			 Reset 				 => Reset,
			 address 			 => pc_to_im, 
			 dataout 			 => from_instruction_memory
			 );

Debug_Out <= debug;

end Structural;