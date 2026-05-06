proc update_src_path {project_name src_dir} {

    if {[string equal "" ${project_name}] ||  [string equal "" ${src_dir}]} {
        return
    }

    set need_to_close_project 0

    if {[is_project_open]} {
        if {${project_name} == [get_current_project]} {

        } else {
            project_close
            project_open ${project_name}
            set need_to_close_project 1
        }
    } else {
        project_open ${project_name}
        set need_to_close_project 1
    }
    
    package require fileutil
    set src_qip [fileutil::findByPattern ${src_dir} *.qip]
    set src_all_vhd [fileutil::findByPattern ${src_dir} *.vhd]

    # Delete dublication in qip and vhdl source
    foreach file_qip $src_qip {
        set file_qip_dir [file dirname $file_qip]
        set file [open $src_qip]
        # TODO add verilog and system verilog
        while {[gets $file line] >= 0} {
            if {[string first VHDL_FILE $line] > 1} {
                set filename [string range ${line} [string first "\"" ${line}]+1 [string last "\"" ${line}]-1]
                lappend list $filename        
            }
        }
        set src_vhd_del [fileutil::findByPattern $file_qip_dir $list]       

        foreach file_del ${src_vhd_del} {
            set idx [lsearch $src_all_vhd $file_del]
            puts $idx
            set src_all_vhd [lreplace $src_all_vhd $idx $idx]
        }
    }
    # Delete dublication in qip and vhdl source

    set src_synt_vhd [lsearch -inline -all -regexp -not ${src_all_vhd} .*tb\.vhd|.*inst\.vhd]
    set src_tb_vhd [lsearch -inline -all ${src_all_vhd} *tb.vhd]
    set src_all_v [fileutil::findByPattern ${src_dir} *.v]
    set src_synt_v [lsearch -inline -all -regexp -not ${src_all_v} .*tb\.v|.*inst\.v]
    set src_tb_v [lsearch -inline -all ${src_all_v} *tb.v]
    set src_all_sv [fileutil::findByPattern ${src_dir} *.sv]
    set src_synt_sv [lsearch -inline -all -regexp -not ${src_all_sv} .*tb\.sv|.*inst\.sv]
    set src_tb_sv [lsearch -inline -all ${src_all_sv} *tb.sv]

    foreach file ${src_qip} {
        set_global_assignment -name QIP_FILE ${file}
    }
    foreach file ${src_synt_vhd} {
        set_global_assignment -name VHDL_FILE ${file}
    }
    foreach file ${src_tb_vhd} {
        set_global_assignment -name VHDL_TEST_BENCH_FILE ${file}
    }
    foreach file ${src_synt_v} {
        set_global_assignment -name VERILOG_FILE ${file}
    }
    foreach file ${src_tb_v} {
        set_global_assignment -name VERILOG_TEST_BENCH_FILE ${file}
    }
    foreach file ${src_synt_sv} {
        set_global_assignment -name SYSTEM_VERILOG_FILE ${file}
    }
    foreach file ${src_tb_sv} {
        set_global_assignment -name SYSTEM_VERILOG_TEST_BENCH_FILE ${file}
    }

    # Close project
    if {${need_to_close_project}} {
        project_close
    }

    return [list ${src_synt_vhd} ${src_tb_vhd} ${src_synt_v} ${src_tb_v} ${src_synt_sv} ${src_tb_sv} ${src_qip}]
}