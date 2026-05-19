library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity global_stall_reg is
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
end entity global_stall_reg;

architecture rtl of global_stall_reg is

begin

    process (clk)
    begin 
        if rising_edge(clk) then
            if ((up_vld and down_rdy) = '1') then
                down_data <= up_data;
            end if;
        end if;
    end process;

    process (clk, rst)
    begin
        if rst = '1' then
            down_vld <= '0';
        elsif rising_edge(clk) then
            if down_rdy = '1' then
                down_vld <= up_vld;
            end if;
        end if;
    end process;
    up_rdy <= down_rdy;
    

end architecture;