library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE work.myLib.ALL;

entity Conv_tb is
end Conv_tb; 

architecture BHV of Conv_tb is
	CONSTANT clk_period: time := 10ns;
	Constant DATA_WIDTH : Integer := 8; 
	Constant ADDR_WIDTH : integer := 8;

	Signal start, clk, rst : std_logic;
	Signal DATA_IN : std_logic_vector(DATA_WIDTH - 1 downto 0);
	Signal DATA_OUT : std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal PIXEL_DONE, DONE : std_logic;
begin 	
	
	DUT: Conv
	port map(
		Start, CLk, Rst,
		PIXEL_DONE, DONE,
		DATA_IN,
		DATA_OUT
	);
	
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
	
	-- start 
	start_process: process
	begin        
     	start <= '0';
   		wait for 3*clk_period;    
    	start <= '1';
   		wait;
	end process;
	
END BHV;
