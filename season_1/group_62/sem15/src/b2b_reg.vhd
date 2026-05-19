library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity b2b_reg is
    generic (WIDTH : integer := 0);
    port (
        clk : in std_logic;
        rst : in std_logic;

        up_vld  : in std_logic;
        up_rdy  : out std_logic;
        up_data : in std_logic_vector (WIDTH - 1 downto 0);

        down_vld  : out std_logic;
        down_rdy  : in std_logic;
        down_data : out std_logic_vector (WIDTH - 1 downto 0)

    );
end entity b2b_reg;

architecture rtl of b2b_reg is
signal or_out : std_logic;
signal buf_vld : std_logic := '0';
begin

    process (clk)
    begin 
        if rising_edge(clk) then
            if or_out = '1' then
                down_data <= up_data;
            end if;
        end if;
    end process;

    process (clk, rst)
    begin
        if rst = '1' then
            buf_vld <= '0';
        elsif rising_edge(clk) then
            if or_out = '1' then
                buf_vld <= up_vld;
            end if;
        end if;
    end process;
    or_out <= (not buf_vld) or down_rdy;
    up_rdy <= or_out;
	down_vld <= buf_vld;

end architecture;