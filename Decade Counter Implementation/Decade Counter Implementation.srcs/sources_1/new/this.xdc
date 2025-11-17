# constraints/DecadeCounter_noCKB.xdc
# Spartan-7 (-1) XDC for DecadeCounter when CKB is not an external port.

# CKA clock (example: 100 MHz)
set_property PACKAGE_PIN W5 [get_ports CKA]
set_property IOSTANDARD LVCMOS33 [get_ports CKA]
create_clock -name CKA_clk -period 10.000 -waveform {0 5} [get_ports CKA]

# Async controls
set_property PACKAGE_PIN P17 [get_ports MR1]
set_property IOSTANDARD LVCMOS33 [get_ports MR1]
set_property PACKAGE_PIN P18 [get_ports MR2]
set_property IOSTANDARD LVCMOS33 [get_ports MR2]
set_property PACKAGE_PIN N17 [get_ports MS1]
set_property IOSTANDARD LVCMOS33 [get_ports MS1]
set_property PACKAGE_PIN N18 [get_ports MS2]
set_property IOSTANDARD LVCMOS33 [get_ports MS2]
# Optional:
# set_property PULLUP true [get_ports {MR1 MR2 MS1 MS2}]

# Outputs
set_property PACKAGE_PIN V17 [get_ports QA]
set_property IOSTANDARD LVCMOS33 [get_ports QA]
set_property DRIVE 8 [get_ports QA]
set_property SLEW SLOW [get_ports QA]

set_property PACKAGE_PIN V16 [get_ports QB]
set_property IOSTANDARD LVCMOS33 [get_ports QB]
set_property DRIVE 8 [get_ports QB]
set_property SLEW SLOW [get_ports QB]

set_property PACKAGE_PIN U16 [get_ports QC]
set_property IOSTANDARD LVCMOS33 [get_ports QC]
set_property DRIVE 8 [get_ports QC]
set_property SLEW SLOW [get_ports QC]

set_property PACKAGE_PIN T16 [get_ports QD]
set_property IOSTANDARD LVCMOS33 [get_ports QD]
set_property DRIVE 8 [get_ports QD]
set_property SLEW SLOW [get_ports QD]

# Notes:
# - No constraints for CKB because it’s not a port.
# - Do not create a clock on QA.

