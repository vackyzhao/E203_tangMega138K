//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-2
//Created Time: 2023-08-29 17:19:53
create_clock -name clk16 -period 62.5 -waveform {0 31.25} [get_ports {clk_16M}] -add
create_clock -name clk8388k -period 119.218 -waveform {0 59.609} [get_ports {clk_8388}] -add
