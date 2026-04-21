/******************************************************************************
-- File Name    : ddr_read_native_tb.v
-- Description  : Testbench pour DDR READ IP Core - Interface Native
--                Target : Microchip PolarFire SoC Video Kit
--
-- Configuration Libero :
--   Input Data Width  (wdata_i)  = 64 bits  (bus Native arbiter)
--   Output Data Width (data_o)   =  8 bits  (1 pixel greyscale/composante)
--   => PIXELS_PER_WORD = 64 / 8 = 8 pixels par mot arbiter
--
-- Protocole Native Arbiter Microchip :
--   1. DDR_READ asserte read_req_o + read_start_addr_o + burst_size_o
--   2. Arbitre repond avec read_ackn_i apres ARBITER_LATENCY cycles DDR
--   3. Arbitre envoie wdata_i (64 bits) + ddr_data_valid_i pour chaque mot
--   4. Arbitre pulse read_done_i apres le dernier mot du burst
--   5. DDR_READ desempaquete et sort data_o (8 bits) + data_valid_o
--
-- Architecture :
--   - DDR_READ DUT
--   - native_arbiter_model  : simule arbitre + RAM 64 bits
--   - tsk_preload_mem       : pre-charge RAM avec pixels 1..255 (wrap)
--   - tsk_drive_frame       : pilote frame_start_i + read_en_i
--   - Timeout de securite
******************************************************************************/
`timescale 1ns/100ps

module tb_read_native;
// =========================================================================
// Parametres globaux
// =========================================================================
parameter HORI_RES           =480/4  ; // 480 pixels par ligne
parameter LINES              = 4       ; // lignes par frame
parameter FRAMES             = 1       ; // nombre de frames a tester
parameter PIXEL_CLK_HALF     = 4       ; // demi-periode pixel clk (125 MHz)
parameter DDR_CLK_HALF       = 3       ; // demi-periode DDR clk   (200 MHz)

// --- Largeurs configurees dans Libero ---
parameter ARBITER_DATA_WIDTH = 64      ; // wdata_i  : bus Native arbiter
parameter OUTPUT_DATA_WIDTH  = 8       ; // data_o   : 1 pixel (8 bits)

// --- Calcules automatiquement ---
localparam PIXELS_PER_WORD   = ARBITER_DATA_WIDTH / OUTPUT_DATA_WIDTH ; // 8
localparam WORDS_PER_LINE    = HORI_RES / PIXELS_PER_WORD             ; // 60
localparam BYTES_PER_WORD    = ARBITER_DATA_WIDTH / 8                 ; // 8

parameter  LINE_GAP          = 16'h1000 ;
parameter  FRAME_START_ADDR  = 8'h00    ;
parameter  ARBITER_LATENCY   = 4        ; // cycles DDR clk avant read_ackn

// =========================================================================
// Signaux DUT
// =========================================================================
reg  pixel_clk_i     ;
reg  ddr_clk_i       ;
reg  reset_i         ;
reg  ddr_clk_rstn_i  ;

reg  frame_start_i   ;
reg  read_en_i       ;

reg  [15:0] horz_resl_i        ;
reg  [15:0] line_gap_i         ;
reg  [11:0] h_offset_i         ;
reg  [11:0] v_offset_i         ;
reg  [ 7:0] frame_start_addr_i ;

// Interface Native Arbiter - inputs
reg                           read_ackn_i      ;
reg                           read_done_i      ;
reg                           ddr_data_valid_i ;
reg  [ARBITER_DATA_WIDTH-1:0] wdata_i          ;

// Interface Native Arbiter - outputs
wire                          read_req_o        ;
wire [31:0]                   read_start_addr_o ;
wire [ 7:0]                   burst_size_o      ;

// Interface Data output
wire                          data_valid_o ;
wire [OUTPUT_DATA_WIDTH-1:0]  data_o       ;

// =========================================================================
// Variables checker
// =========================================================================

integer                      pixel_cnt ;
integer                      frame_cnt ;

// =========================================================================
// Instanciation DUT
// =========================================================================
DDR_Read_C0 DUT (
    .pixel_clk_i         (pixel_clk_i        ),
    .ddr_clk_i           (ddr_clk_i          ),
    .reset_i             (reset_i            ),
    .frame_start_i       (frame_start_i      ),
    .read_en_i           (read_en_i          ),
    .horz_resl_i         (horz_resl_i        ),
    .line_gap_i          (line_gap_i         ),
    .h_offset_i          (h_offset_i         ),
    .v_offset_i          (v_offset_i         ),
    .frame_start_addr_i  (frame_start_addr_i ),
    .read_ackn_i         (read_ackn_i        ),
    .read_done_i         (read_done_i        ),
    .ddr_data_valid_i    (ddr_data_valid_i   ),
    .wdata_i             (wdata_i            ),
    .read_req_o          (read_req_o         ),
    .read_start_addr_o   (read_start_addr_o  ),
    .burst_size_o        (burst_size_o       ),
    .data_valid_o        (data_valid_o       ),
    .data_o              (data_o             )
);

// =========================================================================
// Generateurs d'horloge
// =========================================================================
initial pixel_clk_i = 1'b0;
always  #(PIXEL_CLK_HALF) pixel_clk_i = ~pixel_clk_i;

initial ddr_clk_i   = 1'b0;
always  #(DDR_CLK_HALF)   ddr_clk_i   = ~ddr_clk_i;

// =========================================================================
// RAM simulee : 64 bits par adresse mot
// =========================================================================
reg [ARBITER_DATA_WIDTH-1:0] sim_mem [0:65535];

// =========================================================================
// Task : Pre-charger sim_mem
//
/* Chaque mot 64 bits contient 8 pixels de 8 bits, empaquetes LSB en premier:
--   mot[7:0]  = pixel 0  |  mot[15:8]  = pixel 1  | ... | mot[63:56] = pixel 7
--
-- Calcul adresse (meme logique que DDR WRITE IP) :
--   byte_addr = (frame_start_addr << 24)
--             + (frame * 4 * LINE_GAP)
--             + (line  * LINE_GAP)
--   word_addr = byte_addr / BYTES_PER_WORD
-- =========================================================================*/
task automatic tsk_preload_mem;
    integer frm, ln, wd, px;
    integer pixel_val;
    integer byte_addr;
    integer word_addr;
    reg [ARBITER_DATA_WIDTH-1:0] packed_word;
    begin
        pixel_val = 1;

        for (frm = 0; frm < FRAMES; frm = frm + 1) begin
            for (ln = 0; ln < LINES; ln = ln + 1) begin

                byte_addr = ({24'b0, FRAME_START_ADDR} << 24)
                          + (frm * 4 * LINE_GAP)
                          + (ln  * LINE_GAP);
                word_addr = byte_addr / BYTES_PER_WORD;

                for (wd = 0; wd < WORDS_PER_LINE; wd = wd + 1) begin
                    packed_word = {ARBITER_DATA_WIDTH{1'b0}};

                    for (px = 0; px < PIXELS_PER_WORD; px = px + 1) begin
                        // 8 pixels * 8 bits = 64 bits, LSB-first
                        packed_word[px * OUTPUT_DATA_WIDTH +: OUTPUT_DATA_WIDTH]
                            = pixel_val[OUTPUT_DATA_WIDTH-1:0];

                        pixel_val = pixel_val + 1;
                        // Wrap 255 -> 1 (0 reserve comme valeur neutre)
                        if (pixel_val > 255) pixel_val = 1;
                    end

                    sim_mem[word_addr + wd] = packed_word;
                end
            end
        end

        $display("[MEM] Pre-chargement OK");
        $display("[MEM] %0d mots x 64 bits | %0d pixels x 8 bits par mot",
                  FRAMES * LINES * WORDS_PER_LINE, PIXELS_PER_WORD);
    end
endtask

// =========================================================================
// Modele d'arbitre Native
//
/* Pour chaque transaction :
--   1. Detecte front montant de read_req_o
--   2. Attend ARBITER_LATENCY cycles DDR
--   3. Pulse read_ackn_i 1 cycle
--   4. Envoie burst_size_o mots 64 bits depuis sim_mem avec ddr_data_valid_i
--   5. Pulse read_done_i 1 cycle
-- =========================================================================*/
integer arb_word_addr;
integer arb_burst_cnt;

initial begin
    read_ackn_i      = 1'b0;
    read_done_i      = 1'b0;
    ddr_data_valid_i = 1'b0;
    wdata_i          = {ARBITER_DATA_WIDTH{1'b0}};

    @(posedge reset_i);  // attendre fin de reset
    @(posedge ddr_clk_i);

    forever begin
        // --- Attendre requete ---
        @(posedge read_req_o);

        // --- Latence arbiter ---
        repeat(ARBITER_LATENCY) @(posedge ddr_clk_i);

        // --- Calculer adresse mot ---
        arb_word_addr = read_start_addr_o / BYTES_PER_WORD;
        arb_burst_cnt = burst_size_o;

        // --- Acquittement (1 cycle) ---
        read_ackn_i = 1'b1;
        @(posedge ddr_clk_i);
        read_ackn_i = 1'b0;

        // --- Envoi du burst (64 bits par cycle DDR) ---
        repeat(arb_burst_cnt) begin
            @(posedge ddr_clk_i);
            wdata_i          = sim_mem[arb_word_addr];
            ddr_data_valid_i = 1'b1;
            //  PRINT
            $display("[DDR IN] addr=%0d data=0x%016h", arb_word_addr, wdata_i);
            arb_word_addr    = arb_word_addr + 1;
        end

        @(posedge ddr_clk_i);
        ddr_data_valid_i = 1'b0;
        wdata_i          = {ARBITER_DATA_WIDTH{1'b0}};

        // --- Read done (1 cycle) ---
        @(posedge ddr_clk_i);
        read_done_i = 1'b1;
        @(posedge ddr_clk_i);
        read_done_i = 1'b0;
    end
end

// =========================================================================
// Initialisation + reset
// =========================================================================
initial begin
    reset_i            = 1'b0;
    ddr_clk_rstn_i     = 1'b0;
    frame_start_i      = 1'b0;
    read_en_i          = 1'b0;
    horz_resl_i        = HORI_RES[15:0];
    line_gap_i         = LINE_GAP;
    h_offset_i         = 12'h000;
    v_offset_i         = 12'h000;
    frame_start_addr_i = FRAME_START_ADDR;

    pixel_cnt          = 0;
    frame_cnt          = 0;

    tsk_preload_mem();  // charger la RAM avant de sortir du reset

    #100;
    reset_i        = 1'b1;
    ddr_clk_rstn_i = 1'b1;
    #50;
end

//* ======================================================================
// print the output data 
//========================================================================*/

always @(posedge pixel_clk_i) begin
    if (data_valid_o) begin
        $display("[PIXEL OUT] pixel_cnt=%0d data_o=0x%02h", pixel_cnt, data_o);
        pixel_cnt = pixel_cnt + 1;
    end
end
// =========================================================================
/* Task : Piloter un frame complet
//   - pulse frame_start_i (1 cycle)
--   - pour chaque ligne : read_en_i=1 pendant HORI_RES cycles pixel
--                         puis blanking 280 cycles (identique TB original)
-- =========================================================================*/
task automatic tsk_drive_frame;
    integer l;
    begin
        @(posedge pixel_clk_i);
        frame_start_i = 1'b1;
        @(posedge pixel_clk_i);
        frame_start_i = 1'b0;

        for (l = 0; l < LINES; l = l + 1) begin
            @(posedge pixel_clk_i);
            read_en_i = 1'b1;
            repeat(HORI_RES) @(posedge pixel_clk_i);
            read_en_i = 1'b0;
            repeat(280) @(posedge pixel_clk_i);  // blanking inter-ligne
        end
    end
endtask

// =========================================================================
// Stimulus principal
// =========================================================================
initial begin
    $display("########################################################");
    $display("[TB] DDR READ IP - Interface Native - PolarFire Video Kit");
    $display("[TB] wdata_i (bus arbiter)  : %0d bits", ARBITER_DATA_WIDTH);
    $display("[TB] data_o  (pixel sortie) : %0d bits", OUTPUT_DATA_WIDTH);
    $display("[TB] Pixels par mot 64 bits : %0d",      PIXELS_PER_WORD);
    $display("[TB] Mots par ligne         : %0d",      WORDS_PER_LINE);
    $display("[TB] Resolution horizontale : %0d px",   HORI_RES);
    $display("[TB] Lignes par frame       : %0d",      LINES);
    $display("[TB] Nombre de frames       : %0d",      FRAMES);
    $display("[TB] Line gap               : 0x%04h",   LINE_GAP);
    $display("[TB] Latence arbiter        : %0d cycles DDR", ARBITER_LATENCY);
    $display("########################################################");

    wait (reset_i === 1'b1);
    repeat(10) @(posedge pixel_clk_i);

    repeat(FRAMES) begin
        tsk_drive_frame();
        frame_cnt = frame_cnt + 1;
        $display("[TB] Frame %0d terminee", frame_cnt);
    end

    // Attendre vidage pipeline CDC + FIFO interne
    repeat(HORI_RES * 4) @(posedge pixel_clk_i);
end
// =========================================================================
// Timeout de securite
// =========================================================================
initial begin
    #(PIXEL_CLK_HALF * 2 * (HORI_RES + 280) * LINES * FRAMES * 20);
    $display("########################################################");
    $display("[TB] TIMEOUT ! Simulation bloquee.");
    $display("[TB] Points de debug :");
    $display("[TB]   - read_req_o       : signal DUT -> arbiter");
    $display("[TB]   - read_ackn_i      : signal arbiter -> DUT");
    $display("[TB]   - ddr_data_valid_i : donnees arbiter -> DUT");
    $display("[TB]   - data_valid_o     : sortie DUT -> video pipe");
    $display("########################################################");
    $stop;
end

endmodule 