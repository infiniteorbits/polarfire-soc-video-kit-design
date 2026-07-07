//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Wed Jun 24 15:40:12 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// ddr_write
module ddr_write(
    // Inputs
    apb_pin,
    // Outputs
    CTRLR_READY,
    DDR_A,
    DDR_ACT_N,
    DDR_BA,
    DDR_BG,
    DDR_CAS_N,
    DDR_CK0,
    DDR_CK0_N,
    DDR_CKE_0,
    DDR_CS_N,
    DDR_DM_N,
    DDR_ODT_0,
    DDR_RAS_N,
    DDR_RESET_N_0,
    DDR_SHIELD0,
    DDR_SHIELD1,
    DDR_WE_N,
    // Inouts
    DDR_DQS_0,
    DDR_DQS_N_0,
    DDR_DQ_0
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         apb_pin;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        CTRLR_READY;
output [13:0] DDR_A;
output        DDR_ACT_N;
output [1:0]  DDR_BA;
output        DDR_BG;
output        DDR_CAS_N;
output        DDR_CK0;
output        DDR_CK0_N;
output        DDR_CKE_0;
output        DDR_CS_N;
output [1:0]  DDR_DM_N;
output        DDR_ODT_0;
output        DDR_RAS_N;
output        DDR_RESET_N_0;
output        DDR_SHIELD0;
output        DDR_SHIELD1;
output        DDR_WE_N;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  [1:0]  DDR_DQS_0;
inout  [1:0]  DDR_DQS_N_0;
inout  [15:0] DDR_DQ_0;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          apb_pin;
wire          CLK_GEN_C0_0_CLK;
wire          CLK_GEN_C1_0_CLK;
wire          CTRLR_READY_net_0;
wire   [13:0] DDR_A_net_0;
wire          DDR_ACT_N_net_0;
wire   [1:0]  DDR_BA_net_0;
wire          DDR_BG_net_0;
wire          DDR_CAS_N_net_0;
wire          DDR_CK0_net_0;
wire          DDR_CK0_N_net_0;
wire          DDR_CKE_0_net_0;
wire          DDR_CS_N_net_0;
wire   [1:0]  DDR_DM_N_net_0;
wire   [15:0] DDR_DQ_0;
wire   [1:0]  DDR_DQS_0;
wire   [1:0]  DDR_DQS_N_0;
wire          DDR_ODT_0_net_0;
wire          DDR_RAS_N_net_0;
wire          DDR_RESET_N_0_net_0;
wire          DDR_SHIELD0_net_0;
wire          DDR_SHIELD1_net_0;
wire          DDR_WE_N_net_0;
wire          DDR_SHIELD1_net_1;
wire          DDR_SHIELD0_net_1;
wire          DDR_CK0_N_net_1;
wire          DDR_CK0_net_1;
wire          DDR_RESET_N_0_net_1;
wire          DDR_BG_net_1;
wire          DDR_ACT_N_net_1;
wire          DDR_WE_N_net_1;
wire          DDR_CAS_N_net_1;
wire          DDR_RAS_N_net_1;
wire          DDR_ODT_0_net_1;
wire          DDR_CKE_0_net_1;
wire          DDR_CS_N_net_1;
wire          CTRLR_READY_net_1;
wire   [13:0] DDR_A_net_1;
wire   [1:0]  DDR_BA_net_1;
wire   [1:0]  DDR_DM_N_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          REFCLK_N_IN_POST_INV0_0;
wire          REF_CLK_PAD_N_IN_POST_INV1_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign REFCLK_N_IN_POST_INV0_0      = ~ CLK_GEN_C1_0_CLK;
assign REF_CLK_PAD_N_IN_POST_INV1_0 = ~ CLK_GEN_C0_0_CLK;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign DDR_SHIELD1_net_1   = DDR_SHIELD1_net_0;
assign DDR_SHIELD1         = DDR_SHIELD1_net_1;
assign DDR_SHIELD0_net_1   = DDR_SHIELD0_net_0;
assign DDR_SHIELD0         = DDR_SHIELD0_net_1;
assign DDR_CK0_N_net_1     = DDR_CK0_N_net_0;
assign DDR_CK0_N           = DDR_CK0_N_net_1;
assign DDR_CK0_net_1       = DDR_CK0_net_0;
assign DDR_CK0             = DDR_CK0_net_1;
assign DDR_RESET_N_0_net_1 = DDR_RESET_N_0_net_0;
assign DDR_RESET_N_0       = DDR_RESET_N_0_net_1;
assign DDR_BG_net_1        = DDR_BG_net_0;
assign DDR_BG              = DDR_BG_net_1;
assign DDR_ACT_N_net_1     = DDR_ACT_N_net_0;
assign DDR_ACT_N           = DDR_ACT_N_net_1;
assign DDR_WE_N_net_1      = DDR_WE_N_net_0;
assign DDR_WE_N            = DDR_WE_N_net_1;
assign DDR_CAS_N_net_1     = DDR_CAS_N_net_0;
assign DDR_CAS_N           = DDR_CAS_N_net_1;
assign DDR_RAS_N_net_1     = DDR_RAS_N_net_0;
assign DDR_RAS_N           = DDR_RAS_N_net_1;
assign DDR_ODT_0_net_1     = DDR_ODT_0_net_0;
assign DDR_ODT_0           = DDR_ODT_0_net_1;
assign DDR_CKE_0_net_1     = DDR_CKE_0_net_0;
assign DDR_CKE_0           = DDR_CKE_0_net_1;
assign DDR_CS_N_net_1      = DDR_CS_N_net_0;
assign DDR_CS_N            = DDR_CS_N_net_1;
assign CTRLR_READY_net_1   = CTRLR_READY_net_0;
assign CTRLR_READY         = CTRLR_READY_net_1;
assign DDR_A_net_1         = DDR_A_net_0;
assign DDR_A[13:0]         = DDR_A_net_1;
assign DDR_BA_net_1        = DDR_BA_net_0;
assign DDR_BA[1:0]         = DDR_BA_net_1;
assign DDR_DM_N_net_1      = DDR_DM_N_net_0;
assign DDR_DM_N[1:0]       = DDR_DM_N_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLK_GEN_C0
CLK_GEN_C0 CLK_GEN_C0_0(
        // Outputs
        .CLK ( CLK_GEN_C0_0_CLK ) 
        );

//--------CLK_GEN_C1
CLK_GEN_C1 CLK_GEN_C1_0(
        // Outputs
        .CLK ( CLK_GEN_C1_0_CLK ) 
        );

//--------VKPFSOC_TOP
VKPFSOC_TOP VKPFSOC_TOP_0(
        // Inputs
        .MMUART_0_RXD_F2M            ( GND_net ),
        .MMUART_1_RXD_F2M            ( GND_net ),
        .REFCLK_N                    ( REFCLK_N_IN_POST_INV0_0 ),
        .REFCLK                      ( CLK_GEN_C1_0_CLK ),
        .REF_CLK_PAD_N               ( REF_CLK_PAD_N_IN_POST_INV1_0 ),
        .REF_CLK_PAD_P               ( CLK_GEN_C0_0_CLK ),
        .SD_CD_EMMC_STRB             ( GND_net ),
        .SD_WP_EMMC_RSTN             ( GND_net ),
        .SGMII_RX0_N                 ( GND_net ),
        .SGMII_RX0_P                 ( GND_net ),
        .SGMII_RX1_N                 ( GND_net ),
        .SGMII_RX1_P                 ( GND_net ),
        .USB_CLK                     ( GND_net ),
        .USB_DIR                     ( GND_net ),
        .USB_NXT                     ( GND_net ),
        .apb_pin                     ( apb_pin ),
        // Outputs
        .CAM1_RST                    (  ),
        .CAM_CLK_EN                  (  ),
        .CKE                         (  ),
        .CK_N                        (  ),
        .CK                          (  ),
        .CS                          (  ),
        .LED2                        (  ),
        .LED3                        (  ),
        .MAC_0_MDC                   (  ),
        .MMUART_0_TXD_M2F            (  ),
        .MMUART_1_TXD_M2F            (  ),
        .ODT                         (  ),
        .RESET_N                     (  ),
        .SDIO_SW_EN_N                (  ),
        .SDIO_SW_SEL0                (  ),
        .SDIO_SW_SEL1                (  ),
        .SD_CLK_EMMC_CLK             (  ),
        .SD_POW_EMMC_DATA4           (  ),
        .SD_VOLT_CMD_DIR_EMMC_DATA7  (  ),
        .SD_VOLT_DIR_0_EMMC_UNUSED   (  ),
        .SD_VOLT_DIR_1_3_EMMC_UNUSED (  ),
        .SD_VOLT_EN_EMMC_DATA6       (  ),
        .SD_VOLT_SEL_EMMC_DATA5      (  ),
        .SGMII_TX0_N                 (  ),
        .SGMII_TX0_P                 (  ),
        .SGMII_TX1_N                 (  ),
        .SGMII_TX1_P                 (  ),
        .TEN                         (  ),
        .USB_STP                     (  ),
        .USB_ULPI_RESET_N            (  ),
        .VSC_8662_CMODE3             (  ),
        .VSC_8662_CMODE4             (  ),
        .VSC_8662_CMODE5             (  ),
        .VSC_8662_CMODE6             (  ),
        .VSC_8662_CMODE7             (  ),
        .VSC_8662_RESETN             (  ),
        .VSC_8662_SRESET             (  ),
        .cam1inck                    (  ),
        .cam1xmaster                 (  ),
        .CKE_0                       ( DDR_CKE_0_net_0 ),
        .CS_N                        ( DDR_CS_N_net_0 ),
        .ODT_0                       ( DDR_ODT_0_net_0 ),
        .RAS_N                       ( DDR_RAS_N_net_0 ),
        .CAS_N                       ( DDR_CAS_N_net_0 ),
        .WE_N                        ( DDR_WE_N_net_0 ),
        .ACT_N                       ( DDR_ACT_N_net_0 ),
        .BG                          ( DDR_BG_net_0 ),
        .RESET_N_0                   ( DDR_RESET_N_0_net_0 ),
        .CK0                         ( DDR_CK0_net_0 ),
        .CK0_N                       ( DDR_CK0_N_net_0 ),
        .SHIELD0                     ( DDR_SHIELD0_net_0 ),
        .SHIELD1                     ( DDR_SHIELD1_net_0 ),
        .CTRLR_READY                 ( CTRLR_READY_net_0 ),
        .CA                          (  ),
        .DM                          (  ),
        .BA                          ( DDR_BA_net_0 ),
        .A                           ( DDR_A_net_0 ),
        .DM_N                        ( DDR_DM_N_net_0 ),
        // Inouts
        .CAM1_SCL                    (  ),
        .CAM1_SDA                    (  ),
        .MAC_0_MDIO                  (  ),
        .SD_CMD_EMMC_CMD             (  ),
        .SD_DATA0_EMMC_DATA0         (  ),
        .SD_DATA1_EMMC_DATA1         (  ),
        .SD_DATA2_EMMC_DATA2         (  ),
        .SD_DATA3_EMMC_DATA3         (  ),
        .USB_DATA0                   (  ),
        .USB_DATA1                   (  ),
        .USB_DATA2                   (  ),
        .USB_DATA3                   (  ),
        .USB_DATA4                   (  ),
        .USB_DATA5                   (  ),
        .USB_DATA6                   (  ),
        .USB_DATA7                   (  ),
        .DQS_N                       (  ),
        .DQS                         (  ),
        .DQ                          (  ),
        .DQ_0                        ( DDR_DQ_0 ),
        .DQS_0                       ( DDR_DQS_0 ),
        .DQS_N_0                     ( DDR_DQS_N_0 ) 
        );


endmodule
