library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.myLib.ALL;

entity mem_tb is
end mem_tb; 

architecture BHV of mem_tb is
	CONSTANT clk_period: time := 10ns;
	Constant DATA_WIDTH : Integer := 8; 
	Constant ADDR_WIDTH : integer := 8;
	Signal clk, rst : std_logic;
	Signal Wen, Ren : std_logic;	
	Signal Addr : std_logic_vector(ADDR_WIDTH -1 downto 0);
	Signal Din : std_logic_vector(DATA_WIDTH - 1 downto 0);
	Signal Dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
begin 	
	DUT: A_mem
	GENERIC MAP ( DATA_WIDTH, ADDR_WIDTH)
	PORT MAP (clk, rst, Wen, Ren, Addr, Din, Dout);

	-- clock
	lock_process :process
	begin
     	clk <= '1';
     	wait for clk_period/2;
     	clk <= '0';
     	wait for clk_period/2;
	end process;

	-- reset
	reset_process: process
	begin        
     	rst <= '1';
   		wait for 2*clk_period;    
    	rst <= '0';
   		wait;
	end process;

	Stimulus: process
	begin
	Ren <= '1';	
	Addr <= x"00";
	wait for 3*clk_period;
	Addr <= x"06";
	wait for 3*clk_period;
	Ren <= '0';
	Addr <= x"00";
	Wen <= '1';
	Din <= x"02";
	wait for clk_period;
	Wen <= '0';
	Ren <= '1';
	Addr <= x"00";
	wait for 2*clk_period;
	Ren <= '0';
	wait;
	end process;
	
END BHV;
