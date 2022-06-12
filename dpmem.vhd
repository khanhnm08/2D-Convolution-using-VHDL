LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY dpmem is
	generic (
    	DATA_WIDTH : integer := 8;     -- Data Width
    	DPMEM_SIZE : integer := 10      -- Address width
    );
	PORT(
		Clk, Rst : IN std_logic;
		Addr_Row, Addr_Col : IN std_logic_vector(7 downto 0);		 
		Wen, Ren: IN std_logic;
		Din : IN std_logic_vector(DATA_WIDTH-1 downto 0);
 		Dout : OUT std_logic_vector(DATA_WIDTH-1 downto 0)
	);
END dpmem; 

architecture RTL of dpmem is
 	TYPE ROW IS ARRAY(0 TO DPMEM_SIZE-1) OF std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	TYPE MATRIX IS ARRAY(0 TO DPMEM_SIZE-1) OF ROW;
	SIGNAL mat, mat_next: MATRIX;
	SIGNAL data_out, data_out_next: std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
	signal addr_row_next, addr_col_next : std_logic_vector(7 downto 0);
begin 

	-- dpmem update process
	dpmem_update:process(clk,rst)
    begin
	if (Rst = '1') then
        mat <= (OTHERS => (OTHERS => (OTHERS => '0')));
		Dout<=(OTHERS => 'X');
	elsif (Clk'EVENT AND Clk = '1') then
		mat <= mat_next;
        data_out<=data_out_next;
	end if;
    end process;
	
	-- read/write process
	read_write:process(addr_row,addr_col,Din,Ren,Wen,mat)
	begin
	mat_next <= mat;
	if (Wen = '1') then
		mat_next(to_integer(unsigned(addr_row)))(to_integer(unsigned(addr_col)))<=Din;
	elsif (Ren = '1') then
		data_out_next <= mat(0)(0);
	end if;
	end process;

END RTL;
