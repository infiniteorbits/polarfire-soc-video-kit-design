
`timescale 1ns/1ps

`include "ddr4.sv"


module DDR_WRITE_tb;

    // DUT signals
    reg apb_pin= 1'b0;

    wire [13:0] DDR_A;
    wire        DDR_ACT_N;
    wire [1:0]  DDR_BA;
    
    wire        DDR_BG;

    wire        DDR_CAS_N;
    wire        DDR_RAS_N;
    wire        DDR_WE_N;

    wire        DDR_CKE_0;
    wire        DDR_CS_N;

    wire        DDR_CK0;
    wire        DDR_CK0_N;

    wire        DDR_ODT_0;
    wire        DDR_RESET_N_0;

    wire        DDR_SHIELD0;
    wire        DDR_SHIELD1;

    wire [1:0]  DDR_DM_N;

    wire [15:0] DDR_DQ_0;
    wire [1:0]  DDR_DQS_0;
    wire [1:0]  DDR_DQS_N_0;

    wire DDR4_MEM_ALERT_N;

    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------
    ddr_write DUT (
        .apb_pin       (apb_pin),

        .DDR_A         (DDR_A),
        .DDR_ACT_N     (DDR_ACT_N),
        .DDR_BA        (DDR_BA),
        .DDR_BG        (DDR_BG),

        .DDR_CAS_N     (DDR_CAS_N),
        .DDR_CK0       (DDR_CK0),
        .DDR_CK0_N     (DDR_CK0_N),

        .DDR_CKE_0     (DDR_CKE_0),
        .DDR_CS_N      (DDR_CS_N),

        .DDR_DM_N      (DDR_DM_N),

        .DDR_ODT_0     (DDR_ODT_0),

        .DDR_RAS_N     (DDR_RAS_N),
        .DDR_RESET_N_0 (DDR_RESET_N_0),

        .DDR_SHIELD0   (DDR_SHIELD0),
        .DDR_SHIELD1   (DDR_SHIELD1),

        .DDR_WE_N      (DDR_WE_N),

        .DDR_DQ_0      (DDR_DQ_0),
        .DDR_DQS_0     (DDR_DQS_0),
        .DDR_DQS_N_0   (DDR_DQS_N_0)
    );

    //--------------------------------------------------------
    // DDR4 Memory Model
    //--------------------------------------------------------
    ddr4 DDR4_MEM (
        .reset_n      (DDR_RESET_N_0),

        .clk_p        (DDR_CK0),
        .clk_n        (DDR_CK0_N),

        .cke          (DDR_CKE_0),
        .cs_n         (DDR_CS_N),
        .act_n        (DDR_ACT_N),

        .ten          (1'b0),

        .ras_n        (DDR_RAS_N),
        .cas_n        (DDR_CAS_N),
        .we_n         (DDR_WE_N),

        .dm           (DDR_DM_N),

        .bg           ({1'b0, DDR_BG}),
        .ba           (DDR_BA),

        .sa           (DDR_A),
        .sa17         (1'b0),

        .dq           (DDR_DQ_0),
        .dqs          (DDR_DQS_0),
        .dqs_n        (DDR_DQS_N_0),

        .odt          (DDR_ODT_0),

        .par_in       (1'b0),
        .model_enable (1'b1),

        .mem_alert_n  (DDR4_MEM_ALERT_N)
    );

    //--------------------------------------------------------
    // Stimulus
    //--------------------------------------------------------
    initial begin

        apb_pin = 1'b0;

    #5_000_000;    // 500 s de transactions    
        apb_pin = 1'b1;
    
    #5_000;    // 500 s de transactions
        apb_pin = 1'b0;

       // #10000;

      //  $stop;
    end

endmodule