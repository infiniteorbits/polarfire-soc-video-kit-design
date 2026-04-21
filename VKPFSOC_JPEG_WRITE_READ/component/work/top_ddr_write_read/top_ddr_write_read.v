//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Apr 21 10:39:03 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// top_ddr_write_read
module top_ddr_write_read(
    // Inputs
    APBslave_paddr,
    APBslave_psel,
    APBslave_pwdata,
    APBslave_pwrite,
    MIRRORED_SLAVE_AXI4_arready_0,
    MIRRORED_SLAVE_AXI4_awready_0,
    MIRRORED_SLAVE_AXI4_bid_0,
    MIRRORED_SLAVE_AXI4_bresp_0,
    MIRRORED_SLAVE_AXI4_bvalid_0,
    MIRRORED_SLAVE_AXI4_rdata_0,
    MIRRORED_SLAVE_AXI4_rid_0,
    MIRRORED_SLAVE_AXI4_rlast_0,
    MIRRORED_SLAVE_AXI4_rresp_0,
    MIRRORED_SLAVE_AXI4_rvalid_0,
    MIRRORED_SLAVE_AXI4_wready_0,
    apb_pin,
    ddr_ctrl_ready_i,
    frame_start_i,
    line_gap_i,
    pclk,
    presetn,
    reset_i,
    sys_clk_i,
    // Outputs
    APBslave_prdata,
    APBslave_pready,
    APBslave_pslverr,
    MIRRORED_SLAVE_AXI4_araddr_0,
    MIRRORED_SLAVE_AXI4_arburst_0,
    MIRRORED_SLAVE_AXI4_arcache_0,
    MIRRORED_SLAVE_AXI4_arid_0,
    MIRRORED_SLAVE_AXI4_arlen_0,
    MIRRORED_SLAVE_AXI4_arlock_0,
    MIRRORED_SLAVE_AXI4_arprot_0,
    MIRRORED_SLAVE_AXI4_arsize_0,
    MIRRORED_SLAVE_AXI4_arvalid_0,
    MIRRORED_SLAVE_AXI4_awaddr_0,
    MIRRORED_SLAVE_AXI4_awburst_0,
    MIRRORED_SLAVE_AXI4_awcache_0,
    MIRRORED_SLAVE_AXI4_awid_0,
    MIRRORED_SLAVE_AXI4_awlen_0,
    MIRRORED_SLAVE_AXI4_awlock_0,
    MIRRORED_SLAVE_AXI4_awprot_0,
    MIRRORED_SLAVE_AXI4_awsize_0,
    MIRRORED_SLAVE_AXI4_awvalid_0,
    MIRRORED_SLAVE_AXI4_bready_0,
    MIRRORED_SLAVE_AXI4_rready_0,
    MIRRORED_SLAVE_AXI4_wdata_0,
    MIRRORED_SLAVE_AXI4_wlast_0,
    MIRRORED_SLAVE_AXI4_wstrb_0,
    MIRRORED_SLAVE_AXI4_wvalid_0,
    frm_interrupt_o
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [31:0] APBslave_paddr;
input         APBslave_psel;
input  [31:0] APBslave_pwdata;
input         APBslave_pwrite;
input         MIRRORED_SLAVE_AXI4_arready_0;
input         MIRRORED_SLAVE_AXI4_awready_0;
input  [3:0]  MIRRORED_SLAVE_AXI4_bid_0;
input  [1:0]  MIRRORED_SLAVE_AXI4_bresp_0;
input         MIRRORED_SLAVE_AXI4_bvalid_0;
input  [63:0] MIRRORED_SLAVE_AXI4_rdata_0;
input  [3:0]  MIRRORED_SLAVE_AXI4_rid_0;
input         MIRRORED_SLAVE_AXI4_rlast_0;
input  [1:0]  MIRRORED_SLAVE_AXI4_rresp_0;
input         MIRRORED_SLAVE_AXI4_rvalid_0;
input         MIRRORED_SLAVE_AXI4_wready_0;
input         apb_pin;
input         ddr_ctrl_ready_i;
input         frame_start_i;
input  [15:0] line_gap_i;
input         pclk;
input         presetn;
input         reset_i;
input         sys_clk_i;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [31:0] APBslave_prdata;
output        APBslave_pready;
output        APBslave_pslverr;
output [31:0] MIRRORED_SLAVE_AXI4_araddr_0;
output [1:0]  MIRRORED_SLAVE_AXI4_arburst_0;
output [3:0]  MIRRORED_SLAVE_AXI4_arcache_0;
output [3:0]  MIRRORED_SLAVE_AXI4_arid_0;
output [7:0]  MIRRORED_SLAVE_AXI4_arlen_0;
output [1:0]  MIRRORED_SLAVE_AXI4_arlock_0;
output [2:0]  MIRRORED_SLAVE_AXI4_arprot_0;
output [2:0]  MIRRORED_SLAVE_AXI4_arsize_0;
output        MIRRORED_SLAVE_AXI4_arvalid_0;
output [31:0] MIRRORED_SLAVE_AXI4_awaddr_0;
output [1:0]  MIRRORED_SLAVE_AXI4_awburst_0;
output [3:0]  MIRRORED_SLAVE_AXI4_awcache_0;
output [3:0]  MIRRORED_SLAVE_AXI4_awid_0;
output [7:0]  MIRRORED_SLAVE_AXI4_awlen_0;
output [1:0]  MIRRORED_SLAVE_AXI4_awlock_0;
output [2:0]  MIRRORED_SLAVE_AXI4_awprot_0;
output [2:0]  MIRRORED_SLAVE_AXI4_awsize_0;
output        MIRRORED_SLAVE_AXI4_awvalid_0;
output        MIRRORED_SLAVE_AXI4_bready_0;
output        MIRRORED_SLAVE_AXI4_rready_0;
output [63:0] MIRRORED_SLAVE_AXI4_wdata_0;
output        MIRRORED_SLAVE_AXI4_wlast_0;
output [7:0]  MIRRORED_SLAVE_AXI4_wstrb_0;
output        MIRRORED_SLAVE_AXI4_wvalid_0;
output        frm_interrupt_o;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          apb_pin;
wire   [31:0] APBslave_paddr;
wire   [31:0] APBslave_PRDATA_net_0;
wire          APBslave_PREADY_net_0;
wire          APBslave_psel;
wire          APBslave_PSLVERR_net_0;
wire   [31:0] APBslave_pwdata;
wire          APBslave_pwrite;
wire          DDR_AXI4_ARBITER_PF_C0_0_r0_ack_o;
wire          DDR_AXI4_ARBITER_PF_C0_0_r0_data_valid_o;
wire          DDR_AXI4_ARBITER_PF_C0_0_r0_done_o;
wire   [63:0] DDR_AXI4_ARBITER_PF_C0_0_rdata_o;
wire          DDR_AXI4_ARBITER_PF_C0_0_w0_ack_o;
wire          DDR_AXI4_ARBITER_PF_C0_0_w0_done_o;
wire          ddr_ctrl_ready_i;
wire   [7:0]  DDR_Read_C0_0_burst_size_o;
wire   [7:0]  DDR_Read_C0_0_data_o;
wire          DDR_Read_C0_0_data_valid_o;
wire          DDR_Read_C0_0_read_req_o;
wire   [31:0] DDR_Read_C0_0_read_start_addr_o;
wire   [63:0] DDR_WRITE_JPEG_0_rdata_o;
wire          DDR_WRITE_JPEG_0_rdata_rdy_o;
wire   [7:0]  DDR_WRITE_JPEG_0_write_length_o;
wire          DDR_WRITE_JPEG_0_write_req_o;
wire   [31:0] DDR_WRITE_JPEG_0_write_start_addr_o;
wire          frame_start_i;
wire          frm_interrupt_o_net_0;
wire   [7:0]  jpeg_top_1_ddr_base_addr_o;
wire          jpeg_top_1_encoder_active_o;
wire          jpeg_top_1_eof_flag;
wire   [15:0] jpeg_top_1_horz_resl_o;
wire   [15:0] jpeg_top_1_o_data_pck;
wire          jpeg_top_1_o_e_pck;
wire          jpeg_top_1_read_en_i;
wire   [15:0] line_gap_i;
wire   [31:0] MIRRORED_SLAVE_AXI4_ARADDR;
wire   [1:0]  MIRRORED_SLAVE_AXI4_ARBURST;
wire   [3:0]  MIRRORED_SLAVE_AXI4_ARCACHE;
wire   [3:0]  MIRRORED_SLAVE_AXI4_ARID;
wire   [7:0]  MIRRORED_SLAVE_AXI4_ARLEN;
wire   [1:0]  MIRRORED_SLAVE_AXI4_ARLOCK;
wire   [2:0]  MIRRORED_SLAVE_AXI4_ARPROT;
wire          MIRRORED_SLAVE_AXI4_arready_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_ARSIZE;
wire          MIRRORED_SLAVE_AXI4_ARVALID;
wire   [31:0] MIRRORED_SLAVE_AXI4_AWADDR;
wire   [1:0]  MIRRORED_SLAVE_AXI4_AWBURST;
wire   [3:0]  MIRRORED_SLAVE_AXI4_AWCACHE;
wire   [3:0]  MIRRORED_SLAVE_AXI4_AWID;
wire   [7:0]  MIRRORED_SLAVE_AXI4_AWLEN;
wire   [1:0]  MIRRORED_SLAVE_AXI4_AWLOCK;
wire   [2:0]  MIRRORED_SLAVE_AXI4_AWPROT;
wire          MIRRORED_SLAVE_AXI4_awready_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_AWSIZE;
wire          MIRRORED_SLAVE_AXI4_AWVALID;
wire   [3:0]  MIRRORED_SLAVE_AXI4_bid_0;
wire          MIRRORED_SLAVE_AXI4_BREADY;
wire   [1:0]  MIRRORED_SLAVE_AXI4_bresp_0;
wire          MIRRORED_SLAVE_AXI4_bvalid_0;
wire   [63:0] MIRRORED_SLAVE_AXI4_rdata_0;
wire   [3:0]  MIRRORED_SLAVE_AXI4_rid_0;
wire          MIRRORED_SLAVE_AXI4_rlast_0;
wire          MIRRORED_SLAVE_AXI4_RREADY;
wire   [1:0]  MIRRORED_SLAVE_AXI4_rresp_0;
wire          MIRRORED_SLAVE_AXI4_rvalid_0;
wire   [63:0] MIRRORED_SLAVE_AXI4_WDATA;
wire          MIRRORED_SLAVE_AXI4_WLAST;
wire          MIRRORED_SLAVE_AXI4_wready_0;
wire   [7:0]  MIRRORED_SLAVE_AXI4_WSTRB;
wire          MIRRORED_SLAVE_AXI4_WVALID;
wire          pclk;
wire          presetn;
wire          reset_i;
wire          sys_clk_i;
wire          MIRRORED_SLAVE_AXI4_ARVALID_net_0;
wire          MIRRORED_SLAVE_AXI4_AWVALID_net_0;
wire          MIRRORED_SLAVE_AXI4_BREADY_net_0;
wire          MIRRORED_SLAVE_AXI4_RREADY_net_0;
wire          MIRRORED_SLAVE_AXI4_WLAST_net_0;
wire          MIRRORED_SLAVE_AXI4_WVALID_net_0;
wire          frm_interrupt_o_net_1;
wire          APBslave_PREADY_net_1;
wire          APBslave_PSLVERR_net_1;
wire   [31:0] MIRRORED_SLAVE_AXI4_ARADDR_net_0;
wire   [1:0]  MIRRORED_SLAVE_AXI4_ARBURST_net_0;
wire   [3:0]  MIRRORED_SLAVE_AXI4_ARCACHE_net_0;
wire   [3:0]  MIRRORED_SLAVE_AXI4_ARID_net_0;
wire   [7:0]  MIRRORED_SLAVE_AXI4_ARLEN_net_0;
wire   [1:0]  MIRRORED_SLAVE_AXI4_ARLOCK_net_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_ARPROT_net_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_ARSIZE_net_0;
wire   [31:0] MIRRORED_SLAVE_AXI4_AWADDR_net_0;
wire   [1:0]  MIRRORED_SLAVE_AXI4_AWBURST_net_0;
wire   [3:0]  MIRRORED_SLAVE_AXI4_AWCACHE_net_0;
wire   [3:0]  MIRRORED_SLAVE_AXI4_AWID_net_0;
wire   [7:0]  MIRRORED_SLAVE_AXI4_AWLEN_net_0;
wire   [1:0]  MIRRORED_SLAVE_AXI4_AWLOCK_net_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_AWPROT_net_0;
wire   [2:0]  MIRRORED_SLAVE_AXI4_AWSIZE_net_0;
wire   [63:0] MIRRORED_SLAVE_AXI4_WDATA_net_0;
wire   [7:0]  MIRRORED_SLAVE_AXI4_WSTRB_net_0;
wire   [31:0] APBslave_PRDATA_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   [11:0] h_offset_i_const_net_0;
wire   [11:0] v_offset_i_const_net_0;
wire   [9:0]  frame_ddr_addr_i_const_net_0;
wire   [2:0]  addr_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign h_offset_i_const_net_0       = 12'h000;
assign v_offset_i_const_net_0       = 12'h000;
assign frame_ddr_addr_i_const_net_0 = 10'h000;
assign addr_const_net_0             = 3'h0;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MIRRORED_SLAVE_AXI4_ARVALID_net_0  = MIRRORED_SLAVE_AXI4_ARVALID;
assign MIRRORED_SLAVE_AXI4_arvalid_0      = MIRRORED_SLAVE_AXI4_ARVALID_net_0;
assign MIRRORED_SLAVE_AXI4_AWVALID_net_0  = MIRRORED_SLAVE_AXI4_AWVALID;
assign MIRRORED_SLAVE_AXI4_awvalid_0      = MIRRORED_SLAVE_AXI4_AWVALID_net_0;
assign MIRRORED_SLAVE_AXI4_BREADY_net_0   = MIRRORED_SLAVE_AXI4_BREADY;
assign MIRRORED_SLAVE_AXI4_bready_0       = MIRRORED_SLAVE_AXI4_BREADY_net_0;
assign MIRRORED_SLAVE_AXI4_RREADY_net_0   = MIRRORED_SLAVE_AXI4_RREADY;
assign MIRRORED_SLAVE_AXI4_rready_0       = MIRRORED_SLAVE_AXI4_RREADY_net_0;
assign MIRRORED_SLAVE_AXI4_WLAST_net_0    = MIRRORED_SLAVE_AXI4_WLAST;
assign MIRRORED_SLAVE_AXI4_wlast_0        = MIRRORED_SLAVE_AXI4_WLAST_net_0;
assign MIRRORED_SLAVE_AXI4_WVALID_net_0   = MIRRORED_SLAVE_AXI4_WVALID;
assign MIRRORED_SLAVE_AXI4_wvalid_0       = MIRRORED_SLAVE_AXI4_WVALID_net_0;
assign frm_interrupt_o_net_1              = frm_interrupt_o_net_0;
assign frm_interrupt_o                    = frm_interrupt_o_net_1;
assign APBslave_PREADY_net_1              = APBslave_PREADY_net_0;
assign APBslave_pready                    = APBslave_PREADY_net_1;
assign APBslave_PSLVERR_net_1             = APBslave_PSLVERR_net_0;
assign APBslave_pslverr                   = APBslave_PSLVERR_net_1;
assign MIRRORED_SLAVE_AXI4_ARADDR_net_0   = MIRRORED_SLAVE_AXI4_ARADDR;
assign MIRRORED_SLAVE_AXI4_araddr_0[31:0] = MIRRORED_SLAVE_AXI4_ARADDR_net_0;
assign MIRRORED_SLAVE_AXI4_ARBURST_net_0  = MIRRORED_SLAVE_AXI4_ARBURST;
assign MIRRORED_SLAVE_AXI4_arburst_0[1:0] = MIRRORED_SLAVE_AXI4_ARBURST_net_0;
assign MIRRORED_SLAVE_AXI4_ARCACHE_net_0  = MIRRORED_SLAVE_AXI4_ARCACHE;
assign MIRRORED_SLAVE_AXI4_arcache_0[3:0] = MIRRORED_SLAVE_AXI4_ARCACHE_net_0;
assign MIRRORED_SLAVE_AXI4_ARID_net_0     = MIRRORED_SLAVE_AXI4_ARID;
assign MIRRORED_SLAVE_AXI4_arid_0[3:0]    = MIRRORED_SLAVE_AXI4_ARID_net_0;
assign MIRRORED_SLAVE_AXI4_ARLEN_net_0    = MIRRORED_SLAVE_AXI4_ARLEN;
assign MIRRORED_SLAVE_AXI4_arlen_0[7:0]   = MIRRORED_SLAVE_AXI4_ARLEN_net_0;
assign MIRRORED_SLAVE_AXI4_ARLOCK_net_0   = MIRRORED_SLAVE_AXI4_ARLOCK;
assign MIRRORED_SLAVE_AXI4_arlock_0[1:0]  = MIRRORED_SLAVE_AXI4_ARLOCK_net_0;
assign MIRRORED_SLAVE_AXI4_ARPROT_net_0   = MIRRORED_SLAVE_AXI4_ARPROT;
assign MIRRORED_SLAVE_AXI4_arprot_0[2:0]  = MIRRORED_SLAVE_AXI4_ARPROT_net_0;
assign MIRRORED_SLAVE_AXI4_ARSIZE_net_0   = MIRRORED_SLAVE_AXI4_ARSIZE;
assign MIRRORED_SLAVE_AXI4_arsize_0[2:0]  = MIRRORED_SLAVE_AXI4_ARSIZE_net_0;
assign MIRRORED_SLAVE_AXI4_AWADDR_net_0   = MIRRORED_SLAVE_AXI4_AWADDR;
assign MIRRORED_SLAVE_AXI4_awaddr_0[31:0] = MIRRORED_SLAVE_AXI4_AWADDR_net_0;
assign MIRRORED_SLAVE_AXI4_AWBURST_net_0  = MIRRORED_SLAVE_AXI4_AWBURST;
assign MIRRORED_SLAVE_AXI4_awburst_0[1:0] = MIRRORED_SLAVE_AXI4_AWBURST_net_0;
assign MIRRORED_SLAVE_AXI4_AWCACHE_net_0  = MIRRORED_SLAVE_AXI4_AWCACHE;
assign MIRRORED_SLAVE_AXI4_awcache_0[3:0] = MIRRORED_SLAVE_AXI4_AWCACHE_net_0;
assign MIRRORED_SLAVE_AXI4_AWID_net_0     = MIRRORED_SLAVE_AXI4_AWID;
assign MIRRORED_SLAVE_AXI4_awid_0[3:0]    = MIRRORED_SLAVE_AXI4_AWID_net_0;
assign MIRRORED_SLAVE_AXI4_AWLEN_net_0    = MIRRORED_SLAVE_AXI4_AWLEN;
assign MIRRORED_SLAVE_AXI4_awlen_0[7:0]   = MIRRORED_SLAVE_AXI4_AWLEN_net_0;
assign MIRRORED_SLAVE_AXI4_AWLOCK_net_0   = MIRRORED_SLAVE_AXI4_AWLOCK;
assign MIRRORED_SLAVE_AXI4_awlock_0[1:0]  = MIRRORED_SLAVE_AXI4_AWLOCK_net_0;
assign MIRRORED_SLAVE_AXI4_AWPROT_net_0   = MIRRORED_SLAVE_AXI4_AWPROT;
assign MIRRORED_SLAVE_AXI4_awprot_0[2:0]  = MIRRORED_SLAVE_AXI4_AWPROT_net_0;
assign MIRRORED_SLAVE_AXI4_AWSIZE_net_0   = MIRRORED_SLAVE_AXI4_AWSIZE;
assign MIRRORED_SLAVE_AXI4_awsize_0[2:0]  = MIRRORED_SLAVE_AXI4_AWSIZE_net_0;
assign MIRRORED_SLAVE_AXI4_WDATA_net_0    = MIRRORED_SLAVE_AXI4_WDATA;
assign MIRRORED_SLAVE_AXI4_wdata_0[63:0]  = MIRRORED_SLAVE_AXI4_WDATA_net_0;
assign MIRRORED_SLAVE_AXI4_WSTRB_net_0    = MIRRORED_SLAVE_AXI4_WSTRB;
assign MIRRORED_SLAVE_AXI4_wstrb_0[7:0]   = MIRRORED_SLAVE_AXI4_WSTRB_net_0;
assign APBslave_PRDATA_net_1              = APBslave_PRDATA_net_0;
assign APBslave_prdata[31:0]              = APBslave_PRDATA_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DDR_AXI4_ARBITER_PF_C0
DDR_AXI4_ARBITER_PF_C0 DDR_AXI4_ARBITER_PF_C0_0(
        // Inputs
        .reset_i          ( reset_i ),
        .sys_clk_i        ( sys_clk_i ),
        .ddr_ctrl_ready_i ( ddr_ctrl_ready_i ),
        .r0_req_i         ( DDR_Read_C0_0_read_req_o ),
        .w0_data_valid_i  ( DDR_WRITE_JPEG_0_rdata_rdy_o ),
        .w0_req_i         ( DDR_WRITE_JPEG_0_write_req_o ),
        .awready          ( MIRRORED_SLAVE_AXI4_awready_0 ),
        .wready           ( MIRRORED_SLAVE_AXI4_wready_0 ),
        .bvalid           ( MIRRORED_SLAVE_AXI4_bvalid_0 ),
        .arready          ( MIRRORED_SLAVE_AXI4_arready_0 ),
        .rlast            ( MIRRORED_SLAVE_AXI4_rlast_0 ),
        .rvalid           ( MIRRORED_SLAVE_AXI4_rvalid_0 ),
        .r0_burst_size_i  ( DDR_Read_C0_0_burst_size_o ),
        .r0_rstart_addr_i ( DDR_Read_C0_0_read_start_addr_o ),
        .w0_burst_size_i  ( DDR_WRITE_JPEG_0_write_length_o ),
        .w0_data_i        ( DDR_WRITE_JPEG_0_rdata_o ),
        .w0_wstart_addr_i ( DDR_WRITE_JPEG_0_write_start_addr_o ),
        .bid              ( MIRRORED_SLAVE_AXI4_bid_0 ),
        .bresp            ( MIRRORED_SLAVE_AXI4_bresp_0 ),
        .rid              ( MIRRORED_SLAVE_AXI4_rid_0 ),
        .rdata            ( MIRRORED_SLAVE_AXI4_rdata_0 ),
        .rresp            ( MIRRORED_SLAVE_AXI4_rresp_0 ),
        // Outputs
        .r0_ack_o         ( DDR_AXI4_ARBITER_PF_C0_0_r0_ack_o ),
        .r0_data_valid_o  ( DDR_AXI4_ARBITER_PF_C0_0_r0_data_valid_o ),
        .r0_done_o        ( DDR_AXI4_ARBITER_PF_C0_0_r0_done_o ),
        .w0_ack_o         ( DDR_AXI4_ARBITER_PF_C0_0_w0_ack_o ),
        .w0_done_o        ( DDR_AXI4_ARBITER_PF_C0_0_w0_done_o ),
        .awvalid          ( MIRRORED_SLAVE_AXI4_AWVALID ),
        .wlast            ( MIRRORED_SLAVE_AXI4_WLAST ),
        .wvalid           ( MIRRORED_SLAVE_AXI4_WVALID ),
        .bready           ( MIRRORED_SLAVE_AXI4_BREADY ),
        .arvalid          ( MIRRORED_SLAVE_AXI4_ARVALID ),
        .rready           ( MIRRORED_SLAVE_AXI4_RREADY ),
        .rdata_o          ( DDR_AXI4_ARBITER_PF_C0_0_rdata_o ),
        .awid             ( MIRRORED_SLAVE_AXI4_AWID ),
        .awaddr           ( MIRRORED_SLAVE_AXI4_AWADDR ),
        .awlen            ( MIRRORED_SLAVE_AXI4_AWLEN ),
        .awsize           ( MIRRORED_SLAVE_AXI4_AWSIZE ),
        .awburst          ( MIRRORED_SLAVE_AXI4_AWBURST ),
        .awlock           ( MIRRORED_SLAVE_AXI4_AWLOCK ),
        .awcache          ( MIRRORED_SLAVE_AXI4_AWCACHE ),
        .awprot           ( MIRRORED_SLAVE_AXI4_AWPROT ),
        .wdata            ( MIRRORED_SLAVE_AXI4_WDATA ),
        .wstrb            ( MIRRORED_SLAVE_AXI4_WSTRB ),
        .arid             ( MIRRORED_SLAVE_AXI4_ARID ),
        .araddr           ( MIRRORED_SLAVE_AXI4_ARADDR ),
        .arlen            ( MIRRORED_SLAVE_AXI4_ARLEN ),
        .arsize           ( MIRRORED_SLAVE_AXI4_ARSIZE ),
        .arburst          ( MIRRORED_SLAVE_AXI4_ARBURST ),
        .arlock           ( MIRRORED_SLAVE_AXI4_ARLOCK ),
        .arcache          ( MIRRORED_SLAVE_AXI4_ARCACHE ),
        .arprot           ( MIRRORED_SLAVE_AXI4_ARPROT ) 
        );

//--------DDR_Read_C0
DDR_Read_C0 DDR_Read_C0_0(
        // Inputs
        .reset_i            ( reset_i ),
        .pixel_clk_i        ( sys_clk_i ),
        .ddr_clk_i          ( sys_clk_i ),
        .frame_start_i      ( frame_start_i ),
        .read_en_i          ( jpeg_top_1_read_en_i ),
        .read_ackn_i        ( DDR_AXI4_ARBITER_PF_C0_0_r0_ack_o ),
        .read_done_i        ( DDR_AXI4_ARBITER_PF_C0_0_r0_done_o ),
        .ddr_data_valid_i   ( DDR_AXI4_ARBITER_PF_C0_0_r0_data_valid_o ),
        .line_gap_i         ( line_gap_i ),
        .horz_resl_i        ( jpeg_top_1_horz_resl_o ),
        .frame_start_addr_i ( jpeg_top_1_ddr_base_addr_o ),
        .h_offset_i         ( h_offset_i_const_net_0 ),
        .v_offset_i         ( v_offset_i_const_net_0 ),
        .wdata_i            ( DDR_AXI4_ARBITER_PF_C0_0_rdata_o ),
        // Outputs
        .read_req_o         ( DDR_Read_C0_0_read_req_o ),
        .data_valid_o       ( DDR_Read_C0_0_data_valid_o ),
        .read_start_addr_o  ( DDR_Read_C0_0_read_start_addr_o ),
        .burst_size_o       ( DDR_Read_C0_0_burst_size_o ),
        .data_o             ( DDR_Read_C0_0_data_o ) 
        );

//--------DDR_WRITE_JPEG
DDR_WRITE_JPEG DDR_WRITE_JPEG_0(
        // Inputs
        .data_valid_i       ( jpeg_top_1_o_e_pck ),
        .ddr_clk_i          ( sys_clk_i ),
        .frame_end_i        ( jpeg_top_1_eof_flag ),
        .sys_clk_i          ( sys_clk_i ),
        .encoder_en_i       ( jpeg_top_1_encoder_active_o ),
        .reset_i            ( reset_i ),
        .write_ackn_i       ( DDR_AXI4_ARBITER_PF_C0_0_w0_ack_o ),
        .write_done_i       ( DDR_AXI4_ARBITER_PF_C0_0_w0_done_o ),
        .data_i             ( jpeg_top_1_o_data_pck ),
        .frame_ddr_addr_i   ( frame_ddr_addr_i_const_net_0 ),
        // Outputs
        .frm_interrupt_o    ( frm_interrupt_o_net_0 ),
        .rdata_rdy_o        ( DDR_WRITE_JPEG_0_rdata_rdy_o ),
        .write_req_o        ( DDR_WRITE_JPEG_0_write_req_o ),
        .rdata_o            ( DDR_WRITE_JPEG_0_rdata_o ),
        .write_length_o     ( DDR_WRITE_JPEG_0_write_length_o ),
        .write_start_addr_o ( DDR_WRITE_JPEG_0_write_start_addr_o ) 
        );

//--------jpeg_top
jpeg_top #( 
        .ADDR_WIDTH ( 8 ) )
