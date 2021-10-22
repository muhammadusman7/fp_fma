set init_pwr_net VDD
set init_gnd_net VSS
set init_io_file top_FMA.io
set init_lef_file {LEF/sky130_fd_sc_hd_mod.tlef LEF/sky130_fd_sc_hd.lef}
set init_mmmc_file top.view
set init_verilog ../Synthesis/Netlist/top_map.v
set init_top_cell top
init_design

## Floorplan
getIoFlowFlag
setIoFlowFlag 0
floorPlan -site unithd -d 1500 1000 60 60 60 60
# Width Hight Left Right Top Bottom
uiSetTool select
getIoFlowFlag
setDesignMode -process 150
fit
global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.8
defOut -floorplan Floorplan/floorplan.def
saveDesign Floorplan/floorplan.inv
dumpPictures -dir ./Floorplan -fullScreen -prefix Floorplan

## Powerplan
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer met5 -stacked_via_bottom_layer li1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top met3 bottom met3 left met4 right met4} -width {top 20 bottom 20 left 20 right 20} -spacing {top 5 bottom 5 left 5 right 5} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None

# Add Strips
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer met5 -stacked_via_bottom_layer li1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring } -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape   }
addStripe -nets {VDD VSS} -layer met4 -direction vertical -width 5 -spacing 3 -set_to_set_distance 75 -start_from left -start 120 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit met5 -padcore_ring_bottom_layer_limit li1 -block_ring_top_layer_limit met5 -block_ring_bottom_layer_limit li1 -use_wire_group 0 -snap_wire_center_to_grid None

# Globle Net Connections
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VPWR -instanceBasename * -override -verbose
globalNetConnect VDD -type tiehi -pin VPWR -instanceBasename * -override -verbose
globalNetConnect VDD -type net -net VPWR -override -verbose
globalNetConnect VSS -type pgpin -pin VGND -instanceBasename * -override -verbose
globalNetConnect VSS -type tielo -pin VGND -instanceBasename * -override -verbose
globalNetConnect VSS -type net -net VGND -override -verbose
globalNetConnect VDD -type pgpin -pin VDD -instanceBasename * -override -verbose
globalNetConnect VDD -type tiehi -pin VDD -instanceBasename * -override -verbose
globalNetConnect VDD -type net -net VDD -override -verbose
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename * -override -verbose
globalNetConnect VSS -type tielo -pin VSS -instanceBasename * -override -verbose
globalNetConnect VSS -type net -net VSS -override -verbose
globalNetConnect VDD -type net -net VDD -override -verbose
globalNetConnect VSS -type net -net VSS -override -verbose
globalNetConnect VDD -type pgpin -pin VPWRIN -instanceBasename * -override -verbose
globalNetConnect VDD -type tiehi -pin VPWRIN -instanceBasename * -override -verbose
globalNetConnect VDD -type pgpin -pin LOWLVPWR -instanceBasename * -override -verbose
globalNetConnect VDD -type tiehi -pin LOWLVPWR -instanceBasename * -override -verbose
globalNetConnect VDD -type pgpin -pin KAPWR -instanceBasename * -override -verbose
globalNetConnect VDD -type tiehi -pin KAPWR -instanceBasename * -override -verbose

