library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sum_tb is
end sum_tb;

architecture tb of sum_tb is
	constant CLK_PERIOD : time := 10 ns;
	
	signal clk : std_logic := '0';
	signal rst : std_logic;
	
	signal a    : std_logic;
	signal b    : std_logic;
	signal c_in : std_logic;
	
	signal s     : std_logic;
	signal c_out : std_logic;
	
	type test_vec_t is array(natural range <>) of std_logic_vector(4 downto 0);
	constant test_vec : test_vec_t := (
	-- a b c_in  s c_out
	b"000_00",
	b"001_10",
	b"010_10",
	b"011_01",
	b"100_10",
	b"101_01",
	b"110_01",
	b"111_11"
	);
begin	
	DUT:
	entity work.sum(rtl)
	port map(
		clk => clk,
		rst => rst,
		a => a,
		b => b,
		c_in => c_in,
		s => s,
		c_out => c_out
		);
	
	clk <= not clk after CLK_PERIOD/2;
	
	sim: process 	
	begin
		rst <= '0';
		wait for CLK_PERIOD;
		rst <= '1';
		wait for CLK_PERIOD;
		rst <= '0';
		
		for i in 0 to test_vec'length - 1 loop
			(a, b, c_in) <= test_vec(i)(4 downto 2);
			wait for 2*CLK_PERIOD;
			assert (s, c_out) = test_vec(i)( 1 downto 0)
			report "in: " & to_string(test_vec(i)(4 downto 2))
			& " out: " & to_string(s) & to_string(c_in)
			& " expected : " & to_string(test_vec(i)( 1 downto 0));
		end loop;
		
		wait for 10*CLK_PERIOD;
		std.env.finish(2);
	end process;
	
end tb;