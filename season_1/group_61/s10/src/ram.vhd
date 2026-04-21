library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity ram is
    generic (
        ADDR_WIDTH : natural := 8;
        DATA_WIDTH : natural := 8
    );
    port (
        clk  : in std_logic;
        addr : in natural range 0 to 2 ** ADDR_WIDTH;
        data : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        we   : in std_logic;
        q    : out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity ram;

architecture rtl of ram is
    type   ram_t is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal ram_single_port : ram_t := (others => (others => '0'));
    attribute ram_init_file : string;
    attribute ram_init_file of ram_single_port : signal is "LedBlink8.mif";
	 attribute ramstyle : string;
	 attribute ramstyle of ram_single_port: signal is "M4K";
	 
	 component ram_ip
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;
begin

--    process (clk) is
--    begin
--        if rising_edge(clk) then
--            if we then
--                ram_single_port(addr) <= data;
--            end if;
--				q <= ram_single_port(addr);
--        end if;
--    end process;

	ram_ip_inst : ram_ip PORT MAP (
			address	 => STD_LOGIC_VECTOR(to_unsigned(addr, DATA_WIDTH)),
			clock	 => clk,
			data	 => data,
			wren	 => we,
			q	 => q
		);

    

end architecture rtl;
