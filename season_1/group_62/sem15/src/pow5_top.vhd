library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pow5_top is
    generic (
        IN_WIDTH  : integer := 16;
        OUT_WIDTH : integer := 18
    );
    port (
        CLOCK_50 : in std_logic;
        KEY      : in std_logic_vector(1 downto 0);

        SW   : in std_logic_vector(IN_WIDTH - 1 downto 0);
        LEDG : out std_logic_vector (0 downto 0);
        LEDR : out std_logic_vector(OUT_WIDTH - 1 downto 0)
    );
end entity;

architecture rtl of pow5_top is

begin

    pow5_inst : entity work.pow5
        generic map(IN_WIDTH => IN_WIDTH, OUT_WIDTH => OUT_WIDTH)
        port map
        (
            clk       => CLOCK_50,
            rst       => KEY(0),
            up_vld    => KEY(1),
            up_data   => SW,
            down_vld  => LEDG(0),
            down_data => LEDR
        );

end architecture;
