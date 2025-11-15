## Clock signal (125 MHz onboard clock)
set_property PACKAGE_PIN H16 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 8.000 [get_ports {clk}]

## Reset Button (BTN0)
set_property PACKAGE_PIN N17 [get_ports {srstn}]
set_property IOSTANDARD LVCMOS33 [get_ports {srstn}]

## Start Button (BTN1)
set_property PACKAGE_PIN M18 [get_ports {tpu_start}]
set_property IOSTANDARD LVCMOS33 [get_ports {tpu_start}]

## Done LED (LED0)
set_property PACKAGE_PIN R14 [get_ports {led0}]
set_property IOSTANDARD LVCMOS33 [get_ports {led0}]
