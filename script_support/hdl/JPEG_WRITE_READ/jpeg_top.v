///////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>
module jpeg_top #(
    parameter ADDR_WIDTH = 8//24 3 8
)(
    // -------- APB interface --------
    input  wire         pclk,
    input  wire         presetn,
    input  wire         psel,
    input  wire         pwrite,
    input  wire [31:0]  paddr,
    input  wire [31:0]  pwdata,
    output wire [31:0]  prdata,
    output wire         pready,
    output wire         pslverr,
    input wire          clk_sys,
    input wire          resetn,
    input  wire         apb_pin,
    // -------- RAM interface --------
    input  wire [7:0]   ram_read_data,
    output wire [ADDR_WIDTH-1:0] ram_read_addr,
    input   wire                  ram_data_valid,


    // -------- Output compressed data --------
    output wire [15:0]  o_data_pck,
    output wire         o_e_pck,

    // -------- Status --------
    output wire         sof_flag,
    output wire         eof_flag,
    //output wire [31:0]  compressed_size_o,
    output wire     horz_resl_o,
    output wire [7:0]  ddr_base_addr_o,
    output wire         read_en_i,
    output wire         encoder_active_o
);

    // ===============================
    // Internal wires
    // ===============================
    // APB  FSM
    wire        i_sof_ps;
    wire [13:0] i_w;
    wire [13:0] i_h;
    wire [7:0]  near;
    // FSM  JPEG
    wire        i_sof;
    wire        i_e;
    wire [7:0]  i_x;
    // JPEG  FSM
    wire [15:0] o_data;
    wire        o_e;
    wire        o_last;

    // ===============================
    // APB Wrapper
    // ===============================
    apb_wrapper u_apb (
        .pclk      (pclk),
        .presetn   (presetn),
        .psel      (psel),
        .pwrite    (pwrite),
        .paddr     (paddr),
        .pwdata    (pwdata),
        .prdata    (prdata),
        .pready    (pready),
        .pslverr   (pslverr),
        .apb_pin    (apb_pin),

        .i_sof_ps  (i_sof_ps),
        .i_w       (i_w),
        .i_h       (i_h),
        .near_val      (near),
         .horz_resl_o      ( horz_resl_o ),
       .ddr_base_addr_o  ( ddr_base_addr_o ),
        .o_last    (o_last_flag)
    );

    // ===============================
    // JPEG Control FSM
    // ===============================
    jpeg_control_fsm #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fsm (
        .clk               (clk_sys),
        .rstn              (resetn),

        .i_sof_ps          (i_sof_ps),
        .i_w               (i_w),
        .i_h               (i_h),
        .near              (near),

        .i_sof             (i_sof),
        .i_e               (i_e),
        .i_x               (i_x),

        .o_data            (o_data),
        .o_e               (o_e),
        .o_last            (o_last),

        .o_data_pck        (o_data_pck),
        .o_e_pck           (o_e_pck),

        .sof_flag          (sof_flag),
        .eof_flag          (eof_flag),

        .ram_read_data     (ram_read_data),
       // .ram_read_addr     (ram_read_addr),
        .ram_data_valid     (ram_data_valid),
       // .compressed_size_o (compressed_size_o),
       .read_en_i           (read_en_i),
        .o_last_flag       (o_last_flag),
        .encoder_active_o   (encoder_active_o)
    );

    // ===============================
    // JLS Encoder
    // ===============================
    jls_encoder u_jls (
        .clk     (clk_sys),
        .rstn    (resetn),

        .i_sof   (i_sof),
        .i_w     (i_w),
        .i_h     (i_h),
        .i_e     (i_e),
        .i_x     (i_x),

        .o_e     (o_e),
        .o_last  (o_last),
        .o_data  (o_data)
    );

endmodule
