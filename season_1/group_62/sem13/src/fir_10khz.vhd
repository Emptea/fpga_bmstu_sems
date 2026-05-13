library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.fir_pkg.all;

entity fir_10khz is
    port (
        clk : in    std_logic;
        rst : in    std_logic;

        data   : in    std_logic_vector(15 downto 0);
        result : out   std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of fir_10khz is
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

    fir_inst : fir
        generic map (
            N => COEFF'length,
            W => data'length
        )
        port map (
            clk => clk,
            rst => rst,

            din                    => signed(data),
            coeff                  => COEFF,
            std_logic_vector(dout) => result
        );

end architecture;
