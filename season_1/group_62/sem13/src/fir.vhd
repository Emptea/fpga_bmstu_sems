library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.fir_pkg.all;

entity fir is
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

architecture rtl of fir is
    constant ACCUM_W : natural := 2 * W + log2(N);

    signal data_pipeline : signed_array_t(N - 1 downto 0)(W - 1 downto 0);
    signal products      : signed_array_t(N - 1 downto 0)(2 * W - 1 downto 0);

    -- attribute multstyle : string;
    -- attribute multstyle of products : signal is "dsp";
begin

    process (clk, rst)
        variable accum : signed(ACCUM_W - 1 downto 0);
    begin
        if rst then
            data_pipeline <= (others => (others => '0'));
            dout          <= (others => '0');

            accum := (others => '0');
        elsif rising_edge(clk) then
            data_pipeline <= data_pipeline(N - 2 downto 0) & din;

            for i in 0 to N - 1 loop
                products(i) <= data_pipeline(i) * coeff(i);
            end loop;

            accum := (others => '0');
            for i in 0 to N - 1 loop
                accum := accum + products(i);
            end loop;            
            
            dout <= accum(accum'length - 1 downto accum'length - W);
        end if;
    end process;

    -- product_calc : for i in 0 to N - 1 generate
    --     products(i) <= data_pipeline(i) * coeff(i);
    -- end generate;

end architecture;
