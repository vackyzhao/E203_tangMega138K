//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: V1.9.9 Beta-5
//Created Time: 2023-10-15 16:07:59
create_clock -name CLK16m -period 20 -waveform {0 10} [get_ports {CLK50MHZ}] -add
