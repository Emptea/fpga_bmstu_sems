library ieee;
use ieee.std_logic_1164.all;

entity uart is
	generic (
		CLK_FREQ  : positive := 50e6;
		BAUD_RATE : positive := 115200;
		OS_RATE   : positive := 16;
		D_WIDTH   : positive := 8;
		
		PARITY    : natural range 0 to 1 := 1;
		PARITY_EO : std_logic            := '1';
		
		NUM_STOP_BITS : positive range 1 to 2 := 1
		);
	port (
		clk   : in std_logic;
		reset : in std_logic;
		
		tx_req  : in std_logic;
		tx_data : in std_logic_vector(D_WIDTH - 1 downto 0);
		tx_busy : out std_logic;
		tx      : out std_logic;
		
		rx               : in std_logic;
		rx_busy          : out std_logic;
		rx_error_stopbit : out std_logic;
		rx_error_parity  : out std_logic;
		rx_not_empty     : out std_logic;
		rx_data          : out std_logic_vector(D_WIDTH - 1 downto 0)
		);
end entity uart;

architecture struct of uart is
	component uart_clk
		generic (
			CLK_FREQ  : positive := 50e6;
			BAUD_RATE : positive := 115200;
			OS_RATE   : positive := 16
			);
		port (
			clk   : in std_logic;
			reset : in std_logic;
			
			os_tick   : out std_logic := '0';
			baud_tick : out std_logic := '0'
			);
	end component;
	
	signal os_tick : std_logic;
	signal baud_clk : std_logic;
begin
	c_uart_clk:	uart_clk
	generic map(
		CLK_FREQ  => CLK_FREQ,
		BAUD_RATE => BAUD_RATE,
		OS_RATE   => OS_RATE
		)
	port map(
		clk  => clk,
		reset => reset,
		
		os_tick   => os_tick,
		baud_tick => baud_clk
		);
	
	c_uart_tx:
	entity work.uart_tx(rtl)
	generic map (
		D_WIDTH  => D_WIDTH,
		
		PARITY        => PARITY,
		PARITY_EO     => PARITY_EO,
		NUM_STOP_BITS => NUM_STOP_BITS
		)
	port map (
		clk  => clk,
		reset => reset,
		baud_tick => baud_clk,
		
		tx_req  => tx_req,
		tx_data => tx_data,
		
		busy => tx_busy,
		tx => tx
		);
	
	c_uart_rx:
	entity work.uart_rx(rtl)
	generic map (
		D_WIDTH  => D_WIDTH,
		OS_RATE   => OS_RATE,
		
		PARITY        => PARITY,
		PARITY_EO     => PARITY_EO,
		NUM_STOP_BITS => NUM_STOP_BITS
		)
	port map (
		clk  => clk,
		reset => reset,
		os_tick => os_tick,
		rx => rx,
		
		rx_not_empty  =>  rx_not_empty,
		busy          => rx_busy,
		error_stopbit =>rx_error_stopbit,
		error_parity  => rx_error_parity,
		rx_data       =>rx_data
		);	
	
end architecture struct;
