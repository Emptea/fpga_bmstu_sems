------------------------------------------------------------------
-- FIFO буфер
------------------------------------------------------------------

-- Подключение библиотек
------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- ENTITY
------------------------------------------------------------------
entity fifo is
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
end fifo;

--ARCHITECTURE
------------------------------------------------------------------
architecture rtl of fifo is
    -- тип данных для памяти
    type memory_type is array (0 to 2 ** ADDR_W - 1) of std_logic_vector(DATA_W - 1 downto 0);
    signal memory            : memory_type                           := (others => (others => '0')); -- память
    signal readptr, writeptr : std_logic_vector(ADDR_W - 1 downto 0) := (others => '0'); -- счетчики адресов чтения и записи 
    signal data_count        : integer range 0 to 2 ** ADDR_W    := 0; -- счетчики количества занятых ячеек памяти
    type state_type is (ST_EMPTY, ST_ALMOST_EMPTY, ST_WORK, ST_ALMOST_FULL, ST_FULL); -- Define states
    signal current_state, next_state : state_type;
begin
    -- Логика чтения
    process (clk, aclr)
    begin
        if (aclr = '0') then -- асинхронный сброс			
            q <= (others => '0');
        elsif (rising_edge(clk)) then -- фронт сигнала
            if (rdreq = '1' and not (current_state = ST_EMPTY)) then -- чтение данных
                q <= memory(conv_integer(readptr));
            end if;
        end if;
    end process;

    -- Логика записи
    process (clk, aclr)
    begin
        if (rising_edge(clk)) then
            if (wrreq = '1' and not (current_state = ST_FULL)) then -- запись данных
                memory(conv_integer(writeptr)) <= data;
            end if;
        end if;
    end process;

    --Счетчик
    process (clk, aclr)
    begin
        if (aclr = '0') then -- асинхронный сброс			
            readptr    <= (others => '0');
            writeptr   <= (others => '0');
            data_count <= 0;
        elsif (rising_edge(clk)) then -- фронт сигнала
            if (rdreq = '1') then -- чтение данных
                if (not (current_state = ST_EMPTY)) then -- если нет данных, то ошибка
                    readptr    <= readptr + '1'; -- увеличение счетчика чтения
                    data_count <= data_count - 1; -- уменьшение счетчика количества занятых ячеек
                end if;
            end if;

            if (wrreq = '1') then -- чтение данных
                if (not (current_state = ST_FULL)) then -- если нет данных, то ошибка	
                    writeptr   <= writeptr + '1'; -- увеличение счетчика записи
                    data_count <= data_count + 1; -- увеличение счетчика количества занятых ячеек
                end if;
            end if;
        end if;
    end process;

    -- Конечный автомат для управления состояниями FIFO
    process (clk, aclr)
    begin
        if (aclr = '0') then
            current_state <= ST_EMPTY;
            next_state    <= ST_EMPTY;
        elsif (rising_edge(clk)) then
            current_state <= next_state;
            case current_state is
                when ST_EMPTY =>
                    if (wrreq = '1') then
                        next_state <= ST_ALMOST_EMPTY;
                    end if;

                when ST_ALMOST_EMPTY =>
                    if (wrreq = '1') then
                        next_state <= ST_WORK;
                    elsif (rdreq = '1') then
                        next_state <= ST_EMPTY;
                    end if;

                when ST_WORK =>
                    if ((data_count < 3) and (rdreq = '1')) then
                        next_state <= ST_ALMOST_EMPTY;
                    elsif ((data_count > 2 ** ADDR_W - 1 - 2) and (wrreq = '1')) then
                        next_state <= ST_ALMOST_FULL;
                    end if;

                when ST_ALMOST_FULL =>
                    if (rdreq = '1') then
                        next_state <= ST_WORK;
                    elsif (wrreq = '1') then
                        next_state <= ST_FULL;
                    end if;

                when ST_FULL =>
                    if (rdreq = '1') then
                        next_state <= ST_ALMOST_FULL;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process;

    empty <= '1' when (current_state = ST_EMPTY) else '0';
    almost_empty <= '1' when (current_state = ST_ALMOST_EMPTY) else '0';
    almost_full <= '1'when (current_state = ST_ALMOST_FULL) else '0';
    full <= '1' when (current_state = ST_FULL) else '0';
    underflow <= '1' when (current_state = ST_EMPTY and rdreq = '1') else '0';
    overflow <= '1' when (current_state = ST_FULL and wrreq = '1') else '0';

end rtl;