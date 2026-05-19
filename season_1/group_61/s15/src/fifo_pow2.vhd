library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fifo_pow2 is
    generic (WIDTH : integer := 0);
    port (
        clk : in std_logic;
        rst : in std_logic;

        push : in std_logic;
        pop  : in std_logic;

        write_data : in std_logic_vector(WIDTH - 1 downto 0);
        read_data  : out std_logic_vector(WIDTH - 1 downto 0);

        empty : out std_logic;
        full  : out std_logic
    );
end entity fifo_pow2;

architecture rtl of fifo_pow2 is
    constant DEPTH : integer := 2;
    constant PTR_WIDTH : integer := integer(ceil(log2(real(DEPTH))));
    constant EXTENDED_PTR_WIDTH : integer := PTR_WIDTH + 1;

    signal wr_ptr, rd_ptr : unsigned (PTR_WIDTH - 1 downto 0);
    signal ext_wr_ptr, ext_rd_ptr : unsigned (EXTENDED_PTR_WIDTH - 1 downto 0);
    
    type mem_type is array (natural range <>) of std_logic_vector (WIDTH - 1 downto 0);
    signal data : mem_type (DEPTH - 1 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            ext_wr_ptr <= to_unsigned(0,EXTENDED_PTR_WIDTH);
        elsif rising_edge(clk) and push = '1' then
            ext_wr_ptr <= ext_wr_ptr + 1;
        end if;
    end process;

    process (clk, rst)
    begin
        if rst = '1' then
            ext_rd_ptr <= to_unsigned(0,EXTENDED_PTR_WIDTH);
        elsif rising_edge(clk) and push = '1' then
            ext_rd_ptr <= ext_rd_ptr + 1;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) and push = '1' then
            data(to_integer(wr_ptr)) <= write_data;
        end if;
    end process;

    read_data <= data(to_integer(rd_ptr));

    empty <= '1' when (ext_rd_ptr = ext_wr_ptr) else '0';
    full <= '1' when (rd_ptr = wr_ptr) and (ext_rd_ptr(ext_rd_ptr'high) = not ext_wr_ptr(ext_wr_ptr'high)) else '0';
end architecture;