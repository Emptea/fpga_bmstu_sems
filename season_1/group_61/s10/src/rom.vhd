library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity rom is
    port (
        clk  : in    std_logic;
        addr : in    natural range 0 to 255;
        q    : out   std_logic_vector(7 downto 0)
    );
end entity rom;

architecture rtl of rom is
    type rom_t is array (0 to 255) of std_logic_vector(7 downto 0);
    constant rom_single_port : rom_t := (
        x"0C", x"94", x"2A", x"00", x"0C", x"94", x"3F", x"00", x"0C",
        x"94", x"41", x"00", x"0C", x"94", x"4E", x"00", x"0C", x"94",
        x"3F", x"00", x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F",
        x"00", x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F", x"00",
        x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F", x"00", x"0C",
        x"94", x"3F", x"00", x"0C", x"94", x"3F", x"00", x"0C", x"94",
        x"3F", x"00", x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F",
        x"00", x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F", x"00",
        x"0C", x"94", x"3F", x"00", x"0C", x"94", x"3F", x"00", x"0C",
        x"94", x"3F", x"00", x"11", x"24", x"1F", x"BE", x"CF", x"E5",
        x"D4", x"E0", x"DE", x"BF", x"CD", x"BF", x"10", x"E0", x"A0",
        x"E6", x"B0", x"E0", x"EA", x"EC", x"F0", x"E0", x"02", x"C0",
        x"05", x"90", x"0D", x"92", x"A4", x"36", x"B1", x"07", x"D9",
        x"F7", x"0E", x"94", x"58", x"00", x"0C", x"94", x"63", x"00",
        x"0C", x"94", x"00", x"00", x"8F", x"93", x"8F", x"B7", x"8F",
        x"93", x"9F", x"93", x"85", x"B3", x"91", x"E0", x"89", x"27",
        x"85", x"BB", x"9F", x"91", x"8F", x"91", x"8F", x"BF", x"8F",
        x"91", x"18", x"95", x"18", x"95", x"B8", x"9A", x"89", x"B7",
        x"83", x"60", x"89", x"BF", x"8F", x"EF", x"8C", x"BF", x"81",
        x"E6", x"83", x"BF", x"08", x"95", x"80", x"E6", x"87", x"BB",
        x"88", x"B3", x"8F", x"79", x"88", x"BB", x"80", x"E6", x"90",
        x"E0", x"EF", x"DF", x"C5", x"9A", x"C5", x"98", x"FD", x"CF",
        x"F8", x"94", x"FF", x"CF", x"64", x"66", x"00", x"00",
        others => x"00"
        );
begin

    process (clk) is
    begin
        if rising_edge(clk) then
            q <= rom_single_port(addr);
        end if;
    end process;

end architecture;
