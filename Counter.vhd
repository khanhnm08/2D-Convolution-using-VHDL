LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
	
ENTITY Counter is
	PORT(
		Clk, Rst, EN, LD : IN std_logic;
 		Q : OUT std_logic_vector(7 downto 0)
	);
END Counter; 

architecture RTL of Counter is
	SIGNAL Count : std_logic_vector(7 downto 0);
begin 
	PROCESS(Clk, Rst) begin
		if (Rst = '1') then
        	Count <= (others=>'0');
		elsif (Clk'EVENT AND Clk = '1') then
			if (LD = '1') then
				Count <= (others=>'0');
            elsif (EN = '1') then
                Count <= Count + 1;
            end if;
		end if;
	END PROCESS;
	Q <= Count ;
END RTL;
