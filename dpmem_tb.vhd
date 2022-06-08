LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.myLib.ALL;
	
entity dpmem_tb is
end dpmem_tb; 

architecture BHV of dpmem_tb is
	CONSTANT clk_period: time := 10ns;
	Constant DATA_WIDTH : Integer := 8; 
	constant DPMEM_SIZE : Integer := 10;
	signal Clk, Rst, Wen, Ren : std_logic;
	signal Addr_Row, Addr_Col : std_logic_vector(7 downto 0);		
	signal Din, Dout : std_logic_vector(7 downto 0);
begin 
	DUT: dpmem 
	GENERIC MAP (DATA_WIDTH, DPMEM_SIZE)
	PORT MAP (Clk => Clk, Rst => Rst, Wen => Wen, Ren => Ren, 
				Addr_Row => Addr_Row, Addr_Col => Addr_Col, 
				Din => Din, Dout => Dout);
	 
	-- clock process
	clock_process :process
	begin
     	clk<='1';
        WAIT FOR clk_period/2;
        clk<='0';
        WAIT FOR clk_period/2;
	end process;
	
	reset_process:process    
	begin
		rst <= '1';
		WAIT FOR clk_period;
		rst <= '0';
		WAIT;
	end process;

	read_process:process
	begin
		Ren <= '1';
		WAIT FOR 3*clk_period;
		Addr_Row <=(OTHERS => '0');
		Addr_Col <=(OTHERS => '0');
		wait for 3*clk_period;
		Addr_Row <= "00000100";
		Addr_Col <= "00000100";
		wait for 3*clk_period;
		Ren <= '0';
		Addr_Row <= "00000010";
		Addr_Col <= "00000010";
		wait for 3*clk_period;
		wait;
	end process;

END BHV;
