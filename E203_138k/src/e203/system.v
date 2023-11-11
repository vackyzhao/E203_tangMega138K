`timescale 1ns / 1ps

module system (
    output [31:0] inspect_pc,  
    input wire CLK50MHZ,  //50MHz_P16
    input wire mcu_rst_n, //MCU_S0_K16

    //gpioA
    inout wire [31:0] gpioA,  //GPIOA
    /*
    //GPIOA_0 :M25
    //GPIOA_1 :L20
    //GPIOA_2 :R26
    //GPIOA_3 :J14
    //GPIOA_4 :C21
    //GPIOA_5 :B20
        uart 0
         rx 16 c21
         tx 17 b20

    */
    //gpioB
    inout wire [31:0] gpioB,  //GPIOB

    // JD (used for JTAG connection)
    
    
    input wire mcu_TMS,  //MCU_A18
    inout wire mcu_TDO,  //MCU_R21    
    input wire mcu_TDI,  //MCU_A19
    input wire mcu_TCK,  //MCU_A20

    output pmu_paden,  //LED0_N23
    output pmu_padrst  //LED1_N21


);

  // All wires connected to the chip top
  wire dut_clock;
  wire dut_reset;

  wire dut_io_pads_jtag_TCK_i_ival;
  wire dut_io_pads_jtag_TMS_i_ival;
  wire dut_io_pads_jtag_TMS_o_oval;
  wire dut_io_pads_jtag_TMS_o_oe;
  wire dut_io_pads_jtag_TMS_o_ie;
  wire dut_io_pads_jtag_TMS_o_pue;
  wire dut_io_pads_jtag_TMS_o_ds;
  wire dut_io_pads_jtag_TDI_i_ival;
  wire dut_io_pads_jtag_TDO_o_oval;
  wire dut_io_pads_jtag_TDO_o_oe;

  wire [32-1:0] dut_io_pads_gpioA_i_ival;
  wire [32-1:0] dut_io_pads_gpioA_o_oval;
  wire [32-1:0] dut_io_pads_gpioA_o_oe;

  wire [32-1:0] dut_io_pads_gpioB_i_ival;
  wire [32-1:0] dut_io_pads_gpioB_o_oval;
  wire [32-1:0] dut_io_pads_gpioB_o_oe;


  wire dut_io_pads_aon_erst_n_i_ival;
  wire dut_io_pads_aon_pmu_vddpaden_o_oval;
  wire dut_io_pads_aon_pmu_padrst_o_oval;
  wire dut_io_pads_bootrom_n_i_ival;
  wire dut_io_pads_dbgmode0_n_i_ival;
  wire dut_io_pads_dbgmode1_n_i_ival;
  wire dut_io_pads_dbgmode2_n_i_ival;

  //=================================================
  // Clock & Reset

  wire clk16M, clk32768K;

  Gowin_PLL Gowin_PLL_dut (
      .clkout0(clk16M),
      .clkin  (CLK50MHZ)
  );

  clkdivider clkdivider_dut (
      .clk_in(clk16M),
      .clk_out(clk32768K)
  );



  //=================================================
  // IOBUF instantiation for GPIOs

  IOBUF gpioA_iobuf[31:0] (
      .O (dut_io_pads_gpioA_i_ival),
      .IO(gpioA),
      .I (dut_io_pads_gpioA_o_oval),
      .T (~dut_io_pads_gpioA_o_oe)
  );

  IOBUF gpioB_iobuf[31:0] (
      .O (dut_io_pads_gpioB_i_ival),
      .IO(gpioB),
      .I (dut_io_pads_gpioB_o_oval),
      .T (~dut_io_pads_gpioB_o_oe)
  );
  //=================================================
  // JTAG IOBUFs


  assign dut_io_pads_jtag_TCK_i_ival = mcu_TCK;
  assign dut_io_pads_jtag_TMS_i_ival = mcu_TMS;
  assign dut_io_pads_jtag_TDI_i_ival = mcu_TDI;

  wire iobuf_jtag_TDO_o;
  IOBUF IOBUF_jtag_TDO (
      .O (iobuf_jtag_TDO_o),
      .IO(mcu_TDO),
      .I (dut_io_pads_jtag_TDO_o_oval),
      .T (~dut_io_pads_jtag_TDO_o_oe)
  );

  //=================================================
  // Assignment of IOBUF "IO" pins to package pins

  // Pins IO0-IO13
  // Shield header row 0: PD0-PD7

  // Use the LEDs for some more useful debugging things.
  assign pmu_paden = dut_io_pads_aon_pmu_vddpaden_o_oval;
  assign pmu_padrst = dut_io_pads_aon_pmu_padrst_o_oval;

  //==================model select===================
  // 0:internal ROM    (0x0000_1000)~0x0000_1FFFF
  // 1:from QSPI_FLASH (0x2000_0000)
  assign dut_io_pads_bootrom_n_i_ival = 1'b0;
  //=================================================

  //
  assign dut_io_pads_dbgmode0_n_i_ival = 1'b1;
  assign dut_io_pads_dbgmode1_n_i_ival = 1'b1;
  assign dut_io_pads_dbgmode2_n_i_ival = 1'b1;
  //

  e203_soc_top e203_soc_top_inst (
    .inspect_pc(inspect_pc),
      .hfextclk(clk16M),
      .hfxoscen(),

      .lfextclk(clk32768K),
      .lfxoscen(),

      // Note: this is the real SoC top AON domain slow clock
      .io_pads_jtag_TCK_i_ival(dut_io_pads_jtag_TCK_i_ival),
      .io_pads_jtag_TMS_i_ival(dut_io_pads_jtag_TMS_i_ival),
      .io_pads_jtag_TDI_i_ival(dut_io_pads_jtag_TDI_i_ival),
      .io_pads_jtag_TDO_o_oval(dut_io_pads_jtag_TDO_o_oval),
      .io_pads_jtag_TDO_o_oe  (dut_io_pads_jtag_TDO_o_oe),

      .io_pads_gpioA_i_ival(dut_io_pads_gpioA_i_ival),
      .io_pads_gpioA_o_oval(dut_io_pads_gpioA_o_oval),
      .io_pads_gpioA_o_oe  (dut_io_pads_gpioA_o_oe),

      .io_pads_gpioB_i_ival(dut_io_pads_gpioB_i_ival),
      .io_pads_gpioB_o_oval(dut_io_pads_gpioB_o_oval),
      .io_pads_gpioB_o_oe  (dut_io_pads_gpioB_o_oe),


      .io_pads_qspi0_sck_o_oval (),
      .io_pads_qspi0_cs_0_o_oval(),

      .io_pads_qspi0_dq_0_i_ival(),
      .io_pads_qspi0_dq_0_o_oval(),
      .io_pads_qspi0_dq_0_o_oe  (),
      .io_pads_qspi0_dq_1_i_ival(),
      .io_pads_qspi0_dq_1_o_oval(),
      .io_pads_qspi0_dq_1_o_oe  (),
      .io_pads_qspi0_dq_2_i_ival(),
      .io_pads_qspi0_dq_2_o_oval(),
      .io_pads_qspi0_dq_2_o_oe  (),
      .io_pads_qspi0_dq_3_i_ival(),
      .io_pads_qspi0_dq_3_o_oval(),
      .io_pads_qspi0_dq_3_o_oe  (),

      // Note: this is the real SoC top level reset signal
      .io_pads_aon_erst_n_i_ival(mcu_rst_n),  // SoC顶层复位信号
      .io_pads_aon_pmu_dwakeup_n_i_ival(),  // PMU唤醒信号
      .io_pads_aon_pmu_vddpaden_o_oval(dut_io_pads_aon_pmu_vddpaden_o_oval),  // PMU VDDPADEN信号
      .io_pads_aon_pmu_padrst_o_oval(dut_io_pads_aon_pmu_padrst_o_oval),  // PMU PAD复位信号
      .io_pads_bootrom_n_i_ival(dut_io_pads_bootrom_n_i_ival),  // BootROM复位信号
      .io_pads_dbgmode0_n_i_ival(dut_io_pads_dbgmode0_n_i_ival),  // 调试模式0
      .io_pads_dbgmode1_n_i_ival(dut_io_pads_dbgmode1_n_i_ival),  // 调试模式1
      .io_pads_dbgmode2_n_i_ival(dut_io_pads_dbgmode2_n_i_ival)  // 调试模式2
  );




endmodule


