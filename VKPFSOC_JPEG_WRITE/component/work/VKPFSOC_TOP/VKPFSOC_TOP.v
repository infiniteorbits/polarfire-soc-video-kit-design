//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Mar 17 11:53:38 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// VKPFSOC_TOP
module VKPFSOC_TOP(
    // Inputs
    MMUART_0_RXD_F2M,
    MMUART_1_RXD_F2M,
    REFCLK,
    REFCLK_N,
    REF_CLK_PAD_N,
    REF_CLK_PAD_P,
    SD_CD_EMMC_STRB,
    SD_WP_EMMC_RSTN,
    SGMII_RX0_N,
    SGMII_RX0_P,
    SGMII_RX1_N,
    SGMII_RX1_P,
    USB_CLK,
    USB_DIR,
    USB_NXT,
    // Outputs
    CA,
    CAM1_RST,
    CAM_CLK_EN,
    CK,
    CKE,
    CK_N,
    CS,
    DM,
    LED2,
    LED3,
    MAC_0_MDC,
    MMUART_0_TXD_M2F,
    MMUART_1_TXD_M2F,
    ODT,
    RESET_N,
    SDIO_SW_EN_N,
    SDIO_SW_SEL0,
    SDIO_SW_SEL1,
    SD_CLK_EMMC_CLK,
    SD_POW_EMMC_DATA4,
    SD_VOLT_CMD_DIR_EMMC_DATA7,
    SD_VOLT_DIR_0_EMMC_UNUSED,
    SD_VOLT_DIR_1_3_EMMC_UNUSED,
    SD_VOLT_EN_EMMC_DATA6,
    SD_VOLT_SEL_EMMC_DATA5,
    SGMII_TX0_N,
    SGMII_TX0_P,
    SGMII_TX1_N,
    SGMII_TX1_P,
    TEN,
    USB_STP,
    USB_ULPI_RESET_N,
    VSC_8662_CMODE3,
    VSC_8662_CMODE4,
    VSC_8662_CMODE5,
    VSC_8662_CMODE6,
    VSC_8662_CMODE7,
    VSC_8662_RESETN,
    VSC_8662_SRESET,
    cam1inck,
    cam1xmaster,
    // Inouts
    CAM1_SCL,
    CAM1_SDA,
    DQ,
    DQS,
    DQS_N,
    MAC_0_MDIO,
    SD_CMD_EMMC_CMD,
    SD_DATA0_EMMC_DATA0,
    SD_DATA1_EMMC_DATA1,
    SD_DATA2_EMMC_DATA2,
    SD_DATA3_EMMC_DATA3,
    USB_DATA0,
    USB_DATA1,
    USB_DATA2,
    USB_DATA3,
    USB_DATA4,
    USB_DATA5,
    USB_DATA6,
    USB_DATA7
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         MMUART_0_RXD_F2M;
input         MMUART_1_RXD_F2M;
input         REFCLK;
input         REFCLK_N;
input         REF_CLK_PAD_N;
input         REF_CLK_PAD_P;
input         SD_CD_EMMC_STRB;
input         SD_WP_EMMC_RSTN;
input         SGMII_RX0_N;
input         SGMII_RX0_P;
input         SGMII_RX1_N;
input         SGMII_RX1_P;
input         USB_CLK;
input         USB_DIR;
input         USB_NXT;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [5:0]  CA;
output        CAM1_RST;
output        CAM_CLK_EN;
output        CK;
output        CKE;
output        CK_N;
output        CS;
output [3:0]  DM;
output        LED2;
output        LED3;
output        MAC_0_MDC;
output        MMUART_0_TXD_M2F;
output        MMUART_1_TXD_M2F;
output        ODT;
output        RESET_N;
output        SDIO_SW_EN_N;
output        SDIO_SW_SEL0;
output        SDIO_SW_SEL1;
output        SD_CLK_EMMC_CLK;
output        SD_POW_EMMC_DATA4;
output        SD_VOLT_CMD_DIR_EMMC_DATA7;
output        SD_VOLT_DIR_0_EMMC_UNUSED;
output        SD_VOLT_DIR_1_3_EMMC_UNUSED;
output        SD_VOLT_EN_EMMC_DATA6;
output        SD_VOLT_SEL_EMMC_DATA5;
output        SGMII_TX0_N;
output        SGMII_TX0_P;
output        SGMII_TX1_N;
output        SGMII_TX1_P;
output        TEN;
output        USB_STP;
output        USB_ULPI_RESET_N;
output        VSC_8662_CMODE3;
output        VSC_8662_CMODE4;
output        VSC_8662_CMODE5;
output        VSC_8662_CMODE6;
output        VSC_8662_CMODE7;
output        VSC_8662_RESETN;
output        VSC_8662_SRESET;
output        cam1inck;
output        cam1xmaster;
//--------------------------------------------------------------------
// Inout
//--------------------------------------------------------------------
inout         CAM1_SCL;
inout         CAM1_SDA;
inout  [31:0] DQ;
inout  [3:0]  DQS;
inout  [3:0]  DQS_N;
inout         MAC_0_MDIO;
inout         SD_CMD_EMMC_CMD;
inout         SD_DATA0_EMMC_DATA0;
inout         SD_DATA1_EMMC_DATA1;
inout         SD_DATA2_EMMC_DATA2;
inout         SD_DATA3_EMMC_DATA3;
inout         USB_DATA0;
inout         USB_DATA1;
inout         USB_DATA2;
inout         USB_DATA3;
inout         USB_DATA4;
inout         USB_DATA5;
inout         USB_DATA6;
inout         USB_DATA7;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          BIBUF_1_Y;
wire          BIBUF_2_Y;
wire   [5:0]  CA_net_0;
wire          CAM1_RST_net_0;
wire          CAM1_SCL;
wire          CAM1_SDA;
wire          CAM_CLK_EN_net_0;
wire          CK_net_0;
wire          CK_N_net_0;
wire          CKE_net_0;
wire          CLOCKS_AND_RESETS_CLK_50MHz;
wire          CLOCKS_AND_RESETS_CLK_125MHz;
wire          CLOCKS_AND_RESETS_FABRIC_POR_N;
wire          CLOCKS_AND_RESETS_I2C_BCLK;
wire          CLOCKS_AND_RESETS_RESETN_50MHz;
wire          CS_net_0;
wire   [3:0]  DM_net_0;
wire   [31:0] DQ;
wire   [3:0]  DQS;
wire   [3:0]  DQS_N;
wire   [31:0] FIC_CONVERTER_0_APBmslave_PADDR;
wire          FIC_CONVERTER_0_APBmslave_PENABLE;
wire   [31:0] FIC_CONVERTER_0_APBmslave_PRDATA;
wire          FIC_CONVERTER_0_APBmslave_PREADY;
wire          FIC_CONVERTER_0_APBmslave_PSELx;
wire          FIC_CONVERTER_0_APBmslave_PSLVERR;
wire   [31:0] FIC_CONVERTER_0_APBmslave_PWDATA;
wire          FIC_CONVERTER_0_APBmslave_PWRITE;
wire          LED2_net_0;
wire          LED3_net_0;
wire          MAC_0_MDC_net_0;
wire          MAC_0_MDIO;
wire          MMUART_0_RXD_F2M;
wire          MMUART_0_TXD_M2F_net_0;
wire          MMUART_1_RXD_F2M;
wire          MMUART_1_TXD_M2F_net_0;
wire          MSS_FIC_1_DLL_LOCK_M2F;
wire   [31:0] MSS_FIC_3_APB_INITIATOR_PADDR;
wire          MSS_FIC_3_APB_INITIATOR_PENABLE;
wire   [31:0] MSS_FIC_3_APB_INITIATOR_PRDATA;
wire          MSS_FIC_3_APB_INITIATOR_PREADY;
wire          MSS_FIC_3_APB_INITIATOR_PSELx;
wire          MSS_FIC_3_APB_INITIATOR_PSLVERR;
wire   [31:0] MSS_FIC_3_APB_INITIATOR_PWDATA;
wire          MSS_FIC_3_APB_INITIATOR_PWRITE;
wire          MSS_GPIO_2_M2F_4;
wire          MSS_I2C_0_SCL_OE_M2F;
wire          MSS_I2C_0_SDA_OE_M2F;
wire          MSS_MSS_RESET_N_M2F;
wire          ODT_net_0;
wire          REF_CLK_PAD_N;
wire          REF_CLK_PAD_P;
wire          REFCLK;
wire          REFCLK_N;
wire          RESET_N_net_0;
wire          SD_CD_EMMC_STRB;
wire          SD_CLK_EMMC_CLK_net_0;
wire          SD_CMD_EMMC_CMD;
wire          SD_DATA0_EMMC_DATA0;
wire          SD_DATA1_EMMC_DATA1;
wire          SD_DATA2_EMMC_DATA2;
wire          SD_DATA3_EMMC_DATA3;
wire          SD_POW_EMMC_DATA4_net_0;
wire          SD_VOLT_CMD_DIR_EMMC_DATA7_net_0;
wire          SD_VOLT_DIR_0_EMMC_UNUSED_net_0;
wire          SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0;
wire          SD_VOLT_EN_EMMC_DATA6_net_0;
wire          SD_VOLT_SEL_EMMC_DATA5_net_0;
wire          SD_WP_EMMC_RSTN;
wire          SDIO_SW_EN_N_net_0;
wire          SDIO_SW_SEL0_net_0;
wire          SDIO_SW_SEL1_net_0;
wire          SGMII_RX0_N;
wire          SGMII_RX0_P;
wire          SGMII_RX1_N;
wire          SGMII_RX1_P;
wire          SGMII_TX0_N_net_0;
wire          SGMII_TX0_P_net_0;
wire          SGMII_TX1_N_net_0;
wire          SGMII_TX1_P_net_0;
wire          top_ddr_write_0_frm_interrupt_o;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARBURST;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARCACHE;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARID;
wire   [7:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLEN;
wire   [2:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARPROT;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARREADY;
wire   [2:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARSIZE;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARVALID;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWBURST;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWCACHE;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWID;
wire   [7:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLEN;
wire   [2:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWPROT;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWREADY;
wire   [2:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWSIZE;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWVALID;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_BID;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_BREADY;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_BRESP;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_BVALID;
wire   [63:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_RDATA;
wire   [3:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_RID;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_RLAST;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_RREADY;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_RRESP;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_RVALID;
wire   [63:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_WDATA;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_WLAST;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_WREADY;
wire   [7:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_WSTRB;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_WVALID;
wire          USB_CLK;
wire          USB_DATA0;
wire          USB_DATA1;
wire          USB_DATA2;
wire          USB_DATA3;
wire          USB_DATA4;
wire          USB_DATA5;
wire          USB_DATA6;
wire          USB_DATA7;
wire          USB_DIR;
wire          USB_NXT;
wire          USB_STP_net_0;
wire          USB_ULPI_RESET_N_net_0;
wire          VSC_8662_RESETN_net_0;
wire          CAM1_RST_net_1;
wire          CAM_CLK_EN_net_1;
wire          CKE_net_1;
wire          CK_N_net_1;
wire          CK_net_1;
wire          CS_net_1;
wire          LED2_net_1;
wire          LED3_net_1;
wire          MAC_0_MDC_net_1;
wire          MMUART_0_TXD_M2F_net_1;
wire          MMUART_1_TXD_M2F_net_1;
wire          ODT_net_1;
wire          RESET_N_net_1;
wire          SDIO_SW_EN_N_net_1;
wire          SDIO_SW_SEL0_net_1;
wire          SDIO_SW_SEL1_net_1;
wire          SD_CLK_EMMC_CLK_net_1;
wire          SD_POW_EMMC_DATA4_net_1;
wire          SD_VOLT_CMD_DIR_EMMC_DATA7_net_1;
wire          SD_VOLT_DIR_0_EMMC_UNUSED_net_1;
wire          SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1;
wire          SD_VOLT_EN_EMMC_DATA6_net_1;
wire          SD_VOLT_SEL_EMMC_DATA5_net_1;
wire          SGMII_TX0_N_net_1;
wire          SGMII_TX0_P_net_1;
wire          SGMII_TX1_N_net_1;
wire          SGMII_TX1_P_net_1;
wire          USB_STP_net_1;
wire          USB_ULPI_RESET_N_net_1;
wire          VSC_8662_RESETN_net_1;
wire   [5:0]  CA_net_1;
wire   [3:0]  DM_net_1;
wire   [63:0] MSS_INT_F2M_net_0;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire          VCC_net;
wire   [63:1] MSS_INT_F2M_const_net_0;
wire   [3:0]  FIC_1_AXI4_S_AWQOS_const_net_0;
wire   [3:0]  FIC_1_AXI4_S_ARQOS_const_net_0;
//--------------------------------------------------------------------
// Bus Interface Nets Declarations - Unequal Pin Widths
//--------------------------------------------------------------------
wire   [31:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR;
wire   [37:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0;
wire   [31:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_31to0;
wire   [37:32]top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_37to32;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0;
wire   [0:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0_0to0;
wire   [31:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR;
wire   [37:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0;
wire   [31:0] top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_31to0;
wire   [37:32]top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_37to32;
wire   [1:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK;
wire          top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0;
wire   [0:0]  top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0_0to0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net                        = 1'b0;
assign VCC_net                        = 1'b1;
assign MSS_INT_F2M_const_net_0        = 63'h0000000000000000;
assign FIC_1_AXI4_S_AWQOS_const_net_0 = 4'h0;
assign FIC_1_AXI4_S_ARQOS_const_net_0 = 4'h0;
//--------------------------------------------------------------------
// TieOff assignments
//--------------------------------------------------------------------
assign TEN                               = 1'b0;
assign VSC_8662_CMODE3                   = 1'b0;
assign VSC_8662_CMODE4                   = 1'b0;
assign VSC_8662_CMODE5                   = 1'b0;
assign VSC_8662_CMODE6                   = 1'b1;
assign VSC_8662_CMODE7                   = 1'b0;
assign VSC_8662_SRESET                   = 1'b1;
assign cam1inck                          = 1'b0;
assign cam1xmaster                       = 1'b0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CAM1_RST_net_1                    = CAM1_RST_net_0;
assign CAM1_RST                          = CAM1_RST_net_1;
assign CAM_CLK_EN_net_1                  = CAM_CLK_EN_net_0;
assign CAM_CLK_EN                        = CAM_CLK_EN_net_1;
assign CKE_net_1                         = CKE_net_0;
assign CKE                               = CKE_net_1;
assign CK_N_net_1                        = CK_N_net_0;
assign CK_N                              = CK_N_net_1;
assign CK_net_1                          = CK_net_0;
assign CK                                = CK_net_1;
assign CS_net_1                          = CS_net_0;
assign CS                                = CS_net_1;
assign LED2_net_1                        = LED2_net_0;
assign LED2                              = LED2_net_1;
assign LED3_net_1                        = LED3_net_0;
assign LED3                              = LED3_net_1;
assign MAC_0_MDC_net_1                   = MAC_0_MDC_net_0;
assign MAC_0_MDC                         = MAC_0_MDC_net_1;
assign MMUART_0_TXD_M2F_net_1            = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F                  = MMUART_0_TXD_M2F_net_1;
assign MMUART_1_TXD_M2F_net_1            = MMUART_1_TXD_M2F_net_0;
assign MMUART_1_TXD_M2F                  = MMUART_1_TXD_M2F_net_1;
assign ODT_net_1                         = ODT_net_0;
assign ODT                               = ODT_net_1;
assign RESET_N_net_1                     = RESET_N_net_0;
assign RESET_N                           = RESET_N_net_1;
assign SDIO_SW_EN_N_net_1                = SDIO_SW_EN_N_net_0;
assign SDIO_SW_EN_N                      = SDIO_SW_EN_N_net_1;
assign SDIO_SW_SEL0_net_1                = SDIO_SW_SEL0_net_0;
assign SDIO_SW_SEL0                      = SDIO_SW_SEL0_net_1;
assign SDIO_SW_SEL1_net_1                = SDIO_SW_SEL1_net_0;
assign SDIO_SW_SEL1                      = SDIO_SW_SEL1_net_1;
assign SD_CLK_EMMC_CLK_net_1             = SD_CLK_EMMC_CLK_net_0;
assign SD_CLK_EMMC_CLK                   = SD_CLK_EMMC_CLK_net_1;
assign SD_POW_EMMC_DATA4_net_1           = SD_POW_EMMC_DATA4_net_0;
assign SD_POW_EMMC_DATA4                 = SD_POW_EMMC_DATA4_net_1;
assign SD_VOLT_CMD_DIR_EMMC_DATA7_net_1  = SD_VOLT_CMD_DIR_EMMC_DATA7_net_0;
assign SD_VOLT_CMD_DIR_EMMC_DATA7        = SD_VOLT_CMD_DIR_EMMC_DATA7_net_1;
assign SD_VOLT_DIR_0_EMMC_UNUSED_net_1   = SD_VOLT_DIR_0_EMMC_UNUSED_net_0;
assign SD_VOLT_DIR_0_EMMC_UNUSED         = SD_VOLT_DIR_0_EMMC_UNUSED_net_1;
assign SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1 = SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0;
assign SD_VOLT_DIR_1_3_EMMC_UNUSED       = SD_VOLT_DIR_1_3_EMMC_UNUSED_net_1;
assign SD_VOLT_EN_EMMC_DATA6_net_1       = SD_VOLT_EN_EMMC_DATA6_net_0;
assign SD_VOLT_EN_EMMC_DATA6             = SD_VOLT_EN_EMMC_DATA6_net_1;
assign SD_VOLT_SEL_EMMC_DATA5_net_1      = SD_VOLT_SEL_EMMC_DATA5_net_0;
assign SD_VOLT_SEL_EMMC_DATA5            = SD_VOLT_SEL_EMMC_DATA5_net_1;
assign SGMII_TX0_N_net_1                 = SGMII_TX0_N_net_0;
assign SGMII_TX0_N                       = SGMII_TX0_N_net_1;
assign SGMII_TX0_P_net_1                 = SGMII_TX0_P_net_0;
assign SGMII_TX0_P                       = SGMII_TX0_P_net_1;
assign SGMII_TX1_N_net_1                 = SGMII_TX1_N_net_0;
assign SGMII_TX1_N                       = SGMII_TX1_N_net_1;
assign SGMII_TX1_P_net_1                 = SGMII_TX1_P_net_0;
assign SGMII_TX1_P                       = SGMII_TX1_P_net_1;
assign USB_STP_net_1                     = USB_STP_net_0;
assign USB_STP                           = USB_STP_net_1;
assign USB_ULPI_RESET_N_net_1            = USB_ULPI_RESET_N_net_0;
assign USB_ULPI_RESET_N                  = USB_ULPI_RESET_N_net_1;
assign VSC_8662_RESETN_net_1             = VSC_8662_RESETN_net_0;
assign VSC_8662_RESETN                   = VSC_8662_RESETN_net_1;
assign CA_net_1                          = CA_net_0;
assign CA[5:0]                           = CA_net_1;
assign DM_net_1                          = DM_net_0;
assign DM[3:0]                           = DM_net_1;
//--------------------------------------------------------------------
// Concatenation assignments
//--------------------------------------------------------------------
assign MSS_INT_F2M_net_0 = { 63'h0000000000000000 , top_ddr_write_0_frm_interrupt_o };
//--------------------------------------------------------------------
// Bus Interface Nets Assignments - Unequal Pin Widths
//--------------------------------------------------------------------
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0 = { top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_37to32, top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_31to0 };
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_31to0 = top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR[31:0];
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0_37to32 = 6'h0;

assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0 = { top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0_0to0 };
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0_0to0 = top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK[0:0];

assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0 = { top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_37to32, top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_31to0 };
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_31to0 = top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR[31:0];
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0_37to32 = 6'h0;

assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0 = { top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0_0to0 };
assign top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0_0to0 = top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK[0:0];

//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------BIBUF
BIBUF BIBUF_1(
        // Inputs
        .D   ( GND_net ),
        .E   ( MSS_I2C_0_SCL_OE_M2F ),
        // Outputs
        .Y   ( BIBUF_1_Y ),
        // Inouts
        .PAD ( CAM1_SCL ) 
        );

//--------BIBUF
BIBUF BIBUF_2(
        // Inputs
        .D   ( GND_net ),
        .E   ( MSS_I2C_0_SDA_OE_M2F ),
        // Outputs
        .Y   ( BIBUF_2_Y ),
        // Inouts
        .PAD ( CAM1_SDA ) 
        );

//--------CLOCKS_AND_RESETS
CLOCKS_AND_RESETS CLOCKS_AND_RESETS_inst_0(
        // Inputs
        .EXT_RST_N        ( MSS_MSS_RESET_N_M2F ),
        .MSS_PLL_LOCKS    ( MSS_FIC_1_DLL_LOCK_M2F ),
        .REF_CLK_PAD_N    ( REF_CLK_PAD_N ),
        .REF_CLK_PAD_P    ( REF_CLK_PAD_P ),
        // Outputs
        .CLK_125MHz       ( CLOCKS_AND_RESETS_CLK_125MHz ),
        .CLK_50MHz        ( CLOCKS_AND_RESETS_CLK_50MHz ),
        .DEVICE_INIT_DONE (  ),
        .FABRIC_POR_N     ( CLOCKS_AND_RESETS_FABRIC_POR_N ),
        .I2C_BCLK         ( CLOCKS_AND_RESETS_I2C_BCLK ),
        .RESETN_125MHz    ( VSC_8662_RESETN_net_0 ),
        .RESETN_50MHz     ( CLOCKS_AND_RESETS_RESETN_50MHz ) 
        );

//--------FIC_CONVERTER
FIC_CONVERTER FIC_CONVERTER_0(
        // Inputs
        .FIC3_APB3_master_PENABLE ( MSS_FIC_3_APB_INITIATOR_PENABLE ),
        .FIC3_APB3_master_PSEL    ( MSS_FIC_3_APB_INITIATOR_PSELx ),
        .FIC3_APB3_master_PWRITE  ( MSS_FIC_3_APB_INITIATOR_PWRITE ),
        .PREADYS1                 ( FIC_CONVERTER_0_APBmslave_PREADY ),
        .PSLVERRS1                ( FIC_CONVERTER_0_APBmslave_PSLVERR ),
        .FIC3_APB3_master_PADDR   ( MSS_FIC_3_APB_INITIATOR_PADDR ),
        .FIC3_APB3_master_PWDATA  ( MSS_FIC_3_APB_INITIATOR_PWDATA ),
        .PRDATAS1                 ( FIC_CONVERTER_0_APBmslave_PRDATA ),
        // Outputs
        .FIC3_APB3_master_PREADY  ( MSS_FIC_3_APB_INITIATOR_PREADY ),
        .FIC3_APB3_master_PSLVERR ( MSS_FIC_3_APB_INITIATOR_PSLVERR ),
        .PENABLES                 ( FIC_CONVERTER_0_APBmslave_PENABLE ),
        .PSELS1                   ( FIC_CONVERTER_0_APBmslave_PSELx ),
        .PWRITES                  ( FIC_CONVERTER_0_APBmslave_PWRITE ),
        .FIC3_APB3_master_PRDATA  ( MSS_FIC_3_APB_INITIATOR_PRDATA ),
        .PADDRS                   ( FIC_CONVERTER_0_APBmslave_PADDR ),
        .PWDATAS                  ( FIC_CONVERTER_0_APBmslave_PWDATA ) 
        );

//--------MSS_VIDEO_KIT_H264
MSS_VIDEO_KIT_H264 MSS(
        // Inputs
        .FIC_1_ACLK                  ( CLOCKS_AND_RESETS_CLK_125MHz ),
        .FIC_1_AXI4_S_AWID           ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWID ),
        .FIC_1_AXI4_S_AWADDR         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR_0 ),
        .FIC_1_AXI4_S_AWLEN          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLEN ),
        .FIC_1_AXI4_S_AWSIZE         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWSIZE ),
        .FIC_1_AXI4_S_AWBURST        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWBURST ),
        .FIC_1_AXI4_S_AWLOCK         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK_0 ),
        .FIC_1_AXI4_S_AWCACHE        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWCACHE ),
        .FIC_1_AXI4_S_AWQOS          ( FIC_1_AXI4_S_AWQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_S_AWPROT         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWPROT ),
        .FIC_1_AXI4_S_AWVALID        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWVALID ),
        .FIC_1_AXI4_S_WDATA          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WDATA ),
        .FIC_1_AXI4_S_WSTRB          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WSTRB ),
        .FIC_1_AXI4_S_WLAST          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WLAST ),
        .FIC_1_AXI4_S_WVALID         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WVALID ),
        .FIC_1_AXI4_S_BREADY         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BREADY ),
        .FIC_1_AXI4_S_ARID           ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARID ),
        .FIC_1_AXI4_S_ARADDR         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR_0 ),
        .FIC_1_AXI4_S_ARLEN          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLEN ),
        .FIC_1_AXI4_S_ARSIZE         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARSIZE ),
        .FIC_1_AXI4_S_ARBURST        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARBURST ),
        .FIC_1_AXI4_S_ARQOS          ( FIC_1_AXI4_S_ARQOS_const_net_0 ), // tied to 4'h0 from definition
        .FIC_1_AXI4_S_ARLOCK         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK_0 ),
        .FIC_1_AXI4_S_ARCACHE        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARCACHE ),
        .FIC_1_AXI4_S_ARPROT         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARPROT ),
        .FIC_1_AXI4_S_ARVALID        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARVALID ),
        .FIC_1_AXI4_S_RREADY         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RREADY ),
        .FIC_3_PCLK                  ( CLOCKS_AND_RESETS_CLK_50MHz ),
        .FIC_3_APB_M_PRDATA          ( MSS_FIC_3_APB_INITIATOR_PRDATA ),
        .FIC_3_APB_M_PREADY          ( MSS_FIC_3_APB_INITIATOR_PREADY ),
        .FIC_3_APB_M_PSLVERR         ( MSS_FIC_3_APB_INITIATOR_PSLVERR ),
        .MMUART_0_RXD_F2M            ( MMUART_0_RXD_F2M ),
        .MMUART_1_RXD_F2M            ( MMUART_1_RXD_F2M ),
        .I2C_0_SCL_F2M               ( BIBUF_1_Y ),
        .I2C_0_SDA_F2M               ( BIBUF_2_Y ),
        .I2C_0_BCLK_F2M              ( CLOCKS_AND_RESETS_I2C_BCLK ),
        .GPIO_2_F2M_25               ( VCC_net ),
        .MSS_INT_F2M                 ( MSS_INT_F2M_net_0 ),
        .MSS_RESET_N_F2M             ( CLOCKS_AND_RESETS_FABRIC_POR_N ),
        .USB_CLK                     ( USB_CLK ),
        .USB_DIR                     ( USB_DIR ),
        .USB_NXT                     ( USB_NXT ),
        .SD_CD_EMMC_STRB             ( SD_CD_EMMC_STRB ),
        .SD_WP_EMMC_RSTN             ( SD_WP_EMMC_RSTN ),
        .SGMII_RX1_P                 ( SGMII_RX1_P ),
        .SGMII_RX1_N                 ( SGMII_RX1_N ),
        .SGMII_RX0_P                 ( SGMII_RX0_P ),
        .SGMII_RX0_N                 ( SGMII_RX0_N ),
        .REFCLK                      ( REFCLK ),
        .REFCLK_N                    ( REFCLK_N ),
        // Outputs
        .FIC_1_DLL_LOCK_M2F          ( MSS_FIC_1_DLL_LOCK_M2F ),
        .FIC_3_DLL_LOCK_M2F          (  ),
        .FIC_1_AXI4_S_AWREADY        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWREADY ),
        .FIC_1_AXI4_S_WREADY         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WREADY ),
        .FIC_1_AXI4_S_BID            ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BID ),
        .FIC_1_AXI4_S_BRESP          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BRESP ),
        .FIC_1_AXI4_S_BVALID         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BVALID ),
        .FIC_1_AXI4_S_ARREADY        ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARREADY ),
        .FIC_1_AXI4_S_RID            ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RID ),
        .FIC_1_AXI4_S_RDATA          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RDATA ),
        .FIC_1_AXI4_S_RRESP          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RRESP ),
        .FIC_1_AXI4_S_RLAST          ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RLAST ),
        .FIC_1_AXI4_S_RVALID         ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RVALID ),
        .FIC_3_APB_M_PSEL            ( MSS_FIC_3_APB_INITIATOR_PSELx ),
        .FIC_3_APB_M_PADDR           ( MSS_FIC_3_APB_INITIATOR_PADDR ),
        .FIC_3_APB_M_PWRITE          ( MSS_FIC_3_APB_INITIATOR_PWRITE ),
        .FIC_3_APB_M_PENABLE         ( MSS_FIC_3_APB_INITIATOR_PENABLE ),
        .FIC_3_APB_M_PSTRB           (  ),
        .FIC_3_APB_M_PWDATA          ( MSS_FIC_3_APB_INITIATOR_PWDATA ),
        .MMUART_0_TXD_M2F            ( MMUART_0_TXD_M2F_net_0 ),
        .MMUART_0_TXD_OE_M2F         (  ),
        .MMUART_1_TXD_M2F            ( MMUART_1_TXD_M2F_net_0 ),
        .MMUART_1_TXD_OE_M2F         (  ),
        .I2C_0_SCL_OE_M2F            ( MSS_I2C_0_SCL_OE_M2F ),
        .I2C_0_SDA_OE_M2F            ( MSS_I2C_0_SDA_OE_M2F ),
        .GPIO_2_M2F_19               ( LED3_net_0 ),
        .GPIO_2_M2F_18               ( LED2_net_0 ),
        .GPIO_2_M2F_9                ( CAM_CLK_EN_net_0 ),
        .GPIO_2_M2F_8                ( CAM1_RST_net_0 ),
        .GPIO_2_M2F_4                ( MSS_GPIO_2_M2F_4 ),
        .GPIO_2_M2F_3                (  ),
        .GPIO_2_M2F_2                (  ),
        .GPIO_2_M2F_1                (  ),
        .MSS_INT_M2F                 (  ),
        .PLL_CPU_LOCK_M2F            (  ),
        .PLL_DDR_LOCK_M2F            (  ),
        .PLL_SGMII_LOCK_M2F          (  ),
        .MSS_RESET_N_M2F             ( MSS_MSS_RESET_N_M2F ),
        .CRYPTO_DLL_LOCK_M2F         (  ),
        .CRYPTO_BUSY_M2F             (  ),
        .MAC_0_MDC                   ( MAC_0_MDC_net_0 ),
        .GPIO_1_12_OUT               ( USB_ULPI_RESET_N_net_0 ),
        .GPIO_1_16_OUT               ( SDIO_SW_SEL0_net_0 ),
        .GPIO_1_20_OUT               ( SDIO_SW_SEL1_net_0 ),
        .GPIO_1_23_OUT               ( SDIO_SW_EN_N_net_0 ),
        .USB_STP                     ( USB_STP_net_0 ),
        .SD_CLK_EMMC_CLK             ( SD_CLK_EMMC_CLK_net_0 ),
        .SD_POW_EMMC_DATA4           ( SD_POW_EMMC_DATA4_net_0 ),
        .SD_VOLT_SEL_EMMC_DATA5      ( SD_VOLT_SEL_EMMC_DATA5_net_0 ),
        .SD_VOLT_EN_EMMC_DATA6       ( SD_VOLT_EN_EMMC_DATA6_net_0 ),
        .SD_VOLT_CMD_DIR_EMMC_DATA7  ( SD_VOLT_CMD_DIR_EMMC_DATA7_net_0 ),
        .SD_VOLT_DIR_0_EMMC_UNUSED   ( SD_VOLT_DIR_0_EMMC_UNUSED_net_0 ),
        .SD_VOLT_DIR_1_3_EMMC_UNUSED ( SD_VOLT_DIR_1_3_EMMC_UNUSED_net_0 ),
        .SGMII_TX1_P                 ( SGMII_TX1_P_net_0 ),
        .SGMII_TX1_N                 ( SGMII_TX1_N_net_0 ),
        .SGMII_TX0_P                 ( SGMII_TX0_P_net_0 ),
        .SGMII_TX0_N                 ( SGMII_TX0_N_net_0 ),
        .DM                          ( DM_net_0 ),
        .RESET_N                     ( RESET_N_net_0 ),
        .ODT                         ( ODT_net_0 ),
        .CKE                         ( CKE_net_0 ),
        .CS                          ( CS_net_0 ),
        .CK                          ( CK_net_0 ),
        .CK_N                        ( CK_N_net_0 ),
        .CA                          ( CA_net_0 ),
        // Inouts
        .MAC_0_MDIO                  ( MAC_0_MDIO ),
        .USB_DATA0                   ( USB_DATA0 ),
        .USB_DATA1                   ( USB_DATA1 ),
        .USB_DATA2                   ( USB_DATA2 ),
        .USB_DATA3                   ( USB_DATA3 ),
        .USB_DATA4                   ( USB_DATA4 ),
        .USB_DATA5                   ( USB_DATA5 ),
        .USB_DATA6                   ( USB_DATA6 ),
        .USB_DATA7                   ( USB_DATA7 ),
        .SD_CMD_EMMC_CMD             ( SD_CMD_EMMC_CMD ),
        .SD_DATA0_EMMC_DATA0         ( SD_DATA0_EMMC_DATA0 ),
        .SD_DATA1_EMMC_DATA1         ( SD_DATA1_EMMC_DATA1 ),
        .SD_DATA2_EMMC_DATA2         ( SD_DATA2_EMMC_DATA2 ),
        .SD_DATA3_EMMC_DATA3         ( SD_DATA3_EMMC_DATA3 ),
        .DQ                          ( DQ ),
        .DQS                         ( DQS ),
        .DQS_N                       ( DQS_N ) 
        );

