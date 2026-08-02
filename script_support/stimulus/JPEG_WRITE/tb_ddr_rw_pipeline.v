`timescale 1ns/1ps

`include "ddr4.sv"

module tb_ddr_rw_pipeline;

    reg apb_pin;
    reg frame_start_i;

    wire [13:0] DDR_A;
    wire        DDR_ACT_N;
    wire [1:0]  DDR_BA;
   // wire [1:0]  DDR_BG;
   wire         DDR_BG;
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

    wire ctrlr_ready;
    wire w1_done;
    

    DDR_RW DUT (
        .apb_pin       (apb_pin),
        .frame_start_i (frame_start_i),
        .A             (DDR_A),
        .ACT_N         (DDR_ACT_N),
        .BA            (DDR_BA),
        .BG            (DDR_BG),
        .CAS_N         (DDR_CAS_N),
        .CK0           (DDR_CK0),
        .CK0_N         (DDR_CK0_N),
        .CKE_0         (DDR_CKE_0),
        .CS_N          (DDR_CS_N),
        .DM_N          (DDR_DM_N),
        .ODT_0         (DDR_ODT_0),
        .RAS_N         (DDR_RAS_N),
        .RESET_N_0     (DDR_RESET_N_0),
        .SHIELD0       (DDR_SHIELD0),
        .SHIELD1       (DDR_SHIELD1),
        .WE_N          (DDR_WE_N),
        .DQS_0         (DDR_DQS_0),
        .DQS_N_0       (DDR_DQS_N_0),
        .DQ_0          (DDR_DQ_0),
        .ctrl_ready_ddr(ctrlr_ready),
        .w1_done        (w1_done)
    );

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

   
    always @(ctrlr_ready)
        begin
            $display("[%0t] CTRLR_READY = %b",
                     $time,
                     ctrlr_ready);
        end

    always @(w1_done)
        begin
            $display("[%0t] W1_DONE = %b",
                     $time,
                     w1_done);
        end
        
    initial begin
        apb_pin            = 1'b0;
        frame_start_i      = 1'b0;

        wait (ctrlr_ready=== 1'b1);
        
        // Phase 1: demarrage ecriture DDR
        frame_start_i = 1'b1;
                #10000;
        frame_start_i = 1'b0;

    

        if (w1_done !== 1'b1) begin
            $display("[%0t] ERROR: timeout en attente de w1_done", $time);
            
        end
        #1000000;

        // Phase 2: demarrage JPEG/APB apres fin ecriture DDR
        apb_pin = 1'b1;
               #10000;

        apb_pin = 1'b0;

        #1000000;
        //$finish;

    end

endmodule
