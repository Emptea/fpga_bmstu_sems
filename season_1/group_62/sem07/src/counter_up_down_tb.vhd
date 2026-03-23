library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.numeric_std_unsigned.all;

entity conter_up_down_tb is
end entity conter_up_down_tb;

architecture tb of conter_up_down_tb is
    constant CLK_FREQ   : integer := 50e6;
    constant CLK_PERIOD : time    := 1000 ms / CLK_FREQ;

    constant N       : integer   := 8;
    signal   clk1_en : std_logic := '0';
    signal   clk2_en : std_logic := '0';

    signal tb_rst  : std_logic := '0';
    signal tb_clk1 : std_logic := '0';
    signal tb_clk2 : std_logic := '0';

    signal tb_cnt : unsigned(N - 1 downto 0) := (others => '0');

    signal tb_n_sum : positive range 1 to N;
    signal tb_sum : natural range 0 to N;
    
    signal tb_sum_ref : natural range 0 to N;

begin

    counter : entity work.counter_up_down
        generic map (
            n => N
        )
        port map (
            rst  => tb_rst,
            clk1 => tb_clk1,
            clk2 => tb_clk2,
            cnt  => tb_cnt,

            n_sum => tb_n_sum,
            sum   => tb_sum
        );

    tb_clk1 <= not tb_clk1 after CLK_PERIOD / 2 when clk1_en else
               '0';
    tb_clk2 <= not tb_clk2 after CLK_PERIOD / 2 when clk2_en else
               '0';

    sim : process is
        constant UP_TIME   : time := 1000 ns;
        constant DOWN_TIME : time := 500 ns;

        variable ref_cnt : integer := 0;
    begin
        tb_rst <= '1';
        wait for 2 * CLK_PERIOD;
        tb_rst <= '0';

        clk1_en <= '1';
        wait for UP_TIME;
        clk1_en <= '0';

        wait for 2 * CLK_PERIOD;

        clk2_en <= '1';
        wait for DOWN_TIME;
        clk2_en <= '0';

        wait for 2 * CLK_PERIOD;

        ref_cnt := UP_TIME / CLK_PERIOD - DOWN_TIME / CLK_PERIOD;
        if tb_cnt = to_unsigned(ref_cnt, tb_cnt'length) then
            report "Cnt = " & to_string(to_integer(tb_cnt)) &
                   "; REF Cnt = " & to_string(ref_cnt)
                severity warning;
        else            
            report "Cnt = " & to_string(to_integer(tb_cnt)) &
                    "; REF Cnt = " & to_string(ref_cnt)
                severity error;
        end if;

        report "Test Complete"
                severity warning;

        std.env.finish;
    end process sim;

    process is
    begin
        loop
            tb_n_sum <= tb_n_sum + 1 when tb_n_sum /= N else 1;
            wait for 100 ns;
            assert tb_sum = tb_sum_ref
                report "Sum = " & to_string(tb_sum) & "; REF Sum = " &
                    to_string(tb_sum_ref)
                severity error;
        end loop;
    end process;

    process (tb_cnt, tb_n_sum) is

        function to_integer(val_in: std_logic) return integer is
        begin
            if val_in then
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
        tb_sum_ref <= check_sum_calc(tb_cnt, tb_n_sum);
    end process;

end architecture tb;