//--------top_ddr_write
top_ddr_write top_ddr_write_0(
        // Inputs
        .APBslave_psel                 ( FIC_CONVERTER_0_APBmslave_PSELx ),
        .APBslave_pwrite               ( FIC_CONVERTER_0_APBmslave_PWRITE ),
        .MIRRORED_SLAVE_AXI4_arready_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARREADY ),
        .MIRRORED_SLAVE_AXI4_awready_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWREADY ),
        .MIRRORED_SLAVE_AXI4_bvalid_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BVALID ),
        .MIRRORED_SLAVE_AXI4_rlast_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RLAST ),
        .MIRRORED_SLAVE_AXI4_rvalid_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RVALID ),
        .MIRRORED_SLAVE_AXI4_wready_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WREADY ),
        .ddr_ctrl_ready_i              ( MSS_GPIO_2_M2F_4 ),
        .pclk                          ( CLOCKS_AND_RESETS_CLK_50MHz ),
        .presetn                       ( CLOCKS_AND_RESETS_RESETN_50MHz ),
        .reset_i                       ( VSC_8662_RESETN_net_0 ),
        .sys_clk_i                     ( CLOCKS_AND_RESETS_CLK_125MHz ),
        .APBslave_paddr                ( FIC_CONVERTER_0_APBmslave_PADDR ),
        .APBslave_pwdata               ( FIC_CONVERTER_0_APBmslave_PWDATA ),
        .MIRRORED_SLAVE_AXI4_bid_0     ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BID ),
        .MIRRORED_SLAVE_AXI4_bresp_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BRESP ),
        .MIRRORED_SLAVE_AXI4_rdata_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RDATA ),
        .MIRRORED_SLAVE_AXI4_rid_0     ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RID ),
        .MIRRORED_SLAVE_AXI4_rresp_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RRESP ),
        // Outputs
        .APBslave_pready               ( FIC_CONVERTER_0_APBmslave_PREADY ),
        .APBslave_pslverr              ( FIC_CONVERTER_0_APBmslave_PSLVERR ),
        .MIRRORED_SLAVE_AXI4_arvalid_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARVALID ),
        .MIRRORED_SLAVE_AXI4_awvalid_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWVALID ),
        .MIRRORED_SLAVE_AXI4_bready_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_BREADY ),
        .MIRRORED_SLAVE_AXI4_rready_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_RREADY ),
        .MIRRORED_SLAVE_AXI4_wlast_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WLAST ),
        .MIRRORED_SLAVE_AXI4_wvalid_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WVALID ),
        .frm_interrupt_o               ( top_ddr_write_0_frm_interrupt_o ),
        .APBslave_prdata               ( FIC_CONVERTER_0_APBmslave_PRDATA ),
        .MIRRORED_SLAVE_AXI4_araddr_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARADDR ),
        .MIRRORED_SLAVE_AXI4_arburst_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARBURST ),
        .MIRRORED_SLAVE_AXI4_arcache_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARCACHE ),
        .MIRRORED_SLAVE_AXI4_arid_0    ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARID ),
        .MIRRORED_SLAVE_AXI4_arlen_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLEN ),
        .MIRRORED_SLAVE_AXI4_arlock_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARLOCK ),
        .MIRRORED_SLAVE_AXI4_arprot_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARPROT ),
        .MIRRORED_SLAVE_AXI4_arsize_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_ARSIZE ),
        .MIRRORED_SLAVE_AXI4_awaddr_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWADDR ),
        .MIRRORED_SLAVE_AXI4_awburst_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWBURST ),
        .MIRRORED_SLAVE_AXI4_awcache_0 ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWCACHE ),
        .MIRRORED_SLAVE_AXI4_awid_0    ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWID ),
        .MIRRORED_SLAVE_AXI4_awlen_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLEN ),
        .MIRRORED_SLAVE_AXI4_awlock_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWLOCK ),
        .MIRRORED_SLAVE_AXI4_awprot_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWPROT ),
        .MIRRORED_SLAVE_AXI4_awsize_0  ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_AWSIZE ),
        .MIRRORED_SLAVE_AXI4_wdata_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WDATA ),
        .MIRRORED_SLAVE_AXI4_wstrb_0   ( top_ddr_write_0_MIRRORED_SLAVE_AXI4_WSTRB ) 
        );


endmodule
