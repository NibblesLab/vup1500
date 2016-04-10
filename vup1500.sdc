## Generated SDC file "vup1500.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"

## DATE    "Wed Jan 27 00:23:10 2016"

##
## DEVICE  "10M08DAF484C8GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {SYS_CLK} -period 20.000 -waveform { 0.000 10.000 } [get_ports {SYS_CLK}]
create_clock -name {USER_CLK} -period 41.666 -waveform { 0.000 20.833 } [get_ports {USER_CLK}]
create_clock -name {videoout:VIDEO0|CNT57M[2]} -period 139.683 -waveform { 0.000 69.841 } 
create_clock -name {GPIO_J4_31} -period 279.365 -waveform { 0.000 139.682 } 


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 63 -divide_by 55 -master_clock {SYS_CLK} [get_pins {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {CKGEN0|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {CKGEN0|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {SYS_CLK} [get_pins {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path  -from  [get_clocks {VIDEO0|VCKGEN|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {CKGEN0|altpll_component|auto_generated|pll1|clk[0]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