jpeg_top_1(
        // Inputs
        .pclk             ( pclk ),
        .presetn          ( presetn ),
        .psel             ( APBslave_psel ),
        .pwrite           ( APBslave_pwrite ),
        .clk_sys          ( sys_clk_i ),
        .resetn           ( reset_i ),
        .apb_pin          ( apb_pin ),
        .ram_data_valid   ( DDR_Read_C0_0_data_valid_o ),
        .paddr            ( APBslave_paddr ),
        .pwdata           ( APBslave_pwdata ),
        .ram_read_data    ( DDR_Read_C0_0_data_o ),
        // Outputs
        .pready           ( APBslave_PREADY_net_0 ),
        .pslverr          ( APBslave_PSLVERR_net_0 ),
        .o_e_pck          ( jpeg_top_1_o_e_pck ),
        .sof_flag         (  ),
        .eof_flag         ( jpeg_top_1_eof_flag ),
        .encoder_active_o ( jpeg_top_1_encoder_active_o ),
        .read_en_i        ( jpeg_top_1_read_en_i ),
        .prdata           ( APBslave_PRDATA_net_0 ),
        .horz_resl_o      ( jpeg_top_1_horz_resl_o ),
        .ddr_base_addr_o  ( jpeg_top_1_ddr_base_addr_o ),
        .o_data_pck       ( jpeg_top_1_o_data_pck ) 
        );

//--------ram8bit_input
ram8bit_input ram8bit_input_0(
        // Inputs
        .addr ( addr_const_net_0 ),
        // Outputs
        .dout (  ) 
        );


endmodule
