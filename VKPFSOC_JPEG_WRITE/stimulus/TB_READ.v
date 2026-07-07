///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////// 

`timescale 1ns/1ps
`include "ddr4.sv"

module ddr_read_tb;


    wire [13:0] A;
    wire ACT_N;
    wire [1:0] BA;
    wire BG;
    wire CAS_N;
    wire RAS_N;
    wire WE_N;
    wire CKE_0;
    wire CS_N;
    wire CK0;
    wire CK0_N;
    wire ODT_0;
    wire RESET_N_0;
    wire SHIELD0;
    wire SHIELD1;
    wire [1:0] DM_N;
    wire [15:0] DQ_0;
    wire [1:0] DQS_0;
    wire [1:0] DQS_N_0;
    reg apb_pin;
    wire CTRLR_READY;
    wire MEM_ALERT_N;

    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------
    ddr_read_smart_design DUT (
        .apb_pin(apb_pin),

        .A(A),
        .ACT_N(ACT_N),
        .BA(BA),
        .BG(BG),

        .CAS_N(CAS_N),
        .CK0(CK0),
        .CK0_N(CK0_N),

        .CKE_0(CKE_0),
        .CS_N(CS_N),
        .CTRLR_READY(CTRLR_READY),
        .DM_N(DM_N),

        .ODT_0(ODT_0),

        .RAS_N(RAS_N),
        .RESET_N_0(RESET_N_0),

        .SHIELD0(SHIELD0),
        .SHIELD1(SHIELD1),

        .WE_N(WE_N),
        .DQS_0(DQS_0),
        .DQS_N_0(DQS_N_0),
        .DQ_0(DQ_0)
    );
    
    //--------------------------------------------------------
    // DDR4 Memory Model
    //--------------------------------------------------------
    ddr4 DDR4_MEM (
        .reset_n      (RESET_N_0),

        .clk_p        (CK0),
        .clk_n        (CK0_N),

        .cke          (CKE_0),
        .cs_n         (CS_N),
        .act_n        (ACT_N),

        .ten          (1'b0),

        .ras_n        (RAS_N),
        .cas_n        (CAS_N),
        .we_n         (WE_N),

        .dm           (DM_N),
        .bg           ({1'b0, BG}),
        .ba           (BA),

        .sa           (A),
        .sa17         (1'b0),

        .dq           (DQ_0),
        .dqs          (DQS_0),
        .dqs_n        (DQS_N_0),

        .odt          (ODT_0),

        .par_in       (1'b0),
        .model_enable (1'b1),

        .mem_alert_n  (MEM_ALERT_N)
    );

    //--------------------------------------------------------
    // Stimulus
    //--------------------------------------------------------
    always @(CTRLR_READY)
        begin
            $display("[%0t] CTRLR_READY = %b",
                     $time,
                     CTRLR_READY);
        end
        
    initial begin

        apb_pin = 1'b0;

        wait(CTRLR_READY === 1'b1);
        //#7_000_000;
        apb_pin = 1'b1;

        #500000;
        apb_pin = 1'b0;
      //  $stop;
    end
endmodule

