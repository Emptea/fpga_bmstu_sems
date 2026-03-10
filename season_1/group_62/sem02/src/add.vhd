-- этот файл НЕ КОМПИЛИРУЕТСЯ

-- это комментарий, он продолжается до конца строки
-- это продолжение комментария

/*
    это
    многострочный
    комментарий
*/

-- VHDL является РЕГИСТРОНЕЗАВИСИМЫМ

-- Общий вид интерфейса модуля
entity "имя_интерфейса" is
    generic (
        "имя_параметра_1" : "тип" := "значение";
        "имя_параметра_2" : "тип" := "значение";
        ----------------------------------------
        "имя_параметра_n" : "тип" := "значение"
    );
    port (
        "имя_порта_1" : "режим" "тип";
        "имя_порта_2" : "режим" "тип";
        -----------------------------
        "имя_порта_n" : "режим" "тип"
    );
end "имя_интерфейса";

entity test is
	generic (
		DATA_WIDTH :  integer := 16;
	);
	port (
	a : in std_logic_vector(DATA_WIDTH - 1 downto 0);
	b : in std_logic_vector(DATA_WIDTH - 1 downto 0);
	c : out std_logic_vector(DATA_WIDTH downto 0)
		);
end test;

-- Общий вид архитектуры модуля
architecture "имя_архитектуры" of "имя_интерфейса" is
    signal valid : std_logic := '0';
begin
    valid <= a(DATA_WIDTH - 1) and b(DATA_WIDTH - 1)
	c <= valid & (a and b);
end "имя_архитектуры";

-- Пример модуля 2И
entity and2 is -- декларация имени элемента
    port (
        x1 : in bit;
        x2 : in bit;
        y  : out bit
    );
end and2;

architecture rtl of and2 is
begin
   y <= x1 and x2;
end rtl;

-- Объекты языка
signal "имя:" : "тип" := "значение_по_умолчанию";
constant "имя:" : "тип" := "значение_по_умолчанию";
variable "имя:" : "тип" := "значение_по_умолчанию";

-- Типы данных:
-- scalar, composite, access type, file types

-- scalar:
-- enumeration, integer, physical, floating point

-- composite:
-- array, record

type "имя_записи" is "описание_типа";
subtype "имя" is "описание_подтипа";

-- примеры типов в standart.vhd

-- Запись
type "имя" is record
    "имя_элемента_1" : "тип";
    "имя_элемента_2" : "тип";
    --------------------------
    "имя_элемента_n" : "тип"
end record;

-- пример записи
type TIME_range_record is record
	Left 		: TIME;
	Right 		: TIME;
	Direction 	: RANGE_DIRECTION;
end record;

-- Тип STD_LOGIC, библиотека ieee, пакет std_logic_1164
type STD_ULOGIC is ('U','X','0','1','Z','W','L','H','-');
subtype STD_LOGIC is resolved STD_ULOGIC;
'U' -- не инициализировано;
'X' -- неизвестное значение (сильный источник сигнала);
'0' -- логический 0 (сильный источник сигнала);
'1' -- логическая 1 (сильный источник сигнала);
'Z' -- высокий импеданс (цепь не подключена к источнику);
'W' -- неизвестное значение (слабый источник сигнала);
'L' -- логический 0 (слабый источник сигнала);
'Н' -- логическая 1 (слабый источник сигнала);
'-' -- безразличное значение (don't саге).

-- Подключение пакетов
library "имя_библиотеки";
use "имя_библиотеки"."имя_пакета".all;

-- Подключение пакетов для работы с std_logic и std_logic_vector
library ieee;
use ieee.std_logic_1164.all;    -- содержит типы
use ieee.numeric_std.all;       -- содержит типы для арифметических операциий
-- не использовать
-- use ieee.std_logic_arith.all

-- Литералы
-- Вещественные числа
constant c : real := 2.997_924_58e8;
constant pi : real := 3.14;
constant h : real := 6.626_070_15e-34;
 -- Целые числа
signal a_dec : integer := 252;
signal a_bin : integer := 2#1111_1100#;
signal a_hex : integer := 16#FC#;
-- Числа физического типа
constant t1 : time := 2020.2 ns;
constant t2 : time := 1 sec;
-- Битовые строки
signal p_bin : std_logic_vector(7 downto 0) := "0000_1111";
signal p_bin : std_logic_vector(7 downto 0) := 8ub"1111";
signal p_hex : std_logic_vector(7 downto 0) := 8ux"F";
signal p_bin : std_logic_vector(7 downto 0) := "1111_1010";
signal p_bin : std_logic_vector(7 downto 0) := 8sb"1010";
signal p_hex : std_logic_vector(7 downto 0) := 8sx"A";
-- Строки
"строка"

-- Операторы VHDL
**    -- возведение в степень
abs   -- модуль
not   -- инверсия

-- Операторы умножения
*     -- умножение
/     -- деление
mod   -- деление по модулю
rem   -- остаток от деления

-- Операторы знака
+     -- положительное
-     -- отрицательное

-- Операторы сложения
+     -- сложение
-     -- вычитание
&     -- конкатенация (объединение)

-- Операторы сдвига
sll   -- логический сдвиг влево
srl   -- логический сдвиг вправо
sla   -- арифметический сдвиг влево
sra   -- арифметический сдвиг вправо
rol   -- циклический сдвиг влево
ror   -- циклический сдвиг вправо

-- Операторы отношения
=     -- равенство
/=    -- неравенство
<     -- меньше
<=    -- меньше-равно
>     -- больше
>=    -- больше-равно

-- Логические операторы
and   -- логическое И
or    -- логическое ИЛИ
nand  -- логическое И-НЕ
nor   -- логическое ИЛИ-НЕ
xor   -- исключающее ИЛИ
xnor  -- исключающее ИЛИ-НЕ

-- Оператор задержки, используется только для моделирования и верификации схем
-- при синтезе схемы игнорируется
after

--
entity logic_function2 is
    port (
    );
end entity logic_function2;

entity or_vect_n is
    port (
    );
end entity or_vect_n;

entity cod2 is
    port (
    );
end entity cod2;