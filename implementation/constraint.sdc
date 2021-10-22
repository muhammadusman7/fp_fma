set_wire_load_mode "top"

create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
set_clock_uncertainty -setup  1 [get_clocks {clk}]
set_clock_uncertainty -hold 0.5 [get_clocks {clk}]
set_clock_transition -max  0.5 [get_clocks {clk}]
set_clock_transition -min  0.05 [get_clocks {clk}]

set_input_delay -clock [get_clocks clk] 2.4 rst_sipo
set_input_delay -clock [get_clocks clk] 2.4 rst_piso
set_input_delay -clock [get_clocks clk] 2.4 en_sipo
set_input_delay -clock [get_clocks clk] 2.4 din
set_input_delay -clock [get_clocks clk] 2.4 en_piso
set_input_delay -clock [get_clocks clk] 2.4 [get_ports mode]
set_input_delay -clock [get_clocks clk] 2.4 [get_ports precision]
set_input_delay -clock [get_clocks clk] 2.4 [get_ports op]
set_output_delay -clock [get_clocks clk] 2.4 rFlag
set_output_delay -clock [get_clocks clk] 2.4 dout
set_output_delay -clock [get_clocks clk] 2.4 tFlag

set_input_transition -max 1.6 rst_spio
set_input_transition -max 1.6 rst_piso
set_input_transition -max 1.6 en_sipo
set_input_transition -max 1.6 din
set_input_transition -max 1.6 en_piso
set_input_transition -max 1.6 mode
set_input_transition -max 1.6 precision
set_input_transition -max 1.6 op

set_propagated_clock [get_clocks {clk}]

set_load 2 -pin_load [get_ports {rFlag dout tFlag}]