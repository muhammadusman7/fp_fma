# ####################################################################

#  Created by Genus(TM) Synthesis Solution 19.14-s110_1 on Wed Oct 20 20:17:22 PKT 2021

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design top

create_clock -name "clk" -period 5.5 -waveform {0.0 2.75} [get_ports clk]
set_clock_transition -min 0.05 [get_clocks clk]
set_clock_transition -max 0.5 [get_clocks clk]
set_load -pin_load 2.0 [get_ports rFlag]
set_load -pin_load 2.0 [get_ports dout]
set_load -pin_load 2.0 [get_ports tFlag]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports rst_sipo]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports rst_piso]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports en_sipo]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports din]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports en_piso]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {mode[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {mode[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {precision[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {precision[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {op[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports {op[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports rFlag]
set_output_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports dout]
set_output_delay -clock [get_clocks clk] -add_delay 1.5 [get_ports tFlag]
set_input_transition -max 1.1 [get_ports rst_sipo]
set_input_transition -max 1.1 [get_ports rst_piso]
set_input_transition -max 1.1 [get_ports en_sipo]
set_input_transition -max 1.1 [get_ports din]
set_input_transition -max 1.1 [get_ports en_piso]
set_input_transition -max 1.1 [get_ports {mode[1]}]
set_input_transition -max 1.1 [get_ports {mode[0]}]
set_input_transition -max 1.1 [get_ports {precision[1]}]
set_input_transition -max 1.1 [get_ports {precision[0]}]
set_input_transition -max 1.1 [get_ports {op[1]}]
set_input_transition -max 1.1 [get_ports {op[0]}]
set_wire_load_mode "top"
set_clock_uncertainty -setup 0.5 [get_clocks clk]
set_clock_uncertainty -hold 0.4 [get_clocks clk]
set_clock_latency  0.25 [get_clocks clk]
