# Использование tcl–скриптов для быстрого создания проектов
## Ссылки
- [Репозиторий с tcl-скриптами от ki4igin](https://github.com/ki4igin/tcl)
- [Установка переменных окружающей среды в Windows](https://remontka.pro/environment-variables-windows/)
- Git для новичков: [часть 1](https://habr.com/ru/articles/541258/) [часть 2](https://habr.com/ru/articles/542616/)

## Требования
- Установлен Active-HDL
- Путь к Active-HDL добавлен в переменную `Path` системных переменных среды (путь по умолчанию в Windows: `C:\Aldec\Active-HDL-Student-Edition\bin`)
- Установлен Quartus II 13.0.1
- Путь к Quartus добавлен в переменную `Path` системных переменных среды (путь по умолчанию в Windows: `C:\altera\13.0sp1\quartus\bin`)
- Если Quartus не установлен в путь по умолчанию, должна быть задана переменная среды `QUARTUS_ROOTDIR` (пример: `QUARTUS_ROOTDIR=F:\altera\13.0sp1`)
## Файловая структура проекта
```
├── board/ # Board-файлы QSF под разные платы
├── src/ # Исходные файлы VHDL/Verilog
└── tcl/ # Tcl-скрипты Quartus
```
## Использование tcl-скриптов
Все tcl–скрипты запускаются из корня проекта.

Для создания проекта Active-HDL без библиотек CycloneII:
```
avhdl -do "do tcl/avhdl_create_project.tcl"
```
Для создания проекта Active-HDL с библиотеками CycloneII:
```
avhdl -do "do tcl/avhdl_create_project.tcl -cII"
```
Для создания проекта Quartus
```
quartus_sh -t tcl/qsh_create_project.tcl [-project <project_name>] [-folder <destination_folder>] [-src_exc <folders_to_exclude>] [-top <top_module_name>] [-tb <testbench_name>] [-board <qsf_name>]
```
Пример полной команды создания проекта Quartus:
```
quartus_sh -t tcl/qsh_create_project.tcl -project fifo -folder quartus -src_exc testbench software -top fifo -tb fifo_tb -board DE2_Default
```
Пример минимальной команды создания проекта Quartus для данного проекта:
```
quartus_sh -t tcl/qsh_create_project.tcl -project fifo -top fifo
```
Запуск проекта в GUI Quartus из командной строки:
```
cd <folder_name>/
quartus <project_name>.qpf
```
Пример для данного проекта:
```
cd quartus/
quartus fifo.qpf
```
Запуск компиляции из командной строки:
```
quartus_sh -t tcl/qsh_compile.tcl [-project <project_name>]
```
Запуск анализа из командной строки:
```
quartus_sh -t tcl/qsh_analysis.tcl [-project <project_name>]
```
Обновить проект Quartus исходниками из папки `src`:
```
quartus_sh -t tcl/qsh_update.tcl [-project <project_name>] [-src <src_folder>] [-src_exc <folders_to_exclude>] [-obj <object_to_update:all/src/pin/tcl>]
```
