library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity pow5_tb is
end entity;

architecture sim of pow5_tb is

    constant IN_WIDTH  : integer := 16;
    constant OUT_WIDTH : integer := 17;

    signal done : boolean := false;	
	signal passed : boolean := true;

    -- DUT signals
    signal clk : std_logic := '1';
    signal rst : std_logic := '0';

    signal up_vld  : std_logic := '0';
    signal up_data : std_logic_vector(IN_WIDTH - 1 downto 0);

    signal down_vld  : std_logic;
    signal down_data : std_logic_vector(OUT_WIDTH - 1 downto 0);

    -- simple queue (FIFO)
    type queue_t is array (0 to 1023) of integer;
    signal queue  : queue_t;
    signal q_head : integer := 0;
    signal q_tail : integer := 0;

    signal cycle : integer := 0;

    -- random
    shared variable seed1, seed2 : positive := 1;

    -- helper
    function pow5(x : integer) return integer is
    begin
        return x * x * x * x * x;
    end function;

begin

    -- DUT
    dut : entity work.pow5
        generic map(IN_WIDTH => IN_WIDTH, OUT_WIDTH => OUT_WIDTH)
        port map
        (
            clk       => clk,
            rst       => rst,
            up_vld    => up_vld,
            up_data   => up_data,
            down_vld  => down_vld,
            down_data => down_data
        );

    -- clock
    clk_process : process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    -- timeout
    timeout_proc : process
    begin
        wait for 10000 * 10 ns;
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
        wait for 3 * 10 ns;
        rst <= '1';
        wait for 3 * 10 ns;
        rst <= '0';

        report "*** Run back-to-back";
        up_vld <= '1';
        wait for 20 * 10 ns;

        report "*** Draining pipeline";
        up_vld <= '0';
        wait for 10 * 10 ns;

        report "*** Random up_vld";
        for i in 0 to 49 loop
            uniform(seed1, seed2, rand);
            if rand > 0.5 then
                up_vld <= '1';
            else
                up_vld <= '0';
            end if;
            wait for 10 ns;
        end loop;

        report "*** Draining pipeline";
        up_vld <= '0';
        wait for 10 * 10 ns;

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
        if rising_edge(clk) then
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
                if up_vld = '1' then
                    queue(q_tail) <= to_integer(unsigned(up_data));
                    q_tail        <= q_tail + 1;
                end if;

                -- pop + check
                if down_vld = '1' then
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

             --logging
            report "time=" & integer'image(integer(now / 1 ns)) &
			       " cycle=" & integer'image(cycle) &
			       " expected=" & integer'image(expected) &
			       " got=" & integer'image(to_integer(unsigned(down_data)));

            cycle <= cycle + 1;
        end if;
    end process;

end architecture;