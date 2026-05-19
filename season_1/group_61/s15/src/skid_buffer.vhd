library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity skid_buffer is
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
end entity skid_buffer;

architecture rtl of skid_buffer is
    signal buf_data : std_logic_vector (WIDTH - 1 downto 0);
    signal buf_vld : std_logic;
	signal buf_rdy : std_logic;
begin

    process (clk, rst)
    begin
        if rst = '1' then
            buf_vld  <= '0';
            down_vld <= '0';
            up_rdy   <= '1';
        elsif rising_edge(clk) then
            if (buf_rdy = '1' and down_rdy = '0') then
                buf_vld <= up_vld;
            end if;
            if (down_rdy = '1') then
                if (buf_rdy = '1') then
                    down_vld <= up_vld;
                else
                    down_vld <= buf_vld;
                end if;
            end if;
            buf_rdy <= down_rdy;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if (buf_rdy = '1' and down_rdy = '0') then
                buf_data <= up_data;
            end if;
            if (down_rdy = '1') then
                if (buf_rdy = '1') then
                    down_data <= up_data;
                else
                    down_data <= buf_data;
                end if;
            end if;
        end if;
    end process;
	up_rdy <= buf_rdy;

end architecture;