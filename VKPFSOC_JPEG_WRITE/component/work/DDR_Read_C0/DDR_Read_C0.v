//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Mon Jul  6 16:19:40 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of DDR_Read_C0 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250TS-1FCG1152I
# Create and Configure the core component DDR_Read_C0
create_and_configure_core -core_vlnv {Microchip:SolutionCore:DDR_Read:1.2.0} -component_name {DDR_Read_C0} -params {\
"g_AXI4S_FORMAT:0"  \
"g_DDR_AXI_DWIDTH_I:64"  \
"g_DDR_AXI_DWIDTH_O:8"  \
"g_FORMAT:0"  \
"g_FRAME_GAP:0"  \
"g_HORIZ_RESOL:16"  \
"g_NO_OF_PIXEL:1"   }
# Exporting Component Description of DDR_Read_C0 to TCL done
*/

// DDR_Read_C0
module DDR_Read_C0(
    // Inputs
    ddr_clk_i,
    ddr_data_valid_i,
    frame_start_addr_i,
    frame_start_i,
    h_offset_i,
    horz_resl_i,
    line_gap_i,
    pixel_clk_i,
    read_ackn_i,
    read_done_i,
    read_en_i,
    reset_i,
    v_offset_i,
    wdata_i,
    // Outputs
    burst_size_o,
    data_o,
    data_valid_o,
    read_req_o,
    read_start_addr_o
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input         ddr_clk_i;
input         ddr_data_valid_i;
input  [7:0]  frame_start_addr_i;
input         frame_start_i;
input  [11:0] h_offset_i;
input  [15:0] horz_resl_i;
input  [15:0] line_gap_i;
input         pixel_clk_i;
input         read_ackn_i;
input         read_done_i;
input         read_en_i;
input         reset_i;
input  [11:0] v_offset_i;
input  [63:0] wdata_i;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output [7:0]  burst_size_o;
output [7:0]  data_o;
output        data_valid_o;
output        read_req_o;
output [31:0] read_start_addr_o;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   [7:0]  burst_size_o_net_0;
wire   [7:0]  data_o_net_0;
wire          data_valid_o_net_0;
wire          ddr_clk_i;
wire          ddr_data_valid_i;
wire   [7:0]  frame_start_addr_i;
wire          frame_start_i;
wire   [11:0] h_offset_i;
wire   [15:0] horz_resl_i;
wire   [15:0] line_gap_i;
wire          pixel_clk_i;
wire          read_ackn_i;
wire          read_done_i;
wire          read_en_i;
wire          read_req_o_net_0;
wire   [31:0] read_start_addr_o_net_0;
wire          reset_i;
wire   [11:0] v_offset_i;
wire   [63:0] wdata_i;
wire          read_req_o_net_1;
wire          data_valid_o_net_1;
wire   [31:0] read_start_addr_o_net_1;
wire   [7:0]  burst_size_o_net_1;
wire   [7:0]  data_o_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire          GND_net;
wire   [63:0] RDATA_I_const_net_0;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign GND_net             = 1'b0;
assign RDATA_I_const_net_0 = 64'h0000000000000000;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign read_req_o_net_1        = read_req_o_net_0;
assign read_req_o              = read_req_o_net_1;
assign data_valid_o_net_1      = data_valid_o_net_0;
assign data_valid_o            = data_valid_o_net_1;
assign read_start_addr_o_net_1 = read_start_addr_o_net_0;
assign read_start_addr_o[31:0] = read_start_addr_o_net_1;
assign burst_size_o_net_1      = burst_size_o_net_0;
assign burst_size_o[7:0]       = burst_size_o_net_1;
assign data_o_net_1            = data_o_net_0;
assign data_o[7:0]             = data_o_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------DDR_Read   -   Microchip:SolutionCore:DDR_Read:1.2.0
DDR_Read #( 
        .g_AXI4S_FORMAT     ( 0 ),
        .g_DDR_AXI_DWIDTH_I ( 64 ),
        .g_DDR_AXI_DWIDTH_O ( 8 ),
        .g_FORMAT           ( 0 ),
        .g_FRAME_GAP        ( 0 ),
        .g_HORIZ_RESOL      ( 16 ),
        .g_NO_OF_PIXEL      ( 1 ) )
DDR_Read_C0_0(
        // Inputs
        .reset_i            ( reset_i ),
        .pixel_clk_i        ( pixel_clk_i ),
        .ddr_clk_i          ( ddr_clk_i ),
        .frame_start_i      ( frame_start_i ),
        .read_en_i          ( read_en_i ),
        .read_ackn_i        ( read_ackn_i ),
        .read_done_i        ( read_done_i ),
        .ddr_data_valid_i   ( ddr_data_valid_i ),
        .RVALID_I           ( GND_net ), // tied to 1'b0 from definition
        .ARREADY_I          ( GND_net ), // tied to 1'b0 from definition
        .BUSER_I            ( GND_net ), // tied to 1'b0 from definition
        .line_gap_i         ( line_gap_i ),
        .horz_resl_i        ( horz_resl_i ),
        .frame_start_addr_i ( frame_start_addr_i ),
        .h_offset_i         ( h_offset_i ),
        .v_offset_i         ( v_offset_i ),
        .wdata_i            ( wdata_i ),
        .RDATA_I            ( RDATA_I_const_net_0 ), // tied to 64'h0000000000000000 from definition
        // Outputs
        .ARVALID_O          (  ),
        .read_req_o         ( read_req_o_net_0 ),
        .data_valid_o       ( data_valid_o_net_0 ),
        .TVALID_O           (  ),
        .TLAST_O            (  ),
        .ARADDR_O           (  ),
        .ARSIZE_O           (  ),
        .read_start_addr_o  ( read_start_addr_o_net_0 ),
        .burst_size_o       ( burst_size_o_net_0 ),
        .data_o             ( data_o_net_0 ),
        .TDATA_O            (  ),
        .TSTRB_O            (  ),
        .TKEEP_O            (  ),
        .TUSER_O            (  ) 
        );


endmodule
