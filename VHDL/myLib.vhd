LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
	
PACKAGE myLib is

-- COUNTER
COMPONENT Counter is
	PORT(
		CLk, Rst, EN, LD : IN std_logic;
 		Q : OUT std_logic_vector(7 downto 0)
	);
END COMPONENT; 

-- INPUT MEMORY
COMPONENT A_mem is
	generic(
    	DATA_WIDTH : integer := 8;     -- Word Width
    	ADDR_WIDTH : integer := 8      -- Address width
    );
	port(
		clk, rst : IN std_logic;
		Wen, Ren : IN std_logic;
		Addr : IN std_logic_vector(ADDR_WIDTH -1 downto 0);
		Din : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
		Dout : out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);
end COMPONENT;

-- KERNEL MEMORY
COMPONENT K_mem is
	generic(
    	DATA_WIDTH : integer := 8;     -- Word Width
    	ADDR_WIDTH : integer := 8      -- Address width
    );
	port(
		clk, rst : IN std_logic;
		Wen, Ren : IN std_logic;
		Addr : IN std_logic_vector(ADDR_WIDTH -1 downto 0);
		Din : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
		Dout : out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);
end COMPONENT;

-- OUTPUT MEMORY
COMPONENT B_mem is
	generic(
    	DATA_WIDTH : integer := 8;     -- Word Width
    	ADDR_WIDTH : integer := 8     -- Address width
    );
	port(
		clk, rst : IN std_logic;
		Wen, Ren : IN std_logic;
		Addr : IN std_logic_vector(ADDR_WIDTH -1 downto 0);
		Din : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
		Dout : out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);
end COMPONENT;

-- Datapath for test
COMPONENT dtp_test is
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
end COMPONENT;
	
-- Datapath
COMPONENT datapath is
	generic(
    	DATA_WIDTH : integer := 8     -- Word Width
    );
	port(
		clk, rst : IN std_logic;

		DATA_IN : IN std_logic_vector(DATA_WIDTH - 1 downto 0);
		DATA_OUT : OUT std_logic_vector(DATA_WIDTH-1 downto 0);

		WE_A, RE_A, WE_K, RE_K, WE_B, RE_B : IN std_logic;
		D_sel : IN std_logic;

		LD_br, LD_bc, LD_kr, LD_kc : IN std_logic;
		EN_br, EN_bc, EN_kr, EN_kc : IN std_logic;
		Z_br, Z_bc, Z_kr, Z_kc : OUT std_logic
	);
end COMPONENT;

-- Controller
COMPONENT controller is
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
end COMPONENT;

-- 2D Convolution module
COMPONENT Conv is
	PORT(
		Start, CLk, Rst : IN std_logic;
		PIXEL_DONE, DONE : OUT std_logic;
		DATA_IN : IN std_logic_vector(7 downto 0);
		DATA_OUT : OUT std_logic_vector(7 downto 0)
	);
END COMPONENT; 

END myLib;
