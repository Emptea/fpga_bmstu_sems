												library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;

entity rtc_tb is
end entity rtc_tb;

architecture rtl of rtc_tb is
    constant clk_freq   : positive := 1e3;
    constant clk_period : time     := 1000 ms / clk_freq;

    signal tb_clk     : std_logic := '0';
    signal tb_rst_n   : std_logic := '0';
    signal tb_seconds : natural;
    signal tb_minutes : natural;
    signal tb_hours   : natural;

begin
    rtc1 : entity work.rtc
        generic map(
            clk_freq => clk_freq
        )
        port map(
            clk     => tb_clk,
            rst   => tb_rst_n,
            seconds => tb_seconds,
            minutes => tb_minutes,
            hours   => tb_hours
        );

    tb_clk <= not tb_clk after clk_period / 2;

    sim : process
        constant ref_time    : time := 100 sec;
        variable curent_time : time;
    begin
        tb_rst_n <= '1';
        wait for 2 * clk_period;
        tb_rst_n <= '0';
        wait for ref_time;

        curent_time := ((tb_hours * 24 + tb_minutes) * 60 + tb_seconds) * 1 sec;

        assert curent_time = ref_time
        report "RTC Time = " & to_string(curent_time, sec) &
            "; REF Time = " & to_string(ref_time, sec)
            severity error;

        report "Test Complete" severity warning;
        finish;
    end process sim;
end architecture rtl;
