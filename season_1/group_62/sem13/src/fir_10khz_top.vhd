library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity fir_10khz_top is
    port (
        CLOCK_50 : in    std_logic;
        KEY      : in    std_logic_vector(0 downto 0);

        SW   : in    std_logic_vector(15 downto 0);
        LEDR : out   std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of fir_10khz_top is
begin

    top : entity work.fir_10khz
        port map (
            clk => CLOCK_50,
            rst => KEY(0),

            data   => SW(15 downto 0),
            result => LEDR(15 downto 0)
        );

end architecture;
