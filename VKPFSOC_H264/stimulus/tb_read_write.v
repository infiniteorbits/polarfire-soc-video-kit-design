///////////////////////////////////////////////////////////////////////////////////////////////////
// Company: <Name>
//
// File: tb_read_write.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::PolarFireSoC> <Die::MPFS250TS> <Package::FCG1152>
// Author: <Name>
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

`timescale 1ns/100ps

module tb_read_write;

parameter SYSCLK_PERIOD = 100;// 10MHZ

reg SYSCLK;
reg NSYSRESET;

initial
begin
    SYSCLK = 1'b0;
    NSYSRESET = 1'b0;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
    #(SYSCLK_PERIOD * 10 )
        NSYSRESET = 1'b1;
end


//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;


//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  top_ddr_write_read
//////////////////////////////////////////////////////////////////////
top_ddr_write_read top_ddr_write_read_0 (
    // Inputs
    .APBslave_psel({1{1'b0}}),
    .APBslave_pwrite({1{1'b0}}),
    .ddr_ctrl_ready_i({1{1'b0}}),
    .reset_i(NSYSRESET),
    .sys_clk_i(SYSCLK),
    .apb_pin({1{1'b0}}),
    .pclk(SYSCLK),
    .presetn(NSYSRESET),
    .read_en_i({1{1'b0}}),
    .MIRRORED_SLAVE_AXI4_awready_0({1{1'b0}}),
    .MIRRORED_SLAVE_AXI4_wready_0({1{1'b0}}),
    .MIRRORED_SLAVE_AXI4_bvalid_0({1{1'b0}}),
    .MIRRORED_SLAVE_AXI4_arready_0({1{1'b0}}),
    .MIRRORED_SLAVE_AXI4_rlast_0(NSYSRESET),
    .MIRRORED_SLAVE_AXI4_rvalid_0({1{1'b0}}),
    .APBslave_paddr({32{1'b0}}),
    .APBslave_pwdata({32{1'b0}}),
    .MIRRORED_SLAVE_AXI4_bid_0({4{1'b0}}),
    .MIRRORED_SLAVE_AXI4_bresp_0({2{1'b0}}),
    .MIRRORED_SLAVE_AXI4_rid_0({4{1'b0}}),
    .MIRRORED_SLAVE_AXI4_rdata_0({64{1'b0}}),
    .MIRRORED_SLAVE_AXI4_rresp_0({2{1'b0}}),

    // Outputs
    .APBslave_pready( ),
    .APBslave_pslverr( ),
    .frm_interrupt_o( ),
    .MIRRORED_SLAVE_AXI4_awvalid_0( ),
    .MIRRORED_SLAVE_AXI4_wlast_0( ),
    .MIRRORED_SLAVE_AXI4_wvalid_0( ),
    .MIRRORED_SLAVE_AXI4_bready_0( ),
    .MIRRORED_SLAVE_AXI4_arvalid_0( ),
    .MIRRORED_SLAVE_AXI4_rready_0( ),
    .APBslave_prdata( ),
    .MIRRORED_SLAVE_AXI4_awid_0( ),
    .MIRRORED_SLAVE_AXI4_awaddr_0( ),
    .MIRRORED_SLAVE_AXI4_awlen_0( ),
    .MIRRORED_SLAVE_AXI4_awsize_0( ),
    .MIRRORED_SLAVE_AXI4_awburst_0( ),
    .MIRRORED_SLAVE_AXI4_awlock_0( ),
    .MIRRORED_SLAVE_AXI4_awcache_0( ),
    .MIRRORED_SLAVE_AXI4_awprot_0( ),
    .MIRRORED_SLAVE_AXI4_wdata_0( ),
    .MIRRORED_SLAVE_AXI4_wstrb_0( ),
    .MIRRORED_SLAVE_AXI4_arid_0( ),
    .MIRRORED_SLAVE_AXI4_araddr_0( ),
    .MIRRORED_SLAVE_AXI4_arlen_0( ),
    .MIRRORED_SLAVE_AXI4_arsize_0( ),
    .MIRRORED_SLAVE_AXI4_arburst_0( ),
    .MIRRORED_SLAVE_AXI4_arlock_0( ),
    .MIRRORED_SLAVE_AXI4_arcache_0( ),
    .MIRRORED_SLAVE_AXI4_arprot_0( )

    // Inouts

);

endmodule

