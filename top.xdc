## Clock input (100 MHz oscillator)
set_property PACKAGE_PIN F14 [get_ports {CKA}]
set_property IOSTANDARD LVCMOS33 [get_ports {CKA}]
create_clock -period 10.0 -name clk_100MHz [get_ports {CKA}]

## Asynchronous Reset Inputs
set_property PACKAGE_PIN V2 [get_ports {MR1}]
set_property IOSTANDARD LVCMOS33 [get_ports {MR1}]
set_property PACKAGE_PIN U2 [get_ports {MR2}]
set_property IOSTANDARD LVCMOS33 [get_ports {MR2}]

## Asynchronous Preset Inputs
set_property PACKAGE_PIN U1 [get_ports {MS1}]
set_property IOSTANDARD LVCMOS33 [get_ports {MS1}]
set_property PACKAGE_PIN T2 [get_ports {MS2}]
set_property IOSTANDARD LVCMOS33 [get_ports {MS2}]

## Counter outputs to LEDs
set_property PACKAGE_PIN G1 [get_ports {QA}]
set_property IOSTANDARD LVCMOS33 [get_ports {QA}]
set_property PACKAGE_PIN G2 [get_ports {QB}]
set_property IOSTANDARD LVCMOS33 [get_ports {QB}]
set_property PACKAGE_PIN F1 [get_ports {QC}]
set_property IOSTANDARD LVCMOS33 [get_ports {QC}]
set_property PACKAGE_PIN F2 [get_ports {QD}]
set_property IOSTANDARD LVCMOS33 [get_ports {QD}]