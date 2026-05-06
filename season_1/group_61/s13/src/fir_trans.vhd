library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.fir_pkg.all;

entity fir_trans is
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

architecture rtl of fir_trans is
    constant ACCUM_W : natural := 2 * W + log2(N);

    signal data_pipeline : signed_array_t(N - 1 downto 0)(ACCUM_W - 1 downto 0);

-- attribute multstyle : string;
-- attribute multstyle of products : signal is "dsp";
begin

    dout <= data_pipeline(0)(ACCUM_W - 1 downto ACCUM_W - W);

    cells : for i in 0 to N - 1 generate

        s : if i = N - 1 generate

            fir_trans_cell_inst : fir_trans_cell
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
                    accum_out => data_pipeline(i)
                );

        else generate

            fir_trans_cell_inst : fir_trans_cell
                generic map (
                    W     => W,
                    ACC_W => ACCUM_W
                )
                port map (
                    clk       => clk,
                    rst       => rst,
                    din       => din,
                    coeff     => coeff(i),
                    accum_in  => data_pipeline(i + 1),
                    accum_out => data_pipeline(i)
                );

        end generate;

    end generate;

end architecture;
