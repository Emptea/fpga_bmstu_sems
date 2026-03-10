library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button_decoder is
	port ( 
		clk : in  STD_LOGIC; 
		buttons : in  STD_LOGIC_VECTOR (1 downto 0);
		led_out : out  STD_LOGIC
		);
end button_decoder;

architecture rtl of button_decoder is
begin
	process (clk)		
	begin
		if (rising_edge(clk)) then
		-- 	if (buttons(1) = '0') then
		-- 		led_out <= 'Z';
		-- 	elsif (buttons(1) = '1') then
		-- 		led_out <= buttons(0);
		-- 	else
		-- 		led_out <= '0';
		-- 	end if;
			
		case? buttons is
			when "0-" => led_out <= 'Z';
			when "1-" => led_out <= buttons(0);
			when others => led_out <= '0';
		end case?;		   
		end if;
	end process;	
	
	
end rtl;