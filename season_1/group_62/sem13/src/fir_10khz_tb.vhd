library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;

use std.env.all;
use std.textio.all;

entity fir_10khz_tb is
end entity fir_10khz_tb;

architecture tb of fir_10khz_tb is
    constant clk_freq   : integer := 50e6;
    constant clk_period : time    := 1000 ms / clk_freq;

    signal tb_clk     : std_logic := '0';
    signal tb_reset : std_logic := '1';

    signal tb_data_in  : std_logic_vector(15 downto 0) := (others => '0');    
    signal tb_data_out : std_logic_vector(15 downto 0) := (others => '0');
    
begin

    tb_clk <= not tb_clk after clk_period / 2;

    fir_10khz_inst : entity work.fir_10khz
        port map(
            clk     => tb_clk,
            rst => tb_reset,
            data    => tb_data_in,
            result  => tb_data_out
        );    

    sim : process  
	    file file_in  : text open read_mode is "sin.txt";
        file file_out : text open write_mode is "sin_out.txt";

        variable line_in  : line;
        variable line_out : line;
		
		variable sample_in  : std_logic_vector(15 downto 0);
        variable sample_out : std_logic_vector(15 downto 0);
    begin
        tb_reset <= '1';        
        wait for 2 * clk_period;
        tb_reset <= '0';
        wait for 2 * clk_period;
		
		while not endfile(file_in) loop
			readline(file_in, line_in);
			hread(line_in, sample_in);
			
			tb_data_in <= sample_in;			
			wait until rising_edge(tb_clk);
			sample_out := tb_data_out;
			
			hwrite(line_out, sample_out);
			writeline(file_out, line_out);			
		end loop;
        finish;
    end process;
end architecture tb;
