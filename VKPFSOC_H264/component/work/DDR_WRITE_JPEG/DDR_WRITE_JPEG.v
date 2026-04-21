//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Mar  9 13:56:26 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// DDR_WRITE_JPEG
module DDR_WRITE_JPEG(
    // Inputs
    data_i,
    data_valid_i,
    ddr_clk_i,
    encoder_en_i,
    frame_ddr_addr_i,
    frame_end_i,
    reset_i,
    sys_clk_i,
    write_ackn_i,
    write_done_i,
    // Outputs
    frm_interrupt_o,
    rdata_o,
    rdata_rdy_o,
    write_length_o,
    write_req_o,
    write_start_addr_o
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  [15:0] data_i;
input         data_valid_i;
input         ddr_clk_i;
input         encoder_en_i;
input  [9:0]  frame_ddr_addr_i;
input         frame_end_i;
input         reset_i;
input         sys_clk_i;
input         write_ackn_i;
input         write_done_i;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output        frm_interrupt_o;
output [63:0] rdata_o;
output        rdata_rdy_o;
output [7:0]  write_length_o;
output        write_req_o;
output [31:0] write_start_addr_o;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire          AND2_1_Y;
wire   [15:0] data_i;
wire   [63:0] data_packer_0_data_o;
wire          data_packer_0_data_valid_o;
wire          data_packer_0_frame_end_o;
wire          data_valid_i;
wire          ddr_clk_i;
wire          ddr_write_controller_enc_0_fifo_reset_o;
wire          ddr_write_controller_enc_0_read_fifo_o;
wire          encoder_en_i;
wire   [9:0]  frame_ddr_addr_i;
wire          frame_end_i;
wire          frm_interrupt_o_net_0;
wire   [63:0] rdata_o_net_0;
wire          rdata_rdy_o_net_0;
wire          reset_i;
wire          sys_clk_i;
wire   [11:0] video_fifo_0_rdata_count_o;
wire          write_ackn_i;
wire          write_done_i;
wire   [7:0]  write_length_o_net_0;
wire          write_req_o_net_0;
wire   [31:0] write_start_addr_o_net_0;
wire          frm_interrupt_o_net_1;
wire          rdata_rdy_o_net_1;
wire          write_req_o_net_1;
wire   [63:0] rdata_o_net_1;
wire   [7:0]  write_length_o_net_1;
wire   [31:0] write_start_addr_o_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign frm_interrupt_o_net_1    = frm_interrupt_o_net_0;
assign frm_interrupt_o          = frm_interrupt_o_net_1;
assign rdata_rdy_o_net_1        = rdata_rdy_o_net_0;
assign rdata_rdy_o              = rdata_rdy_o_net_1;
assign write_req_o_net_1        = write_req_o_net_0;
assign write_req_o              = write_req_o_net_1;
assign rdata_o_net_1            = rdata_o_net_0;
assign rdata_o[63:0]            = rdata_o_net_1;
assign write_length_o_net_1     = write_length_o_net_0;
assign write_length_o[7:0]      = write_length_o_net_1;
assign write_start_addr_o_net_1 = write_start_addr_o_net_0;
assign write_start_addr_o[31:0] = write_start_addr_o_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------AND2
AND2 AND2_1(
        // Inputs
        .A ( reset_i ),
        .B ( ddr_write_controller_enc_0_fifo_reset_o ),
        // Outputs
        .Y ( AND2_1_Y ) 
        );

//--------data_packer
data_packer #( 
        .g_IP_DW ( 16 ),
        .g_OP_DW ( 64 ) )
data_packer_0(
        // Inputs
        .reset_i      ( encoder_en_i ),
        .sys_clk_i    ( sys_clk_i ),
        .data_valid_i ( data_valid_i ),
        .frame_end_i  ( frame_end_i ),
        .data_i       ( data_i ),
        // Outputs
        .data_valid_o ( data_packer_0_data_valid_o ),
        .frame_end_o  ( data_packer_0_frame_end_o ),
        .data_o       ( data_packer_0_data_o ) 
        );

//--------ddr_write_controller_enc
ddr_write_controller_enc ddr_write_controller_enc_0(
        // Inputs
        .reset_i            ( reset_i ),
        .sys_clk_i          ( ddr_clk_i ),
        .wrclk_reset_i      ( reset_i ),
        .wrclk_i            ( sys_clk_i ),
        .eof_i              ( data_packer_0_frame_end_o ),
        .encoder_en_i       ( encoder_en_i ),
        .write_ackn_i       ( write_ackn_i ),
        .write_done_i       ( write_done_i ),
        .fifo_count_i       ( video_fifo_0_rdata_count_o ),
        .frame_ddr_addr_i   ( frame_ddr_addr_i ),
        // Outputs
        .fifo_reset_o       ( ddr_write_controller_enc_0_fifo_reset_o ),
        .read_fifo_o        ( ddr_write_controller_enc_0_read_fifo_o ),
        .frm_interrupt_o    ( frm_interrupt_o_net_0 ),
        .write_req_o        ( write_req_o_net_0 ),
        .write_start_addr_o ( write_start_addr_o_net_0 ),
        .write_length_o     ( write_length_o_net_0 ) 
        );

//--------video_fifo
video_fifo #( 
        .g_HALF_EMPTY_THRESHOLD       ( 1280 ),
        .g_INPUT_VIDEO_DATA_BIT_WIDTH ( 64 ),
        .g_VIDEO_FIFO_AWIDTH          ( 12 ) )
video_fifo_0(
        // Inputs
        .wclock_i      ( sys_clk_i ),
        .wresetn_i     ( AND2_1_Y ),
        .wen_i         ( data_packer_0_data_valid_o ),
        .rclock_i      ( ddr_clk_i ),
        .rresetn_i     ( AND2_1_Y ),
        .ren_i         ( ddr_write_controller_enc_0_read_fifo_o ),
        .wdata_i       ( data_packer_0_data_o ),
        // Outputs
        .wfull_o       (  ),
        .wafull_o      (  ),
        .rdata_rdy_o   ( rdata_rdy_o_net_0 ),
        .rempty_o      (  ),
        .raempty_o     (  ),
        .rhempty_o     (  ),
        .wdata_count_o (  ),
        .rdata_o       ( rdata_o_net_0 ),
        .rdata_count_o ( video_fifo_0_rdata_count_o ) 
        );


endmodule
