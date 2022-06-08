LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
USE work.myLib.ALL;
	
ENTITY Conv is
	PORT(
		Start, CLk, Rst : IN std_logic;
		PIXEL_DONE, DONE : OUT std_logic;
		DATA_A, DATA_K : IN std_logic_vector(7 downto 0);
		DATA_OUT : OUT std_logic_vector(7 downto 0)
	);
END Conv; 

architecture RTL of Conv is
	Constant DATA_WIDTH : Integer := 8; 
	signal LD_br, LD_bc, LD_kr, LD_kc : std_logic;
	signal EN_br, EN_bc, EN_kr, EN_kc : std_logic;
	signal Z_br, Z_bc, Z_kr, Z_kc : std_logic;
	signal WE_A, RE_A, WE_K, RE_K, WE_B, RE_B : std_logic;
	signal D_sel : std_logic;
begin 
	U1: controller
	PORT MAP(
		clk, rst,
		start,
		LD_br, LD_bc, LD_kr, LD_kc,
		EN_br, EN_bc, EN_kr, EN_kc,
		Z_br, Z_bc, Z_kr, Z_kc,
		WE_A, RE_A, WE_K, RE_K, WE_B, RE_B,
		D_sel,
		PIXEL_DONE, DONE
	);
	
	U2: datapath
	GENERIC MAP (DATA_WIDTH)
	PORT MAP (
		clk, rst,

		DATA_A, DATA_K,
		DATA_OUT,

		WE_A, RE_A, WE_K, RE_K, WE_B, RE_B,
		D_sel,

		LD_br, LD_bc, LD_kr, LD_kc,
		EN_br, EN_bc, EN_kr, EN_kc,
		Z_br, Z_bc, Z_kr, Z_kc
	);

end RTL;