# Special Route
setSrouteMode -viaConnectToShape { stripe }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { li1(1) met5(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { li1(1) met5(6) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { li1(1) met5(6) }
saveDesign Powerplan/powerplan.inv
dumpPictures -dir ./Powerplan -fullScreen -prefix Powerplan

## Add Well Tap
addWellTap -cell sky130_fd_sc_hd__tapvpwrvgnd_1 -cellInterval 30 -inRowOffset 15 -prefix WELLTAP
saveDesign Welltaps/welltaps.inv
dumpPictures -dir ./Welltaps -fullScreen -prefix WellTaps


## Std Cell Placement
setMultiCpuUsage -localCpu 8 -cpuPerRemoteHost 1 -remoteHost 0 -keepLicense true
setDistributeHost -local
setPlaceMode -fp false
place_opt_design
setTieHiLoMode -reset
setTieHiLoMode -cell sky130_fd_sc_hd__conb_1 -maxFanOut 10 -honorDontTouch false -createHierPort false
addTieHiLo -cell sky130_fd_sc_hd__conb_1 -prefix TIE

# Timming Reports (Post Place)
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix top_postPlace -outDir timingReports
saveDesign Placement/placement.inv
dumpPictures -dir ./Placement -fullScreen -prefix StdCellPlacement

## pre CTS Optimization
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -droutePostRouteSpreadWire 1
setNanoRouteMode -quiet -timingEngine {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {sky130_fd_sc_hd__probec_p_8 sky130_fd_sc_hd__probe_p_8 sky130_fd_sc_hd__lpflow_clkbufkapwr_8 sky130_fd_sc_hd__lpflow_clkbufkapwr_4 sky130_fd_sc_hd__lpflow_clkbufkapwr_2 sky130_fd_sc_hd__lpflow_clkbufkapwr_16 sky130_fd_sc_hd__lpflow_clkbufkapwr_1 sky130_fd_sc_hd__dlymetal6s6s_1 sky130_fd_sc_hd__dlymetal6s4s_1 sky130_fd_sc_hd__dlymetal6s2s_1 sky130_fd_sc_hd__dlygate4sd3_1 sky130_fd_sc_hd__dlygate4sd2_1 sky130_fd_sc_hd__dlygate4sd1_1 sky130_fd_sc_hd__clkdlybuf4s50_2 sky130_fd_sc_hd__clkdlybuf4s50_1 sky130_fd_sc_hd__clkdlybuf4s25_2 sky130_fd_sc_hd__clkdlybuf4s25_1 sky130_fd_sc_hd__clkdlybuf4s18_2 sky130_fd_sc_hd__clkdlybuf4s18_1 sky130_fd_sc_hd__clkdlybuf4s15_2 sky130_fd_sc_hd__clkdlybuf4s15_1 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_16 sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__bufbuf_8 sky130_fd_sc_hd__bufbuf_16 sky130_fd_sc_hd__buf_8 sky130_fd_sc_hd__buf_6 sky130_fd_sc_hd__buf_4 sky130_fd_sc_hd__buf_2 sky130_fd_sc_hd__buf_16 sky130_fd_sc_hd__buf_12 sky130_fd_sc_hd__buf_1 sky130_fd_sc_hd__lpflow_clkinvkapwr_8 sky130_fd_sc_hd__lpflow_clkinvkapwr_4 sky130_fd_sc_hd__lpflow_clkinvkapwr_2 sky130_fd_sc_hd__lpflow_clkinvkapwr_16 sky130_fd_sc_hd__lpflow_clkinvkapwr_1 sky130_fd_sc_hd__inv_8 sky130_fd_sc_hd__inv_6 sky130_fd_sc_hd__inv_4 sky130_fd_sc_hd__inv_2 sky130_fd_sc_hd__inv_16 sky130_fd_sc_hd__inv_12 sky130_fd_sc_hd__inv_1 sky130_fd_sc_hd__clkinvlp_4 sky130_fd_sc_hd__clkinvlp_2 sky130_fd_sc_hd__clkinv_8 sky130_fd_sc_hd__clkinv_4 sky130_fd_sc_hd__clkinv_2 sky130_fd_sc_hd__clkinv_16 sky130_fd_sc_hd__clkinv_1 sky130_fd_sc_hd__bufinv_8 sky130_fd_sc_hd__bufinv_16} -maxAllowedDelay 1
setOptMode -effort high -powerEffort low -leakageToDynamicRatio 1 -reclaimArea true -simplifyNetlist true -allEndPoints false -setupTargetSlack 0.5 -holdTargetSlack 0.3 -maxDensity 0.95 -drcMargin 0 -usefulSkew true
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS

redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix top_preCTS -outDir timingReports
saveDesign preCTS/preCTS.inv


## CTS
create_ccopt_clock_tree_spec -file ccopt.spec
all_constraint_modes -active
set_interactive_constraint_modes [all_constraint_modes -active]
source ccopt.spec
ccopt_design -cts

# Post CTS Setup Report
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix top_postCTS -outDir timingReports

# Post CTS Optimzations Setup
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS
saveDesign postCTS/postCTS.inv

# Optimizations post CTS Hold
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS -hold
#Repoerts Genrations
report_timing -check_type setup >> ./postCTS/setup_report.rpt
report_clocks >> ./postCTS/clocks.rpt
setAnalysisMode -checkType hold
report_timing -check_type hold >> ./postCTS/hold_report.rpt
report_power >> ./postCTS/power_report.rpt
report_constraint -all_violators >> ./postCTS/violations_report.rpt
report_ccopt_skew_groups -summary >> ./postCTS/skew_summary.rpt


## Add Filler
addFiller -cell sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1 -prefix FILLER -doDRC
saveDesign Filler/Filler.inv

## Nano Route
setNanoRouteMode -quiet -routeInsertAntennaDiode 1
setNanoRouteMode -quiet -routeAntennaCellName sky130_fd_sc_hd__diode_2
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven 1
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail
saveDesign nanoRoute/nanoRoute.inv
dumpPictures -dir ./nanoRoute -fullScreen -prefix nanoRoute

# Post Route Opt
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute
optDesign -postRoute -hold -setup
saveDesign Final/Final.inv
streamOut fma_gds.gds -mapFile GDS/sky130_lefpin.map -libName DesignLib -merge { GDS/sky130_fd_sc_hd.gds } -units 1000 -mode ALL
