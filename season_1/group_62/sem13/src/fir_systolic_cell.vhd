library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.fir_pkg.all;

entity fir_systolic_cell is
    generic (
        W     : positive := 16;
        W_COEFF : positive := 16;
        ACC_W : positive := 16
    );
    port (
        clk       : in    std_logic;
        rst       : in    std_logic;
        din       : in    signed(W - 1 downto 0);
        coeff     : in    signed(W_COEFF - 1 downto 0);
        accum_in  : in    signed(ACC_W - 1 downto 0);
        pipe_out  : out   signed(W - 1 downto 0);
        accum_out : out   signed(ACC_W - 1 downto 0)
    );
end entity;

architecture rtl of fir_systolic_cell is
    signal d_reg     : signed_array_t(1 downto 0)(W - 1 downto 0);
    signal coeff_reg : signed(W_COEFF - 1 downto 0);
    signal prod_reg  : signed(W_COEFF + W - 1 downto 0);
    signal accum_reg : signed(ACC_W - 1 downto 0);
begin

    accum_out <= accum_reg;
    pipe_out  <= d_reg(1);

    process (clk, rst)
    begin
        if rst then
            d_reg     <= (others => (others => '0'));
            coeff_reg <= (others => '0');
            prod_reg  <= (others => '0');
            accum_reg <= (others => '0');
        elsif rising_edge(clk) then
            d_reg     <= d_reg(0) & din;
            coeff_reg <= coeff;
            prod_reg  <= d_reg(1) * coeff_reg;
            accum_reg <= accum_in + prod_reg;
        end if;
    end process;

end architecture;
