library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity counter_up_down is
    generic (
        N : integer := 4
    );
    port (
        rst  : in std_logic;
        clk1 : in std_logic;
        clk2 : in std_logic;

        cnt : buffer unsigned(N - 1 downto 0);

        n_sum : in positive range 1 to N;
        sum   : out natural range 0 to N
    );
end entity counter_up_down;

architecture rtl of counter_up_down is
begin

    process (clk1, clk2, rst) is
    begin
        if rst then
            cnt <= (others => '0');
        else
            if rising_edge(clk1) then
                cnt <= cnt + '1';
            end if;
            if rising_edge(clk2) then
                cnt <= cnt - '1';
            end if;
        end if;
    end process;

    process (cnt, n_sum) is
        function to_integer (val: std_logic) return integer is
        begin
            if val then
                return 1;
            else
                return 0;
            end if;
        end function;

        function check_sum_calc (buf : unsigned; n_sum : natural) return natural is
            variable sum : natural range 0 to N := 0;
        begin
            for i in 0 to n_sum - 1 loop
                sum := sum + to_integer(buf(i));
            end loop;
            return sum;
        end function;

    begin
        sum <= check_sum_calc(cnt, n_sum);
    end process;

end architecture rtl;
