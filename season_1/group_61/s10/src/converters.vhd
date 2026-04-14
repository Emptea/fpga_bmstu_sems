library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package converters is
    type bcd_array_t is array (natural range <>) of unsigned(3 downto 0);

    function to_integer(value : std_logic_vector) return integer;
    function to_integer(value : std_logic) return integer;

    function to_stdlogic(value : boolean) return std_logic;

    function to_stdlogicvector(value : integer; length : integer) return std_logic_vector;
    function to_stdlogicvector(char : character) return std_logic_vector;

    alias to_std_logic is to_stdlogic[boolean return std_logic];
    alias to_sl is to_stdlogic[boolean return std_logic];
    alias to_std_logic_vector is to_stdlogicvector[integer, integer return std_logic_vector];
    alias to_slv is to_stdlogicvector[integer, integer return std_logic_vector];
    alias to_std_logic_vector is to_stdlogicvector[character return std_logic_vector];
    alias to_slv is to_stdlogicvector[character return std_logic_vector];

end package converters;

package body converters is

    function to_integer(value : std_logic_vector) return integer is
    begin
        return to_integer(unsigned(value));
    end to_integer;

    function to_integer(value : std_logic) return integer is
    begin
        if (value = '1') then
            return 1;
        else
            return 0;
        end if;
    end to_integer;

    function to_stdlogic(value : boolean) return std_logic is
    begin
        if (value) then
            return '1';
        else
            return '0';
        end if;
    end to_stdlogic;

    function to_stdlogicvector(value : integer; length : integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(value, length));
    end to_stdlogicvector;

    function to_stdlogicvector(char : character) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(character'pos(char), 8));
    end to_stdlogicvector;

end package body converters;
