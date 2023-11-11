//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: V1.9.9 Beta-5
//Created Time: 2023-11-10 23:30:57
create_clock -name clk50M -period 20 -waveform {0 10} [get_ports {CLK50MHZ}] -add

//create_generated_clock -name clk16M -source [get_ports {CLK50MHZ}] -master_clock clk50M -divide_by 50 -multiply_by 16 -add [get_nets {clk16M}]
//create_generated_clock -name clk32676k -source [get_nets {clk16M}] -master_clock clk16M -divide_by 488 -add [get_nets {clk32768K}]
