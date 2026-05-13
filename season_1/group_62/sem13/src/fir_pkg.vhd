library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package fir_pkg is
    type signed_array_t is array(natural range <>) of signed;

    function log2 (i : natural) return integer;

    component fir
        generic (
            N : positive := 8;
            W : positive := 16
        );
        port (
            clk : in    std_logic;
            rst : in    std_logic;

            din   : in    signed(W - 1 downto 0);
            coeff : in    signed_array_t(N - 1 downto 0)(W - 1 downto 0);
            dout  : out   signed(W - 1 downto 0)
        );
    end component;
    component fir_trans
        generic (
            N : positive := 8;
            W : positive := 16
        );
        port (
            clk : in    std_logic;
            rst : in    std_logic;

            din   : in    signed(W - 1 downto 0);
            coeff : in    signed_array_t(N - 1 downto 0)(W - 1 downto 0);
            dout  : out   signed(W - 1 downto 0)
        );
    end component;
    component fir_systolic
        generic (
            N : positive := 8;
            W : positive := 16;
				W_COEFF : positive := 16
        );
        port (
            clk : in    std_logic;
            rst : in    std_logic;

            din   : in    signed(W - 1 downto 0);
            coeff : in    signed_array_t(N - 1 downto 0)(W_COEFF - 1 downto 0);
            dout  : out   signed(W - 1 downto 0)
        );
    end component;
    component fir_trans_cell
        generic (
            W     : positive := 16;
            ACC_W : positive := 16
        );
        port (
            clk       : in    std_logic;
            rst       : in    std_logic;
            din       : in    signed(W - 1 downto 0);
            coeff     : in    signed(W - 1 downto 0);
            accum_in  : in    signed(ACC_W - 1 downto 0);
            accum_out : out   signed(ACC_W - 1 downto 0)
        );
    end component;
    component fir_systolic_cell
        generic (
            W     : positive := 16;
            ACC_W : positive := 16;
				W_COEFF : positive := 16
        );
        port (
            clk       : in    std_logic;
            rst       : in    std_logic;
            din       : in    signed(W - 1 downto 0);
            coeff     : in    signed(W_COEFF - 1 downto 0);
            accum_in  : in    signed(ACC_W - 1 downto 0);
            pipe_out  : out   signed(W - 1 downto 0);
            accum_out : out   signed(ACC_W - 1 downto 0)
        );
    end component;
end package;

package body fir_pkg is

    function log2 (i : natural) return integer is
        variable temp    : integer := i;
        variable ret_val : integer := 0;
    begin
        while temp > 1 loop
            ret_val := ret_val + 1;
            temp    := temp / 2;
        end loop;
        return ret_val;
    end function;

end;
