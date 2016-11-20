-- CONVENTIONAL RESTORING DIVISION ALGORITHM
-- A) The operands are both positive
-- B) The operands are normalized, i.e. smaller than 1 in absolute value
-- C) The dividend Y is smaller than the divisor X
-- X = 0.x0 x1 ... xm-1
-- Y = 0.y0 y1 ... yn-1
-- Quotient Q = 0.q0 ... qn-1
-- Remainder R = 0.r0 r1 ... rn-1
-- X/Y = Q + (R/Y)*2^(n-1)

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity DIVIDER is
generic(N_op : INTEGER := 32);
port
(
  CLK, START, RESET : in STD_LOGIC;
  BUSY : out STD_LOGIC;
  DIVIDEND, DIVISOR : in STD_LOGIC_VECTOR(N_op-1 downto 0);
  QUOTIENT, RESIDUAL : out STD_LOGIC_VECTOR(N_op-1 downto 0)
);
end DIVIDER;

architecture asd of DIVIDER is
------------ internal signals -------------
signal QUOTIENT_inter : STD_LOGIC_VECTOR(N_op-1 downto 0) := (others=>'0');
signal RESIDUAL_inter, RESI_2, RESI_ES : STD_LOGIC_VECTOR(N_op-1 downto 0);
signal flag : STD_LOGIC;
signal count : INTEGER;
------------------------------------------- 
begin

   RESI_2 <= RESIDUAL_inter(N_op-2 downto 0) & '0' ; 
   RESI_ES <= RESI_2 - DIVISOR;
  
   CTRLprocess: process(CLK, START, DIVIDEND, DIVISOR)
                begin
                  if (START='1') then
                      RESIDUAL_inter <= DIVIDEND;
                      QUOTIENT <= (others=>'0');
                      RESIDUAL <= (others=>'0');
							 BUSY <= '1';
                      count <= 0;
							 flag <= '1';
						elsif rising_edge(clk) then	
							if (RESET = '1') then 
								QUOTIENT <= (others=>'0');
								RESIDUAL <= (others=>'0');
								BUSY <= '0';
								count <= 0;
								flag <= '0';
							elsif (count /= N_op-1 and flag = '1') then
								 if (RESI_ES(N_op-1) = '1') then
									  RESIDUAL_inter <= RESI_2;
									  QUOTIENT_inter <= QUOTIENT_inter(N_op-2 downto 0) & '0';
								 elsif (RESI_ES(N_op-1) = '0') then
									  RESIDUAL_inter <= RESI_ES;
									  QUOTIENT_inter <= QUOTIENT_inter(N_op-2 downto 0) & '1';
								 end if;
								 BUSY <= '1';
								 count <= count + 1;
							else
								BUSY <= '0';
								flag <= '0';
								count <= 0;
								QUOTIENT <= QUOTIENT_inter;
								RESIDUAL <= RESIDUAL_inter;
							end if;
                  end if;
                end process;  
end asd;