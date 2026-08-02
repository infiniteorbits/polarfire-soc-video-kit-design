//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Sun Aug  2 14:30:06 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// CLOCKS_AND_RESETS
module CLOCKS_AND_RESETS(
    // Inputs
    CLK_PF_DDR4,
    EXT_RST_N,
    MSS_PLL_LOCKS,
    PLL_LOCK_PF_DDR4,
    REF_CLK_PAD_N,
    REF_CLK_PAD_P,
    // Outputs
    CLK_125MHz,
    CLK_50MHz,
    DDR_RESETN,
    DEVICE_INIT_DONE,
    FABRIC_POR_N,
    I2C_BCLK,
    RESETN_125MHz,
    RESETN_50MHz,
    RESETN_PLL
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  CLK_PF_DDR4;
input  EXT_RST_N;
input  MSS_PLL_LOCKS;
input  PLL_LOCK_PF_DDR4;
input  REF_CLK_PAD_N;
input  REF_CLK_PAD_P;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output CLK_125MHz;
output CLK_50MHz;
output DDR_RESETN;
output DEVICE_INIT_DONE;
output FABRIC_POR_N;
output I2C_BCLK;
output RESETN_125MHz;
output RESETN_50MHz;
output RESETN_PLL;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   AND2_0_Y;
wire   AND2_1_Y;
wire   CLK_50MHz_net_0;
wire   CLK_125MHz_net_0;
wire   CLK_PF_DDR4;
wire   DDR_RESETN_net_0;
wire   DEVICE_INIT_DONE_net_0;
wire   EXT_RST_N;
wire   FABRIC_POR_N_net_0;
wire   I2C_BCLK_net_0;
wire   INIT_MONITOR_0_BANK_0_CALIB_STATUS;
wire   INIT_MONITOR_0_BANK_8_CALIB_STATUS;
wire   MSS_PLL_LOCKS;
wire   PF_CCC_C0_0_PLL_LOCK_0;
wire   PF_OSC_C0_0_RCOSC_2MHZ_CLK_DIV;
wire   PF_XCVR_REF_CLK_C0_0_FAB_REF_CLK;
wire   PLL_LOCK_PF_DDR4;
wire   REF_CLK_PAD_N;
wire   REF_CLK_PAD_P;
wire   RESETN_50MHz_net_0;
wire   RESETN_125MHz_net_0;
wire   RESETN_PLL_net_0;
wire   CLK_125MHz_net_1;
wire   CLK_50MHz_net_1;
wire   DDR_RESETN_net_1;
wire   DEVICE_INIT_DONE_net_1;
wire   FABRIC_POR_N_net_1;
wire   I2C_BCLK_net_1;
wire   RESETN_125MHz_net_1;
wire   RESETN_50MHz_net_1;
wire   RESETN_PLL_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   VCC_net;
wire   GND_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CLK_125MHz_net_1       = CLK_125MHz_net_0;
assign CLK_125MHz             = CLK_125MHz_net_1;
assign CLK_50MHz_net_1        = CLK_50MHz_net_0;
assign CLK_50MHz              = CLK_50MHz_net_1;
assign DDR_RESETN_net_1       = DDR_RESETN_net_0;
assign DDR_RESETN             = DDR_RESETN_net_1;
assign DEVICE_INIT_DONE_net_1 = DEVICE_INIT_DONE_net_0;
assign DEVICE_INIT_DONE       = DEVICE_INIT_DONE_net_1;
assign FABRIC_POR_N_net_1     = FABRIC_POR_N_net_0;
assign FABRIC_POR_N           = FABRIC_POR_N_net_1;
assign I2C_BCLK_net_1         = I2C_BCLK_net_0;
assign I2C_BCLK               = I2C_BCLK_net_1;
assign RESETN_125MHz_net_1    = RESETN_125MHz_net_0;
assign RESETN_125MHz          = RESETN_125MHz_net_1;
assign RESETN_50MHz_net_1     = RESETN_50MHz_net_0;
assign RESETN_50MHz           = RESETN_50MHz_net_1;
assign RESETN_PLL_net_1       = RESETN_PLL_net_0;
assign RESETN_PLL             = RESETN_PLL_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AND2
AND2 AND2_0(
        // Inputs
        .A ( PF_CCC_C0_0_PLL_LOCK_0 ),
        .B ( MSS_PLL_LOCKS ),
        // Outputs
        .Y ( AND2_0_Y ) 
        );

//--------AND2
AND2 AND2_1(
        // Inputs
        .A ( INIT_MONITOR_0_BANK_0_CALIB_STATUS ),
        .B ( INIT_MONITOR_0_BANK_8_CALIB_STATUS ),
        // Outputs
        .Y ( AND2_1_Y ) 
        );

//--------AND2
AND2 AND2_2(
        // Inputs
        .A ( PF_CCC_C0_0_PLL_LOCK_0 ),
        .B ( AND2_1_Y ),
        // Outputs
        .Y ( RESETN_PLL_net_0 ) 
        );

//--------CORERESET_PF_C5
CORERESET_PF_C5 CORERESET_CLK_50MHz(
        // Inputs
        .CLK                ( CLK_50MHz_net_0 ),
        .EXT_RST_N          ( EXT_RST_N ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( AND2_0_Y ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( DEVICE_INIT_DONE_net_0 ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( FABRIC_POR_N_net_0 ),
        // Outputs
        .PLL_POWERDOWN_B    (  ),
        .FABRIC_RESET_N     ( RESETN_50MHz_net_0 ) 
        );

//--------CORERESET
CORERESET CORERESET_CLK_125MHz(
        // Inputs
        .CLK                ( CLK_125MHz_net_0 ),
        .EXT_RST_N          ( EXT_RST_N ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( AND2_0_Y ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( DEVICE_INIT_DONE_net_0 ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( FABRIC_POR_N_net_0 ),
        // Outputs
        .PLL_POWERDOWN_B    (  ),
        .FABRIC_RESET_N     ( RESETN_125MHz_net_0 ) 
        );

//--------CORERESET_PF_DDR4
CORERESET_PF_DDR4 CORERESET_PF_DDR4_0(
        // Inputs
        .CLK                ( CLK_PF_DDR4 ),
        .EXT_RST_N          ( EXT_RST_N ),
        .BANK_x_VDDI_STATUS ( VCC_net ),
        .BANK_y_VDDI_STATUS ( VCC_net ),
        .PLL_LOCK           ( PLL_LOCK_PF_DDR4 ),
        .SS_BUSY            ( GND_net ),
        .INIT_DONE          ( DEVICE_INIT_DONE_net_0 ),
        .FF_US_RESTORE      ( GND_net ),
        .FPGA_POR_N         ( FABRIC_POR_N_net_0 ),
        // Outputs
        .PLL_POWERDOWN_B    (  ),
        .FABRIC_RESET_N     ( DDR_RESETN_net_0 ) 
        );

//--------INIT_MONITOR
INIT_MONITOR INIT_MONITOR_0(
        // Outputs
        .FABRIC_POR_N               ( FABRIC_POR_N_net_0 ),
        .PCIE_INIT_DONE             (  ),
        .USRAM_INIT_DONE            (  ),
        .SRAM_INIT_DONE             (  ),
        .DEVICE_INIT_DONE           ( DEVICE_INIT_DONE_net_0 ),
        .BANK_0_CALIB_STATUS        ( INIT_MONITOR_0_BANK_0_CALIB_STATUS ),
        .BANK_8_CALIB_STATUS        ( INIT_MONITOR_0_BANK_8_CALIB_STATUS ),
        .XCVR_INIT_DONE             (  ),
        .USRAM_INIT_FROM_SNVM_DONE  (  ),
        .USRAM_INIT_FROM_UPROM_DONE (  ),
        .USRAM_INIT_FROM_SPI_DONE   (  ),
        .SRAM_INIT_FROM_SNVM_DONE   (  ),
        .SRAM_INIT_FROM_UPROM_DONE  (  ),
        .SRAM_INIT_FROM_SPI_DONE    (  ),
        .AUTOCALIB_DONE             (  ) 
        );

//--------PF_CCC_C0
PF_CCC_C0 PF_CCC_C0_0(
        // Inputs
        .REF_CLK_0     ( PF_XCVR_REF_CLK_C0_0_FAB_REF_CLK ),
        // Outputs
        .OUT0_FABCLK_0 ( CLK_125MHz_net_0 ),
        .OUT1_FABCLK_0 ( CLK_50MHz_net_0 ),
        .PLL_LOCK_0    ( PF_CCC_C0_0_PLL_LOCK_0 ) 
        );

//--------PF_CLK_DIV_C0
PF_CLK_DIV_C0 PF_CLK_DIV_C0_0(
        // Inputs
        .CLK_IN  ( PF_OSC_C0_0_RCOSC_2MHZ_CLK_DIV ),
        // Outputs
        .CLK_OUT ( I2C_BCLK_net_0 ) 
        );

//--------PF_OSC_C0
PF_OSC_C0 PF_OSC_C0_0(
        // Outputs
        .RCOSC_2MHZ_CLK_DIV ( PF_OSC_C0_0_RCOSC_2MHZ_CLK_DIV ) 
        );

//--------PF_XCVR_REF_CLK_C0
PF_XCVR_REF_CLK_C0 PF_XCVR_REF_CLK_C0_0(
        // Inputs
        .REF_CLK_PAD_P ( REF_CLK_PAD_P ),
        .REF_CLK_PAD_N ( REF_CLK_PAD_N ),
        // Outputs
        .REF_CLK       (  ),
        .FAB_REF_CLK   ( PF_XCVR_REF_CLK_C0_0_FAB_REF_CLK ) 
        );


endmodule
