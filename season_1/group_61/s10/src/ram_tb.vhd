library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

library std;
    use std.env.all;
    use work.converters.all;

entity ram_tb is
end entity ram_tb;

architecture tb of ram_tb is
    constant clk_freq   : integer := 50e6;
    constant clk_period : time    := 1000 ms / clk_freq;

    signal tb_clk  : std_logic := '1';
    signal tb_addr : natural range 0 to 2 ** 8 - 1 := 0;
    signal tb_data : std_logic_vector(8 - 1 downto 0) := (others => '0');
    signal tb_we   : std_logic;
    signal tb_q    : std_logic_vector(8 - 1 downto 0);
begin
    tb_clk <= not tb_clk after clk_period / 2;

    ram : entity work.ram
        generic map (
            addr_width => 8,
            data_width => 8
        )
        port map (
            clk  => tb_clk,
            addr => tb_addr,
            data => tb_data,
            we   => tb_we,
            q    => tb_q
        );

    sim : process is
    begin
        tb_we <= '1';
        wait for clk_period;

        for i in 0 to 255 loop
            tb_addr <= i;
            tb_data <= to_slv(i, tb_data'length);
            wait for clk_period;
        end loop;

        tb_we <= '0';
        wait for clk_period;

        for i in 0 to 255 loop
            tb_addr <= i;
            wait for clk_period;
            assert tb_q = to_slv(i, tb_data'length)
                report "Error addr = " & to_string(i) & "; data = " & to_string(tb_q)
                severity error;
        end loop;

        report "Test Complete"
            severity warning;
        finish;
    end process;

end architecture;
