library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE work.myLib.ALL;

entity controller is
	PORT (
		clk, rst : IN std_logic;
		start : IN std_logic;
		LD_br, LD_bc, LD_kr, LD_kc : OUT std_logic;
		EN_br, EN_bc, EN_kr, EN_kc : OUT std_logic;
		Z_br, Z_bc, Z_kr, Z_kc : IN std_logic;
		WE_A, RE_A, WE_K, RE_K, WE_B, RE_B : OUT std_logic;
		D_sel : OUT std_logic;
		PIXEL_DONE, DONE : OUT std_logic
	);
end controller;

architecture RTL of controller is
	type State_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16);
	Signal state : State_type;
begin
	
	process(clk, rst)
	begin
	if (rst = '1') then
		state <= S0;
	elsif (clk'EVENT and clk ='1') then
		Case state is
			When S0 =>
				state <= S1;
			When S1 =>
				if (start = '1') then
					state <= S2;
				else 
					state <= S1;
				end if;
			When S2 =>
				if (Z_br = '0') then
					state <= S3;
				else
					state <= S15;
				end if;
			When S3 =>
				if (Z_bc = '0') then
					state <= S4;
				else
					state <= S14;
				end if;
			When S4 =>
				if (Z_kr = '0') then
					state <= S5;
				else
					state <= S11;
				end if;
			When S5 =>
				if (Z_kc = '0') then
					state <= S6;
				else
					state <= S10;
				end if;
			When S6 =>
				state <= S7;
			When S7 =>
				state <= S8;
			When S8 =>
				state <= S9;
			When S9 =>
				state <= S5;
			When S10 =>
				state <= S4;
			When S11 =>
				state <= S12;
			When S12 =>
				state <= S13;
			When S13 =>
				state <= S3;
			When S14 =>
				state <= S2;
			When S15 =>
				state <= S16;
			When S16 =>
				if (start = '0') then
					state <= S0;
				else
					state <= S16;
				end if;
		end case;
	end if;
	end process;
	
	-- Combinaticnal Logic 
	WE_A <= '0';
	WE_K <= '0';

	RE_A <= '1' when state = S6 else '0';
	RE_K <= '1' when state = S6 else '0';
	WE_B <= '1' when (state = S7 or state = S12) else '0';
	RE_B <= '1' when (state = S8 or state = S13) else '0';

	LD_br <= '1' when state = S0 else '0';
	LD_bc <= '1' when (state = S0 or state = S14) else '0';
	LD_kr <= '1' when (state = S0 or state = S11) else '0';
	LD_kc <= '1' when (state = S0 or state = S10) else '0';

	EN_br <= '1' when state = S14 else '0';
	EN_bc <= '1' when state = S11 else '0';
	EN_kr <= '1' when state = S10 else '0';
	EN_kc <= '1' when state = S9 else '0';
	
	D_sel <= '1' when state = S12 else '0';

	PIXEL_DONE <= '1' when state = S11 else '0';
	DONE <= '1' when state = S15 else '0';
end RTL;
