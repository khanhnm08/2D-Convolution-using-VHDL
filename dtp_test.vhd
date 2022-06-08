library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use std.textio.all;
use std.STANDARD.string;
USE work.myLib.ALL;

entity dtp_test is
	generic(
    	DATA_WIDTH : integer := 8     -- Word Width
    );
	port(
		clk, rst : IN std_logic;

		DATA_A, DATA_K : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
		DATA_OUT : OUT std_logic_vector(DATA_WIDTH-1 downto 0);

		WE_A, RE_A, WE_K, RE_K, WE_B, RE_B : IN std_logic;
		D_sel : IN std_logic;

		LD_br, LD_bc, LD_kr, LD_kc : IN std_logic;
		EN_br, EN_bc, EN_kr, EN_kc : IN std_logic;
		Z_br, Z_bc, Z_kr, Z_kc : OUT std_logic;

		MA_out, MK_out, MB_out: buffer std_logic_vector(DATA_WIDTH-1 downto 0);
		A_row_idx, A_col_idx, K_row_idx, K_col_idx, B_row_idx, B_col_idx: buffer std_logic_vector(DATA_WIDTH-1 downto 0);
		MUL_AK: buffer std_logic_vector(DATA_WIDTH-1 downto 0);
		MB_tmp, MB_in: buffer std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end dtp_test;

architecture RTL of dtp_test is
	Constant ADDR_WIDTH : integer := 8;

	signal br, bc, kr, kc: std_logic_vector(DATA_WIDTH-1 downto 0);
	--signal A_row_idx, A_col_idx, K_row_idx, K_col_idx, B_row_idx, B_col_idx: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal A_addr, K_addr, B_addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
	-- signal MA_out, MK_out, MB_out: std_logic_vector(DATA_WIDTH-1 downto 0);
	-- signal MUL_AK: std_logic_vector(DATA_WIDTH-1 downto 0);
	-- signal MB_tmp, MB_in: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal tmp, tmp1, tmp2, tmp3: std_logic_vector(15 downto 0);
begin

	-- Counter
	br_counter: Counter Port map (clk => clk, rst => rst, En => En_br, LD => LD_br, Q => br);
	bc_counter: Counter Port map (clk => clk, rst => rst, En => En_bc, LD => LD_bc, Q => bc);
	kr_counter: Counter Port map (clk => clk, rst => rst, En => En_kr, LD => LD_kr, Q => kr);
	kc_counter: Counter Port map (clk => clk, rst => rst, En => En_kc, LD => LD_kc, Q => kc);
	
	-- Compare
	z_br <= '1' when br = x"03" else '0';
	z_bc <= '1' when bc = x"03" else '0';
	z_kr <= '1' when kr = x"03" else '0';
	z_kc <= '1' when kc = x"03" else '0';
	
	-- Adder
	A_row_idx <= br + kr;
	A_col_idx <= bc + kc;	
	K_row_idx <= kr;
	K_col_idx <= kc;
	B_row_idx <= br;
	B_col_idx <= bc;
	MB_tmp <= MB_out + MUL_AK;
	
	-- Convert 2D addr to 1D addr block
	tmp1 <= (A_row_idx * x"05") + A_col_idx;   	-- 5*5 input 
	tmp2 <= (K_row_idx * x"03") + K_col_idx;	-- 3*3 kernel
	tmp3 <= (B_row_idx * x"03") + B_col_idx;	-- 3*3 output
	A_addr <= tmp1(7 downto 0);
	K_addr <= tmp2(7 downto 0);
	B_addr <= tmp3(7 downto 0);
	
	-- Mul
	tmp <= MA_OUT * MK_OUT;
	--MUL_AK <= x"00FF" when ( unsigned(tmp) > to_signed(255, 16) ) else tmp(7 downto 0);
	MUL_AK <= tmp(7 downto 0);

	-- Mux
	MB_in <= MB_tmp when D_sel = '0' else x"00";

	-- Memory
	-- A memory (input)
	MA: A_mem 
	GENERIC MAP (DATA_WIDTH, ADDR_WIDTH)
	PORT MAP (
		clk => clk,
		rst => rst,
		Wen => WE_A,
		Ren => RE_A,
		Addr => A_addr,
		Din => DATA_A,
		Dout => MA_out
	);
	-- K memory (kernel)
	MK: K_mem 
	GENERIC MAP (DATA_WIDTH, ADDR_WIDTH)
	PORT MAP (
		clk => clk,
		rst => rst,
		Wen => WE_K,
		Ren => RE_K,
		Addr => K_addr,
		Din => DATA_K,
		Dout => MK_out
	);
	-- B memory (output)
	MB: B_mem 
	GENERIC MAP (DATA_WIDTH, ADDR_WIDTH)
	PORT MAP (
		clk => clk,
		rst => rst,
		Wen => WE_B,
		Ren => RE_B,
		Addr => B_addr,
		Din => MB_in,
		Dout => MB_out
	);
	DATA_OUT <= MB_out;

end RTL;
