include load_etc.tcl

set DESIGN top
set top_module top

set SYN_EFF medium
set MAP_EFF medium

set_attribute lib_search_path ../Implementation/LIB
set_attribute library {../Implementation/sky130_fd_sc_hd__tt_025C_1v80.lib}

read_hdl -v2001 {../RTL/top.v
    ../RTL/adder.v
    ../RTL/addition.v
    ../RTL/alignShift.v
    ../RTL/boothEnc.v
    ../RTL/boothPPCal.v
    ../RTL/boothPP.v
    ../RTL/boothSel.v
    ../RTL/claAdder4.v
    ../RTL/comp3to2.v
    ../RTL/expAdd.v
    ../RTL/fma.v
    ../RTL/fullAdder.v
    ../RTL/halfAdder.v
    ../RTL/lod.v
    ../RTL/multiplication.v
    ../RTL/multiplier53Booth.v
    ../RTL/normalize.v
    ../RTL/normnround.v
    ../RTL/operand.v
    ../RTL/piso.v
    ../RTL/register.v
    ../RTL/rounding.v
    ../RTL/signExpMul.v
    ../RTL/sipo.v} 

elaborate $DESIGN
check_design $DESIGN -unresolved

read_sdc constraint.sdc

set_attribute syn_generic_effort medium 
set_attribute syn_map_effort medium
set_attribute syn_opt_effort medium

syn_generic $DESIGN
syn_map $DESIGN
syn_opt $DESIGN

report area >> ./RPT/${DESIGN}_area.rpt
report gates >> ./RPT/${DESIGN}_gates.rpt
report timing -full_pin_names >> ./RPT/${DESIGN}_timing.rpt
report power >> ./RPT/${DESIGN}_power.rpt
write_hdl $DESIGN -mapped >> ./Netlist/${DESIGN}_map.v
write_sdc $DESIGN >> ./${DESIGN}_map.sdc
