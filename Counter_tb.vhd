LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
USE work.myLib.ALL;
	
entity Counter_tb is
end Counter_tb; 

architecture BHV of Counter_tb is
	signal Clk, Rst, EN, LD: std_logic;
	signal Q:std_logic_vector(7 downto 0);
begin 
	CNT : Counter PORT MAP (Clk => Clk, Rst => Rst, EN => EN, LD => LD, Q => Q);

	clock_process :process
	begin
     	clk <= '1';
     	wait for 10 ns;
     	clk <= '0';
     	wait for 10 ns;
	end process;
	
	reset_process: process
	begin        
     	rst <= '1';
   		wait for 20 ns;    
    	rst <= '0';
   		wait;
	end process;
	
	LD_process :process
	begin
     	LD <= '0';
     	wait for 200 ns;
     	LD <= '1';
     	wait for 10 ns;
	end process;

	E_process :process
	begin
     	EN <= '0';
     	wait for 40 ns;
     	EN <= '1';
     	wait for 40 ns;
	end process;

END BHV;
