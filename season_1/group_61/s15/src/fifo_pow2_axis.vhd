library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fifo_pow2_axis is
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
end entity fifo_pow2_axis;

architecture rtl of fifo_pow2_axis is

begin
    --  TODO реализуйте обертку для fifo_pow2, чтобы оно работало по протоколу valid-ready

    fifo_pow2_inst : entity work.fifo_pow2
        generic map(
            WIDTH => WIDTH
        )
        port map
        (
            clk        => clk,
            rst        => rst,
            push       => ?,
            pop        => ?,
            write_data => ?,
            read_data  => ?,
            empty      => ?,
            full       => ?
        );

end architecture;