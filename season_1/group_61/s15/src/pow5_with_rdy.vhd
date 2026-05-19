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

    type mult_array is array (natural range <>) of signed (MULT_OUT_SIZE - 1 downto 0);
    type pipe_array is array (natural range <>) of signed (IN_WIDTH - 1 downto 0);

    signal mult_vld  : std_logic_vector (MULT_NUM downto 0);
    signal mult_rdy  : std_logic_vector (MULT_NUM downto 0);
    signal pipe_data : pipe_array (MULT_NUM downto 0);
    signal mult_data : mult_array (MULT_NUM - 1 downto 0);
begin
    generate_pipe_data : for i in 0 to MULT_NUM generate
        gen_first_reg_data : if (i = 0) generate
            pipe_cell : b2b_reg
            generic map(
                WIDTH => IN_WIDTH
            )
            port map
            (
                clk       => clk,
                rst       => rst,
                up_vld    => up_vld,
                up_rdy    => up_rdy,
                up_data   => up_data,
                down_vld  => mult_vld(0),
                down_rdy  => mult_rdy(0),
                signed(down_data) => pipe_data(0)
            );

        else generate
            pipe_cell : b2b_reg
            generic map(
                WIDTH => IN_WIDTH
            )
            port map
            (
                clk       => clk,
                rst       => rst,
                up_vld    => mult_vld(i-1),
                up_rdy    => mult_rdy(i - 1),
                up_data   => std_logic_vector(pipe_data(i-1)),
                down_vld  => mult_vld(i),
                down_rdy  => mult_rdy(i),
                signed(down_data) => pipe_data(i)
            );
        end generate;
    end generate;

    generate_mults : for i in 0 to MULT_NUM - 1 generate
        gen_first_reg_mult : if (i = 0) generate
            reg_mult_data : process (clk)
            begin
                if rising_edge(clk) then
                    mult_data(i) <= resize(pipe_data(i) * pipe_data(i), MULT_OUT_SIZE);
                end if;
            end process;
        else generate
            reg_mult_data : process (clk)
            begin
                if rising_edge(clk) then
                    mult_data(i) <= resize(mult_data(i - 1) * pipe_data(i), MULT_OUT_SIZE);
                end if;
            end process;
        end generate;
    end generate;

    down_data <= std_logic_vector(mult_data(MULT_NUM - 1)(OUT_WIDTH - 1 downto 0));
    down_vld  <= mult_vld(mult_vld'high);
	mult_rdy(mult_rdy'high) <= down_rdy;
end architecture;