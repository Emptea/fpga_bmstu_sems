-------------------------------------------------------------------------------
--
-- Title       : logic_function2
-- Design      : sem02
-- Author      : Emptea
-- Company     : BMSTU
--
-------------------------------------------------------------------------------
--
-- File        : f:/work/hdl/sem02/src/logic_function2.vhd
-- Generated   : Wed Feb 18 11:01:23 2026
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
		x : in STD_LOGIC_VECTOR(3 downto 0);
		y : out STD_LOGIC_VECTOR(2 downto 0)
	);
end logic_function2;

--}} End of automatically maintained section

architecture logic_function2 of logic_function2 is
begin
   y(0) <= not x(2);
   y(1) <= x(0) or ((x(1) and x(2)) xor x(3));
   y(2) <= and x;

end logic_function2;

