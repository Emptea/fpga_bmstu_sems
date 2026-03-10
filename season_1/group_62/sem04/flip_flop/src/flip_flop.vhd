library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop is
	port(
		clk : in std_logic;
		en : in std_logic;
		aresetn : in std_logic;
		
		load : in std_logic;
		rst : in std_logic;
		
		d: in std_logic_vector (7 downto 0);
		
		q: out std_logic_vector (7 downto 0)
		);
	
end flip_flop;


architecture flip_flop of flip_flop is
begin
--	process (clk, en, aresetn) 
--	begin
--		if (aresetn = '0') then
--			q <= (others => '0');
--		elsif (clk'event and clk = '1' and en = '1') then
--			-- rising_edge(clk)
--			if (rst = '1') then
--				q <= (others => '0');
--			elsif (load = '1') then
--				q <= (others => '1');
--			else
--				q <= d;
--			end if;
--		end if;
--		
--	end process;	
--	
	process (clk)  
	begin
		if (clk'event and clk = '1') then
			-- rising_edge(clk)
			q <= d;			
		end if;		
	end process;
	
	process 
	begin
		wait until (clk'event and clk = '1');
		-- rising_edge(clk)
		q <= d;					
	end process;
	process
	begin
		wait on clk;
		wait for 1 ns;
		q <= d;
		
	end process;
	
	
end flip_flop;
