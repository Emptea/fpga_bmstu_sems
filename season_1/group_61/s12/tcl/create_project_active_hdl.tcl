# Полный путь до папки с данным скриптом
set tcl_scripts_dir [file dirname [file normalize [info script]]]

# Переход на уровень выше папки со скриптом для создания проекта
cd ${tcl_scripts_dir}/..

# Имя проекта
set project_name [regsub {.*/} [pwd] {}]

# Создание проекта в папке active_hdl
if {[string equal active_hdl [glob -nocomplain -types d active_hdl]]} {
    file delete -force active_hdl
}
file mkdir active_hdl
workspace create active_hdl/${project_name}
design create -a -nodesdir ${project_name} active_hdl
# После создания проекта текущая папка active_hdl/src

# Добавление исходников из папки src, на два уровня выше относительно active_hdl/src
set src_dir ../../src
package require fileutil
set src_all_vhd [fileutil::findByPattern ${src_dir} *.vhd]
puts ${src_all_vhd}
foreach file ${src_all_vhd} {
    addfile -vhdl ${file}
}

# Компиляция всех файлов
comp -reorder