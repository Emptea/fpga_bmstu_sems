library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.reg_pkg.all;

entity pow5_with_rdy is
    generic (
        IN_WIDTH  : integer := 5;
        OUT_WIDTH : integer := 5
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        up_vld  : in std_logic;
        up_rdy  : out std_logic;
        up_data : in std_logic_vector (IN_WIDTH - 1 downto 0);

        down_vld  : out std_logic;
        down_rdy  : in std_logic;
        down_data : out std_logic_vector (OUT_WIDTH - 1 downto 0)
    );
end entity pow5_with_rdy;

architecture rtl of pow5_with_rdy is
    constant MULT_NUM      : integer := 4;
    constant MULT_OUT_SIZE : integer := 2 * IN_WIDTH + integer(ceil(log2(real(MULT_NUM))));
    constant PIPE_WIDTH    : integer := IN_WIDTH + MULT_OUT_SIZE;

    type mult_array is array (natural range <>) of signed (MULT_OUT_SIZE - 1 downto 0);
    type pipe_array is array (natural range <>) of signed (IN_WIDTH - 1 downto 0);
	type mult_data_array is array (natural range <>) of std_logic_vector (PIPE_WIDTH - 1 downto 0);

    signal mult_vld  : std_logic_vector (MULT_NUM - 1 downto 0);
    signal mult_rdy  : std_logic_vector (MULT_NUM - 1 downto 0);
    signal pipe_data : pipe_array (MULT_NUM - 1 downto 0);
    signal mult_data : mult_array (MULT_NUM - 1 downto 0);
	signal mult_data_regs :  mult_data_array (MULT_NUM - 2 downto 0);	   
begin
    generate_pipe_data : for i in 0 to MULT_NUM - 1 generate
        gen_first_reg_data : if (i = 0) generate
            pipe_cell : b2b_reg
            generic map(
                WIDTH => IN_WIDTH
            )
            port map
            (
                clk               => clk,
                rst               => rst,
                up_vld            => up_vld,
                up_rdy            => up_rdy,
                up_data           => up_data,
                down_vld          => mult_vld(0),
                down_rdy          => mult_rdy(0),
                signed(down_data) => pipe_data(0)
            );
            mult_data(0) <= resize(pipe_data(0) * pipe_data(0), MULT_OUT_SIZE);

        else
            generate
                pipe_cell : b2b_reg
                generic map(
                    WIDTH => PIPE_WIDTH
                )
                port map
                (
                    clk               => clk,
                    rst               => rst,
                    up_vld            => mult_vld(i - 1),
                    up_rdy            => mult_rdy(i - 1),
                    up_data           => std_logic_vector(pipe_data(i - 1)) & std_logic_vector(mult_data(i - 1)),
                    down_vld          => mult_vld(i),
                    down_rdy          => mult_rdy(i),
                    down_data 		  => mult_data_regs(i - 1)
                );
				pipe_data(i) <= signed(mult_data_regs(i - 1)(PIPE_WIDTH - 1 downto PIPE_WIDTH - IN_WIDTH));
                mult_data(i) <= resize(pipe_data(i) * signed(mult_data_regs(i - 1)(MULT_OUT_SIZE - 1 downto 0)), MULT_OUT_SIZE);
            end generate;
        end generate;

        output_reg : b2b_reg
        generic map(
            WIDTH => OUT_WIDTH
        )
        port map
        (
            clk       => clk,
            rst       => rst,
            up_vld    => mult_vld(mult_vld'high),
            up_rdy    => mult_rdy(mult_rdy'high),
            up_data   => std_logic_vector(mult_data(MULT_NUM - 1)(OUT_WIDTH - 1 downto 0)),
            down_vld  => down_vld,
            down_rdy  => down_rdy,
            down_data => down_data
        );
    end architecture;