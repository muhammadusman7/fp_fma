set_wire_load_mode "top"

create_clock -name clk -period 5.5 -waveform {0 2.75} [get_ports {clk}]
set_clock_uncertainty -setup 0.5 [get_clocks {clk}]
set_clock_uncertainty -hold 0.4 [get_clocks {clk}]
set_clock_transition -max 0.5 [get_clocks {clk}]
set_clock_transition -min 0.05 [get_clocks {clk}]

set_input_delay -clock [get_clocks clk] 1.5 rst_sipo
set_input_delay -clock [get_clocks clk] 1.5 rst_piso
set_input_delay -clock [get_clocks clk] 1.5 en_sipo
set_input_delay -clock [get_clocks clk] 1.5 din
set_input_delay -clock [get_clocks clk] 1.5 en_piso
set_input_delay -clock [get_clocks clk] 1.5 [get_ports mode]
set_input_delay -clock [get_clocks clk] 1.5 [get_ports precision]
set_input_delay -clock [get_clocks clk] 1.5 [get_ports op]
set_output_delay -clock [get_clocks clk] 1.5 rFlag
set_output_delay -clock [get_clocks clk] 1.5 dout
set_output_delay -clock [get_clocks clk] 1.5 tFlag

set_input_transition -max 1.1 rst_sipo
set_input_transition -max 1.1 rst_piso 
set_input_transition -max 1.1 en_sipo
set_input_transition -max 1.1 din
set_input_transition -max 1.1 en_piso
set_input_transition -max 1.1 [get_ports mode]
set_input_transition -max 1.1 [get_ports precision]
set_input_transition -max 1.1 [get_ports op]

set_clock_latency 0.25 [get_clocks {clk}]

set_load 2 -pin_load [get_ports {rFlag dout tFlag}]
