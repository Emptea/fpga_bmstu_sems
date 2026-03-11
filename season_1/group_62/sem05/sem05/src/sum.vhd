library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		a    : in std_logic;
		b    : in std_logic;
		c_in : in std_logic;
		
		s     : out std_logic;
		c_out : out std_logic
		);
end entity sum;

architecture rtl of sum is
begin
	
	process (clk, rst) is
		variable p, g : std_logic;
	begin
		if rst then
			s     <= '0';
			c_out <= '0';
		elsif rising_edge(clk) then
			p     := a or b;
			g     := a and b;
			s     <= p xor c_in;
			c_out <= g or (p and c_in);
		end if;
	end process;
	
end architecture rtl;
