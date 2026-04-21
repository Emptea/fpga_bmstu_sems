if {[info exists env(QUARTUS_ROOTDIR)]} {
    set quartus_path $env(QUARTUS_ROOTDIR)
} else {
    set quartus_path "C:/altera/13.0sp1"
}

alib  vhdl_libs/altera_vhdl
amap altera vhdl_libs/altera_vhdl
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/altera_syn_attributes.vhd
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/altera_standard_functions.vhd
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/alt_dspbuilder_package.vhd
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/altera_europa_support_lib.vhd
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/altera_primitives_components.vhd
acom -strict93 -dbg -work altera $quartus_path/eda/sim_lib/altera_primitives.vhd

alib  vhdl_libs/lpm_vhdl
amap lpm vhdl_libs/lpm_vhdl
acom -strict93 -dbg -work lpm $quartus_path/eda/sim_lib/220pack.vhd
acom -strict93 -dbg -work lpm $quartus_path/eda/sim_lib/220model.vhd

alib  vhdl_libs/sgate_vhdl
amap sgate vhdl_libs/sgate_vhdl
acom -strict93 -dbg -work sgate $quartus_path/eda/sim_lib/sgate_pack.vhd
acom -strict93 -dbg -work sgate $quartus_path/eda/sim_lib/sgate.vhd

alib  vhdl_libs/altera_mf_vhdl
amap altera_mf vhdl_libs/altera_mf_vhdl
acom -strict93 -dbg -work altera_mf $quartus_path/eda/sim_lib/altera_mf_components.vhd
acom -strict93 -dbg -work altera_mf $quartus_path/eda/sim_lib/altera_mf.vhd

alib  vhdl_libs/altera_lnsim_vhdl
amap altera_lnsim vhdl_libs/altera_lnsim_vhdl
alog  -sv2k5 -dbg -msg 0 -work altera_lnsim $quartus_path/eda/sim_lib/altera_lnsim.sv
acom -strict93 -dbg -work altera_lnsim $quartus_path/eda/sim_lib/altera_lnsim_components.vhd

alib  vhdl_libs/cycloneii_vhdl
amap cycloneii vhdl_libs/cycloneii_vhdl
acom -strict93 -dbg -work cycloneii $quartus_path/eda/sim_lib/cycloneii_atoms.vhd
acom -strict93 -dbg -work cycloneii $quartus_path/eda/sim_lib/cycloneii_components.vhd