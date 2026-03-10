-------------------------------------------------------------------------------
--
-- Title       : logic_function2
-- Design      : logic_function2
-- Author      : Emptea
-- Company     : BMSTU
--
-------------------------------------------------------------------------------
--
-- File        : f:/work/hdl/s02/logic_function2/src/logic_function2.vhd
-- Generated   : Wed Feb 18 15:19:32 2026
-- From        : Interface description file
-- By          : ItfToHdl ver. 1.0
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--    and may be overwritten
--{entity {logic_function2} architecture {logic_function2}}

library IEEE;
use IEEE.std_logic_1164.all;

entity logic_function2 is
	port(
		x : in STD_LOGIC_VECTOR(4 downto 0);
		y : out STD_LOGIC_VECTOR(4 downto 0)
	);
end logic_function2;

--}} End of automatically maintained section

architecture logic_function2 of logic_function2 is
begin
	y(0) <= and x;
	y(1) <= x(0) xor x(1);
	y(4 downto 2) <= (x(3) and x(2)) & (x(4)) & (x(1) or x(0));

	-- Enter your statements here --

end logic_function2;
