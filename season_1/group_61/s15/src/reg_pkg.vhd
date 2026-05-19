library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package reg_pkg is
    component b2b_reg
        generic (
            WIDTH : integer
        );
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            up_vld    : in std_logic;
            up_rdy    : out std_logic;
            up_data   : in std_logic_vector (WIDTH - 1 downto 0);
            down_vld  : out std_logic;
            down_rdy  : in std_logic;
            down_data : out std_logic_vector (WIDTH - 1 downto 0)
        );
    end component;

    component global_stall_reg
        generic (
            WIDTH : integer
        );
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            up_vld    : in std_logic;
            up_rdy    : out std_logic;
            up_data   : in std_logic_vector (WIDTH - 1 downto 0);
            down_vld  : out std_logic;
            down_rdy  : in std_logic;
            down_data : out std_logic_vector (WIDTH - 1 downto 0)
        );
    end component;

    component skid_buffer
        generic (
            WIDTH : integer
        );
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            up_vld    : in std_logic;
            up_rdy    : out std_logic;
            up_data   : in std_logic_vector (WIDTH - 1 downto 0);
            down_vld  : out std_logic;
            down_rdy  : in std_logic;
            down_data : out std_logic_vector (WIDTH - 1 downto 0)
        );
    end component;
end package;

package body reg_pkg is
end;
