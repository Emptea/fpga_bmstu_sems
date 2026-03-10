library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port (
    c : in std_logic;
    b : in std_logic;
    a : out std_logic_vector (2 downto 0)

  );
end entity;

architecture rtl of mux is

begin
  a <=
    "001" when b and c else -- bc = 11
    "010" when not b and c else -- bc = 01
    "101" when b and not c else -- bc = 10
    "111" when not b and not c else -- bc = 00
    "XXX";
end architecture;