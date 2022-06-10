library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity A_mem is
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
end A_mem;

architecture RTL of A_mem is
	type mem_array is array (0 to (2**ADDR_WIDTH) -1) of std_logic_vector (DATA_WIDTH - 1 downto 0);
	signal mem_data: mem_array :=(
	x"01", x"01", x"01", x"00", x"00",
	x"00", x"01", x"01", x"01", x"00",
	x"00", x"00", x"01", x"01", x"01",
	x"00", x"00", x"01", x"01", x"00",
	x"00", x"01", x"01", x"00", x"00",
	others => x"00"
  	); 
begin
	PROCESS(Clk, Rst) 
	begin
		if (Rst = '1') then
        	Dout <= (others=>'0');
		elsif (Clk'EVENT AND Clk = '1') then
			if (Wen = '1') then
				mem_data (to_integer (unsigned(addr))) <= Din;
			else
				if (Ren = '1') then
					Dout <= mem_data(to_integer(unsigned(Addr)));
				--else
					--Dout <= (others=>'Z');
				end if;
			end if;
		end if;
	END PROCESS;
end RTL;
