library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_types.all;

entity fir_10khz is
    port (
        clk     : in std_logic; -- тактовый сигнал
        reset_n : in std_logic; -- асинхронный сброс

        data   : in std_logic_vector(15 downto 0); -- входные данные
        result : out std_logic_vector(15 downto 0) -- выходные данные
    );
end fir_10khz;

architecture rtl of fir_10khz is
    component fir_filter is
        generic (
            taps        : natural := 10; -- количество коэффициентов
            data_width  : natural := 16; -- разрядность данных
            coeff_width : natural := 16; -- разрядность коэффициентов
            accum_width : natural := 33  -- разрядность аккумулятора
        );
        port (
            clk     : in std_logic; -- тактовый сигнал
            reset_n : in std_logic; -- асинхронный сброс

            data  : in signed(data_width - 1 downto 0); -- входные данные
            coeff : in signed_array_t(0 to taps - 1)(coeff_width - 1 downto 0);

            result : out signed(data_width - 1 downto 0) -- выходные данные
        );
    end component;

    constant coeff : signed_array_t := (
        0  => x"0151",
        1  => x"03D0",
        2  => x"FDC8",
        3  => x"FC57",
        4  => x"020C",
        5  => x"069F",
        6  => x"FD95",
        7  => x"F365",
        8  => x"029F",
        9  => x"2869",
        10 => x"3D4E",
        11 => x"2869",
        12 => x"029F",
        13 => x"F365",
        14 => x"FD95",
        15 => x"069F",
        16 => x"020C",
        17 => x"FC57",
        18 => x"FDC8",
        19 => x"03D0",
        20 => x"0151"
    );
begin
    fir1 : fir_filter
    generic map(
        taps        => coeff'length,
        data_width  => data'length,
        coeff_width => coeff(0)'length
    )
    port map(
        clk     => clk,
        reset_n => reset_n,

        data                     => signed(data),
        coeff                    => coeff,
        std_logic_vector(result) => result
    );
end rtl;
