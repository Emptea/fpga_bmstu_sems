library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rtc is
  generic (
    clk_freq : natural --system clock frequency in hz
  );
  port (
    clk    : in std_logic;
    arst_n : in std_logic;

    seconds : out natural range 0 to 59 := 0;
    minutes : out natural range 0 to 59 := 0;
    hours   : out natural range 0 to 23 := 0
  );
end entity rtc;

architecture rtl of rtc is
  signal ticks : natural;
  procedure counter (
    constant en    : in boolean;
    constant max : in natural;
    signal cnt   : inout natural;
    variable wrap  : out boolean
  ) is
  begin
    if en = true then
      if cnt = max - 1 then
        cnt <= 0;
        wrap := true;
      else
        cnt <= cnt + 1;
        wrap := false;
      end if;
    end if;

  end procedure counter;
begin
  process (clk, arst_n)
    variable wrap : boolean := false;
  begin
    if arst_n = '0' then
      seconds <= 0;
      minutes <= 0;
      hours   <= 0;
      ticks   <= 0;
    elsif rising_edge(clk) then
      counter(true, clk_freq, ticks, wrap);
      counter(wrap, 60, seconds, wrap);
      counter(wrap, 60, minutes, wrap);
      counter(wrap, 24, hours, wrap);
    end if;
  end process;
end architecture rtl;
