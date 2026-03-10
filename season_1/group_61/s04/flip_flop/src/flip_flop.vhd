library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is
	port (
		d : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		arstn : in std_logic;
		ena : in std_logic;
		rst : in std_logic;
		load : in std_logic;
		
		q : out std_logic_vector (7 downto 0)
		);
end flip_flop;

architecture rtl of flip_flop is

begin
	-- q <= d when rising_edge(clk);
	
	process (clk, arstn, ena)	
	begin
		if (arstn = '0') then
			q <= (others => '0');
		elsif (ena = '1') then
			if (rising_edge(clk)) then
				if (rst = '1') then
					q <= (others => '0');
				elsif (load = '1') then
					q <= (others => '1');
				else
					q <= d;
				end if;
			end if;
		-- else q <= 'Z';
		end if;
	end process;


end rtl;