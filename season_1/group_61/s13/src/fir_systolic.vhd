library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.fir_pkg.all;

entity fir_systolic is
    generic (
        N : positive := 8;
        W : positive := 16
    );
    port (
        clk : in    std_logic;
        rst : in    std_logic;

        din   : in    signed(W - 1 downto 0);
        coeff : in    signed_array_t(N - 1 downto 0)(W - 1 downto 0);
        dout  : out   signed(W - 1 downto 0)
    );
end entity;

architecture rtl of fir_systolic is
    constant ACCUM_W : natural := 2 * W + log2(N);

    signal data_pipe  : signed_array_t(N - 1 downto 0)(W - 1 downto 0);
    signal accum_pipe : signed_array_t(N - 1 downto 0)(ACCUM_W - 1 downto 0);

-- attribute multstyle : string;
-- attribute multstyle of products : signal is "dsp";
begin

    dout <= accum_pipe(N - 1)(ACCUM_W - 1 downto ACCUM_W - W);

    cells : for i in 0 to N - 1 generate

        s : if i = 0 generate

            fir_systolic_cell_inst : fir_systolic_cell
                generic map (
                    W     => W,
                    ACC_W => ACCUM_W
                )
                port map (
                    clk       => clk,
                    rst       => rst,
                    din       => din,
                    coeff     => coeff(i),
                    accum_in  => (others => '0'),
                    pipe_out  => data_pipe(i),
                    accum_out => accum_pipe(i)
                );

        else generate

            fir_systolic_cell_inst : fir_systolic_cell
                generic map (
                    W     => W,
                    ACC_W => ACCUM_W
                )
                port map (
                    clk       => clk,
                    rst       => rst,
                    din       => data_pipe(i - 1),
                    coeff     => coeff(i),
                    accum_in  => accum_pipe(i - 1),
                    pipe_out  => data_pipe(i),
                    accum_out => accum_pipe(i)
                );

        end generate;

    end generate;

end architecture;
    