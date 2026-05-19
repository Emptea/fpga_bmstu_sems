library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library std;
use std.textio.all;

entity pow5_with_rdy_tb is
end entity;

architecture sim of pow5_with_rdy_tb is

    constant CLK_PERIOD : time := 10 ns;

    constant IN_WIDTH  : integer := 16;
    constant OUT_WIDTH : integer := 17;

    signal done   : boolean := false;
    signal passed : boolean := true;

    -- DUT signals
    signal clk : std_logic := '1';
    signal rst : std_logic := '0';

    signal up_vld  : std_logic := '0';
    signal up_rdy  : std_logic;
    signal up_data : std_logic_vector(IN_WIDTH - 1 downto 0);

    signal down_vld  : std_logic;
    signal down_rdy  : std_logic := '0';
    signal down_data : std_logic_vector(OUT_WIDTH - 1 downto 0);

    -- simple queue (FIFO)
    type queue_t is array (0 to 1023) of integer;
    signal queue  : queue_t;
    signal q_head : integer := 0;
    signal q_tail : integer := 0;

    signal cycle : integer := 0;

    signal up_cnt, down_cnt : integer := 0;

    -- random
    shared variable seed1, seed2 : positive := 1;

    -- helper
    function pow5(x : integer) return integer is
    begin
        return x * x * x * x * x;
    end function;

begin

    -- DUT
    dut : entity work.pow5_with_rdy
        generic map(IN_WIDTH => IN_WIDTH, OUT_WIDTH => OUT_WIDTH)
        port map
        (
            clk       => clk,
            rst       => rst,
            up_vld    => up_vld,
            up_rdy    => up_rdy,
            up_data   => up_data,
            down_vld  => down_vld,
            down_rdy  => down_rdy,
            down_data => down_data
        );

    -- clock
    clk <= not clk after CLK_PERIOD / 2;

    -- timeout
    timeout_proc : process
    begin
        wait for 10000 * CLK_PERIOD;
        report "Timeout!" severity failure;
    end process;

    finish_proc : process
    begin
        wait until done;
        if passed then
            report "PASSED" severity warning;
        end if;
        std.env.finish;
    end process;

    -- stimulus
    stim_proc : process
        variable rand : real;
    begin
        -- reset
        wait for 3 * CLK_PERIOD;
        rst <= '1';
        wait for 3 * CLK_PERIOD;
        rst <= '0';

        report "*** Run back-to-back";
        up_vld   <= '1';
        down_rdy <= '1';
        wait for 20 * CLK_PERIOD;

        report "*** Filling the pipeline: up_vld = 1, down_rdy = 0";
        down_rdy <= '0';
        wait for 10 * CLK_PERIOD;

        report "*** Draining pipeline: up_vld = 0, down_rdy = 1";
        down_rdy <= '1';
        wait until up_rdy = '1';
        up_vld <= '0';
        wait for 10 * CLK_PERIOD;

        report "*** Random up_vld and down_rdy";
        for i in 0 to 49 loop
			if (up_vld = '0') or (up_rdy = '1') then
	            uniform(seed1, seed2, rand);
	            if rand > 0.5 then
	                up_vld <= '1';
	            else
	                up_vld <= '0';
	            end if;
			end if;
			
			uniform(seed1, seed2, rand);
            if rand > 0.5 then
                down_rdy <= '1';
            else
                down_rdy <= '0';
            end if;
            wait for CLK_PERIOD;
        end loop;

        report "*** Draining pipeline: upd_vld = 0, down_rdy = 1";
        down_rdy <= '1';
        wait until up_vld and not up_rdy;
        up_vld <= '0';
        wait for 10 * CLK_PERIOD;

        if q_head /= q_tail then
            report "ERROR: data is left sitting in the model queue" severity error;
            passed <= false;
        end if;

        done <= true;

        wait;
    end process;

    -- drive data
    data_proc : process (clk)
        variable rand : real;
    begin
        if rising_edge(clk) and (up_vld = '1') and (up_rdy = '1') then
            uniform(seed1, seed2, rand);
            up_data <= std_logic_vector(to_unsigned(integer(rand * 10.0), IN_WIDTH));
        end if;
    end process;

    -- model + checking
    check_proc : process (clk)
        variable expected : integer;
        variable val      : integer;
    begin
        if rising_edge(clk) then

            if rst = '1' then
                q_head <= 0;
                q_tail <= 0;
            else
                -- push
                if up_vld = '1' and up_rdy = '1' then
                    queue(q_tail) <= to_integer(unsigned(up_data));
                    q_tail        <= q_tail + 1;
                end if;

                -- pop + check
                if down_vld = '1' and down_rdy = '1' then
                    if q_head = q_tail then
                        report "ERROR: unexpected downstream data" severity error;
                    else
                        val := queue(q_head);
                        q_head <= q_head + 1;

                        expected := pow5(val);

                        if to_integer(unsigned(down_data)) /= expected then
                            report "ERROR: mismatch. Expected "
                                & integer'image(expected)
                                & " got "
                                & integer'image(to_integer(unsigned(down_data)))
                                severity error;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    --performance counters
    perf_cnt : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                cycle   <= 0;
                up_cnt  <= 0;
                down_cnt <= 0;

            else
                cycle <= cycle + 1;

                if (up_rdy = '1' and up_vld = '1') then
                    up_cnt <= up_cnt + 1;
                end if;

                if (down_rdy = '1' and down_vld = '1') then
                    down_cnt <= down_cnt + 1;
                end if;
            end if;
        end if;
    end process;

--    --logging
--    log_proc : process (clk)
--        variable msg : line;
--        variable ptr : positive := 1;
--    begin
--        if rising_edge(clk) then
--            -- initial "time ... cycle ..."
--            write(msg, "time " & integer'image(integer(now / 1 ns)) & " cycle " & integer'image(cycle));
--
--            -- rst
--            if rst = '1' then
--                write(msg, " rst");
--            end if;
--
--            -- up_vld / up_rdy
--            if up_vld = '1' then
--                write(msg, " up_vld");
--            end if;
--            if up_rdy = '1' then
--                write(msg, " up_rdy");
--            end if;
--
--            -- up_data (only when up_vld & up_rdy)
--            if (up_vld = '1' and up_rdy = '1') then
--                write(msg, " " & integer'image(to_integer(unsigned(up_data))));
--            else
--                write(msg, "      ");
--            end if;
--
--            -- down_vld / down_rdy
--            if down_vld = '1' then
--                write(msg, " down_vld");
--            end if;
--            if down_rdy = '1' then
--                write(msg, " down_rdy");
--            end if;
--
--            -- down_data (only when down_vld & down_rdy)
--            if (down_vld = '1' and down_rdy = '1') then
--                write(msg, " " & integer'image(to_integer(unsigned(down_data))));
--            else
--                write(msg, "      ");
--            end if;
--
--            writeline(output, msg);
--        end if;
--    end process;
end architecture;