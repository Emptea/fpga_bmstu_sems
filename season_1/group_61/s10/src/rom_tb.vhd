library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library std;
    use std.env.all;
    use work.converters.all;

entity rom_tb is
end entity rom_tb;

architecture tb of rom_tb is
    constant clk_freq   : integer := 50e6;
    constant clk_period : time    := 1000 ms / clk_freq;

    signal tb_clk  : std_logic := '1';
    signal tb_addr : natural range 0 to 255 := 0;
    signal tb_q    : std_logic_vector(7 downto 0);
begin
    tb_clk <= not tb_clk after clk_period / 2;

    ram : entity work.rom
        port map (
            clk  => tb_clk,
            addr => tb_addr,
            q    => tb_q
        );

    sim : process is
    begin
        wait for clk_period / 2;

        for i in 0 to 10 loop
            tb_addr <= i;
            wait for clk_period;
            report "addr = " & to_string(i) & "; data = 0x" & to_hstring(tb_q)
                severity warning;            
        end loop;

        report "Test Complete"
            severity warning;
        finish;
    end process;

end architecture;
