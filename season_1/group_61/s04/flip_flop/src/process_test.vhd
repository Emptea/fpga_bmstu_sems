library ieee;
use ieee.std_logic_1164.all;

entity process_test is 
	port(
		clk : in std_logic
		);
end process_test;

architecture rtl of process_test is
	signal x : std_logic := '0';
	signal y : std_logic := '1';
begin
	
	process(clk)
	variable z : std_logic := '0';
	begin 
		z := not x;
		x <= z;
		z := '1';
		y <= z;
	end process;
	
	
end rtl;