--Подключение библиотек
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_types.all;

entity fir_filter is
    generic (
        taps        : natural := 10; -- количество коэффициентов
        data_width  : natural := 16; -- разрядность данных
        coeff_width : natural := 16; -- разрядность коэффициентов
        accum_width : natural := 34  -- разрядность аккумулятора
    );
    port (
        clk     : in std_logic; -- тактовый сигнал
        reset_n : in std_logic; -- асинхронный сброс

        data   : in signed(data_width - 1 downto 0); -- входные данные
        coeff  : in signed_array_t(0 to taps - 1)(coeff_width - 1 downto 0);
        result : out signed(data_width - 1 downto 0) -- выходные данные
    );
end fir_filter;

architecture rtl of fir_filter is
    -- промежуточные входные данные
    signal data_pipeline : signed_array_t(0 to taps - 1)(data_width - 1 downto 0);
    -- промежуточные произведения
    signal products : signed_array_t(0 to taps - 1)(coeff_width + data_width - 2 downto 0);
begin
    process (clk, reset_n)
        variable accum : signed(accum_width - 1 downto 0); -- сумма произведений
    begin
        if (reset_n = '0') then
            data_pipeline <= (others => (others => '0'));
            result        <= (others => '0');

            accum := (others => '0');
        elsif rising_edge(clk) then
            -- сдвиг промежуточных входных данных с запоминаем входных данных
            data_pipeline <= data & data_pipeline(0 to taps - 2);
            -- формирование итоговой суммы
            accum := (others => '0');
            for i in 0 to taps - 1 loop
                accum := accum + products(i);
            end loop;
            -- приведение результата ко входному диапазону
            result <= accum(accum'length - 1 downto accum'length - coeff_width);
        end if;
    end process;

    -- реализация умножителей
    product_calc : for i in 0 to taps - 1 generate
        products(i) <= resize(data_pipeline(i) * coeff(i), coeff_width + data_width - 1);
    end generate;
end rtl;
