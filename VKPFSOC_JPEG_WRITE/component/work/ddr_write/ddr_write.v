//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Jun 22 13:52:43 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// ddr_write
module ddr_write(
    // Inputs
    apb_pin,
    // Outputs
    A,
    ACT_N,
    BA,
    BG,
    CAS_N,
    CK0,
    CK0_N,
    CKE_0,
    CS_N,
    DM_N,
    ODT_0,
    RAS_N,
    RESET_N_0,
    SHIELD0,
    SHIELD1,
    // Inouts
    DQS_0,
    DQS_N_0,
    DQ_0
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         apb_pin;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [13:0] A;
output        ACT_N;
output [1:0]  BA;
output        BG;
output        CAS_N;
output        CK0;
output        CK0_N;
output        CKE_0;
output        CS_N;
output [1:0]  DM_N;
output        ODT_0;
output        RAS_N;
output        RESET_N_0;
output        SHIELD0;
output        SHIELD1;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout  [1:0]  DQS_0;
inout  [1:0]  DQS_N_0;
inout  [15:0] DQ_0;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [13:0] A_net_0;
wire          ACT_N_net_0;
wire          apb_pin;
wire   [1:0]  BA_net_0;
wire          BG_net_0;
wire          CAS_N_net_0;
wire          CK0_net_0;
wire          CK0_N_net_0;
wire          CKE_0_net_0;
wire          CLK_GEN_C0_0_CLK;
wire          CS_N_net_0;
wire   [1:0]  DM_N_net_0;
wire   [15:0] DQ_0;
wire   [1:0]  DQS_0;
wire   [1:0]  DQS_N_0;
wire          ODT_0_net_0;
wire          RAS_N_net_0;
wire          RESET_N_0_net_0;
wire          SHIELD0_net_0;
wire          SHIELD1_net_0;
wire          CS_N_net_1;
wire          BG_net_1;
wire          ACT_N_net_1;
wire          CAS_N_net_1;
wire          CK0_net_1;
wire          CK0_N_net_1;
wire          CKE_0_net_1;
wire          ODT_0_net_1;
wire          RAS_N_net_1;
wire          RESET_N_0_net_1;
wire          SHIELD0_net_1;
wire          SHIELD1_net_1;
wire   [13:0] A_net_1;
wire   [1:0]  BA_net_1;
wire   [1:0]  DM_N_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
//--------------------------------------------------------------------
// Inverted Nets
//--------------------------------------------------------------------
wire          REF_CLK_PAD_N_IN_POST_INV0_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net = 1'b0;
//--------------------------------------------------------------------
// Inversions
//--------------------------------------------------------------------
assign REF_CLK_PAD_N_IN_POST_INV0_0 = ~ CLK_GEN_C0_0_CLK;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CS_N_net_1      = CS_N_net_0;
assign CS_N            = CS_N_net_1;
assign BG_net_1        = BG_net_0;
assign BG              = BG_net_1;
assign ACT_N_net_1     = ACT_N_net_0;
assign ACT_N           = ACT_N_net_1;
assign CAS_N_net_1     = CAS_N_net_0;
assign CAS_N           = CAS_N_net_1;
assign CK0_net_1       = CK0_net_0;
assign CK0             = CK0_net_1;
assign CK0_N_net_1     = CK0_N_net_0;
assign CK0_N           = CK0_N_net_1;
assign CKE_0_net_1     = CKE_0_net_0;
assign CKE_0           = CKE_0_net_1;
assign ODT_0_net_1     = ODT_0_net_0;
assign ODT_0           = ODT_0_net_1;
assign RAS_N_net_1     = RAS_N_net_0;
assign RAS_N           = RAS_N_net_1;
assign RESET_N_0_net_1 = RESET_N_0_net_0;
assign RESET_N_0       = RESET_N_0_net_1;
assign SHIELD0_net_1   = SHIELD0_net_0;
assign SHIELD0         = SHIELD0_net_1;
assign SHIELD1_net_1   = SHIELD1_net_0;
assign SHIELD1         = SHIELD1_net_1;
assign A_net_1         = A_net_0;
assign A[13:0]         = A_net_1;
assign BA_net_1        = BA_net_0;
assign BA[1:0]         = BA_net_1;
assign DM_N_net_1      = DM_N_net_0;
assign DM_N[1:0]       = DM_N_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLK_GEN_C0
CLK_GEN_C0 CLK_GEN_C0_0(
        // Outputs
        .CLK ( CLK_GEN_C0_0_CLK ) 
        );

//--------VKPFSOC_TOP
VKPFSOC_TOP VKPFSOC_TOP_0(
        // Inputs
        .MMUART_0_RXD_F2M            ( GND_net ),
        .MMUART_1_RXD_F2M            ( GND_net ),
        .REFCLK_N                    ( GND_net ),
        .REFCLK                      ( GND_net ),
        .REF_CLK_PAD_N               ( REF_CLK_PAD_N_IN_POST_INV0_0 ),
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
        .ACT_N                       ( ACT_N_net_0 ),
        .BG                          ( BG_net_0 ),
        .CAM1_RST                    (  ),
        .CAM_CLK_EN                  (  ),
        .CAS_N                       ( CAS_N_net_0 ),
        .CK0_N                       ( CK0_N_net_0 ),
        .CK0                         ( CK0_net_0 ),
        .CKE_0                       ( CKE_0_net_0 ),
        .CKE                         (  ),
        .CK_N                        (  ),
        .CK                          (  ),
        .CS_N                        ( CS_N_net_0 ),
        .CS                          (  ),
        .LED2                        (  ),
        .LED3                        (  ),
        .MAC_0_MDC                   (  ),
        .MMUART_0_TXD_M2F            (  ),
        .MMUART_1_TXD_M2F            (  ),
        .ODT_0                       ( ODT_0_net_0 ),
        .ODT                         (  ),
        .RAS_N                       ( RAS_N_net_0 ),
        .RESET_N_0                   ( RESET_N_0_net_0 ),
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
        .SHIELD0                     ( SHIELD0_net_0 ),
        .SHIELD1                     ( SHIELD1_net_0 ),
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
        .WE_N                        (  ),
        .cam1inck                    (  ),
        .cam1xmaster                 (  ),
        .A                           ( A_net_0 ),
        .BA                          ( BA_net_0 ),
        .CA                          (  ),
        .DM_N                        ( DM_N_net_0 ),
        .DM                          (  ),
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
        .DQS_0                       ( DQS_0 ),
        .DQS_N_0                     ( DQS_N_0 ),
        .DQS_N                       (  ),
        .DQS                         (  ),
        .DQ_0                        ( DQ_0 ),
        .DQ                          (  ) 
        );


endmodule
