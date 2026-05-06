set tcl_scripts_dir [file dirname [file normalize [info script]]]
cd ${tcl_scripts_dir}/..

package require cmdline
set options {\
    { "project_name.arg" "" "Project name" } \
    { "src_dir.arg" "" "Source directory" }
}
array set opts [::cmdline::getoptions quartus(args) ${options}]

if {[string equal "" ${opts(project_name)}]} {
    set opts(project_name) [regsub {.*/} [pwd] {}]
}

if {[string equal "" ${opts(src_dir)}]} {
    set opts(src_dir) ../src
}

cd quartus

source ${tcl_scripts_dir}/tools.tcl
update_src_path ${opts(project_name)} ${opts(src_dir)}
