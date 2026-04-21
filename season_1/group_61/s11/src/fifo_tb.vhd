-----------------------------------------------------------------
--Test Bench для FIFO
-----------------------------------------------------------------

-- Подключение библиотек
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity fifo_tb is
end fifo_tb;

architecture behavior of fifo_tb is

    component fifo is
        generic (
            DATA_W : integer := 8; -- разрядность шины данных
            ADDR_W : integer := 4 -- разрядность внутренней шины адреса
        );

        port (
            clk  : in std_logic; -- тактовый сигнал
            aclr : in std_logic; -- асинхронный сброс

            wrreq       : in std_logic; -- разрешение записи логической единицей
            data        : in std_logic_vector (DATA_W - 1 downto 0); -- входные данные
            full        : out std_logic; -- буфер полон
            almost_full : out std_logic; -- буфер почти полон
            overflow    : out std_logic; -- переполнение

            rdreq        : in std_logic; -- разрешение чтения логической единицей
            empty        : out std_logic; -- буфер пуст
            almost_empty : out std_logic; -- буфер пуст
            underflow    : out std_logic; -- недостаток данных
            q            : out std_logic_vector(DATA_W - 1 downto 0) -- выходные данные
        );
    end component;

    constant DATA_W : integer := 8; -- разрядность шины данных 

    signal clk  : std_logic := '0';
    signal aclr : std_logic;

    signal wrreq       : std_logic;
    signal data        : std_logic_vector(DATA_W - 1 downto 0);
    signal full        : std_logic;
    signal almost_full : std_logic;
    signal overflow    : std_logic;

    signal rdreq        : std_logic;
    signal empty        : std_logic;
    signal almost_empty : std_logic;
    signal underflow    : std_logic;
    signal q            : std_logic_vector(DATA_W - 1 downto 0);

    constant PERIOD : time    := 20 ns;
    signal END_SIM  : boolean := FALSE; -- Флаг окончания моделирования
begin

    -- Подключение моделируемого компонента
    uut : fifo
    port map(
    clk, aclr, --  сигналы управления
    wrreq, data, full, almost_full, overflow, -- сигналы записи
    rdreq, empty, almost_empty, underflow, q -- сигналы чтения
    );

	clk <= not clk after PERIOD/2;

    -- Процесс формирования управляющих сигналов
    tb : process
    begin

        aclr  <= '0'; -- сброс
        rdreq <= '0';
        wrreq <= '0';

        wait for PERIOD * 2;
        aclr <= '1';

        -- запись в FIFO
        for test_vec in 0 to 17 loop
            wait for PERIOD;
            wrreq <= '1';
            data  <= conv_std_logic_vector(test_vec, 8);
            wait for PERIOD;
            wrreq <= '0';
        end loop;

        -- чтение из FIFO	
        for test_vec in 0 to 17 loop
            wait for PERIOD;
            rdreq <= '1';
            wait for PERIOD;
            rdreq <= '0';
        end loop;

        -- запись в FIFO		
        for test_vec in 0 to 15 loop
            wait for PERIOD;
            wrreq <= '1';
            data  <= conv_std_logic_vector(test_vec, 8);
            wait for PERIOD;
            wrreq <= '0';
        end loop;

        -- чтение из FIFO	
        for test_vec in 0 to 11 loop
            wait for PERIOD;
            rdreq <= '1';
            wait for PERIOD;
            rdreq <= '0';
        end loop;

        wait for 80 NS;
        -- Одновременное чтение и запись		
        for test_vec in 0 to 11 loop
            wait for PERIOD;
            wrreq <= '1';
            rdreq <= '1';
            data  <= conv_std_logic_vector(test_vec, 8);
            wait for PERIOD;
            wrreq <= '0';
            rdreq <= '0';
        end loop;

        -- чтение из FIFO
        for test_vec in 0 to 7 loop
            wait for PERIOD;
            rdreq <= '1';
            wait for PERIOD;
            rdreq <= '0';
        end loop;

        -- запись в FIFO	
        for test_vec in 0 to 13 loop
            wait for PERIOD;
            wrreq <= '1';
            data  <= conv_std_logic_vector(test_vec, 8);
            wait for PERIOD;
            wrreq <= '0';
        end loop;
        END_SIM <= TRUE;

        wait for PERIOD * 2;
		std.env.finish;
    end process;
end behavior;
