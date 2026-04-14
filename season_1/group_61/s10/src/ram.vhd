library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity ram is
    generic (
        ADDR_WIDTH : natural := 8;
        DATA_WIDTH : natural := 16
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

begin

    process (clk) is
    begin
        if rising_edge(clk) then
            if we then
                ram_single_port(addr) <= data;
            end if;
        end if;
    end process;

    q <= ram_single_port(addr);

end architecture rtl;
