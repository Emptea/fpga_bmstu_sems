library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rtc is
  generic (
    clk_freq : natural --system clock frequency in hz
  );
  port (
    clk : in std_logic;
    rst : in std_logic;

    seconds : out natural range 0 to 59 := 0;
    minutes : out natural range 0 to 59 := 0;
    hours   : out natural range 0 to 23 := 0
  );
end entity rtc;

architecture rtl of rtc is
  signal ticks : natural;
  procedure counter (
    constant en   : in std_logic;
    constant max  : in natural;
    signal cnt  : inout natural;
    variable wrap : out std_logic
  ) is
  begin
    if en = '1' then
      cnt <= cnt + 1;
      if cnt = max - 1 then
        cnt  <= 0;
        wrap := '1';
      else
        wrap := '0';
      end if;
    end if;
  end procedure counter;
begin
  process (clk, rst)
    variable wrap_secs  : std_logic;
    variable wrap_mins  : std_logic;
    variable wrap_hours : std_logic;
    variable wrap       : std_logic;
  begin
    if rst then
      seconds <= 0;
      minutes <= 0;
      hours   <= 0;
      ticks   <= 0;
    elsif rising_edge(clk) then
      counter('1', clk_freq, ticks, wrap_secs);
      counter(wrap_secs, 60, seconds, wrap_mins);
      counter(wrap_mins, 60, minutes, wrap_hours);
      counter(wrap_hours, 24, hours, wrap);
    end if;
  end process;
end architecture rtl;
