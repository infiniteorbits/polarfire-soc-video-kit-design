`timescale 1ns/1ps
// =========================================================================
// tb_top_system.v    TB image 5x3 avec cblage corrig
//
// Nouveaut : criture du registre APB 0x14 = adresse DDR base de l'image
// horz_resl est maintenant calcul depuis i_w : horz_resl = i_w + 1
// =========================================================================
module tb_top_system;

  parameter SYSCLK_PERIOD = 10;   // 100 MHz

  // Image 5x3 pixels, 8 bits/pixel
  // i_w=511  horz_resl = i_w+1 = 512 (calcul dans apb_wrapper)
  // i_h=511  H rel = i_h+1 = 512
  parameter IMG_W_REG      = 14'd1023;          // crire dans 0x04
  parameter IMG_H_REG      = 14'd1023;          // crire dans 0x08
  parameter NEAR_VAL       = 8'd0;           // lossless
  parameter DDR_BASE_ADDR  = 32'h8400_0000;  // image  l'adresse 0 en DDR
                                              // crire dans 0x14
    localparam TOTAL_BEATS = 2;  // mem_src[0] + mem_src[1]
  //====================================================
  // CLOCK / RESET
  //====================================================
  reg SYSCLK, NSYSRESET;
  initial begin SYSCLK=0; NSYSRESET=0; #(SYSCLK_PERIOD*20); NSYSRESET=1; end
  always #(SYSCLK_PERIOD/2) SYSCLK = ~SYSCLK;

  //====================================================
  // SIGNAUX
  //====================================================
  reg        psel, pwrite;
  reg [31:0] paddr, pwdata;
  wire[31:0] prdata;
  wire       pready;
  reg        apb_pin, ddr_ctrl_ready_i;
  reg [31:0] araddr, awaddr;
  reg        arvalid, awvalid;
 reg [3:0]  arid, awid;
reg [7:0]  arlen, awlen;
  wire arready, awready, wready, rvalid, rlast, bvalid;
  wire [63:0] rdata;
  wire [3:0]  rid, bid;
  wire [1:0]  rresp, bresp;
  wire [63:0] wdata;
  wire        wvalid, wlast, bready, frm_interrupt_o;
    reg rready;
integer read_count;
initial read_count = 0;
initial rready = 1;
  integer burst_count;
    initial burst_count = 0;
    
  //====================================================
  // AXI4 read ready
  //====================================================
    
    always @(posedge SYSCLK) begin
        rready <= 1; // FIX IMPORTANT
    end
  //====================================================
  // DUT
  //====================================================
  top_ddr_write_read dut (
    .pclk(SYSCLK), .presetn(NSYSRESET),
    .sys_clk_i(SYSCLK), .reset_i(NSYSRESET),
    .APBslave_psel(psel), .APBslave_pwrite(pwrite),
    .APBslave_paddr(paddr), .APBslave_pwdata(pwdata),
    .APBslave_prdata(prdata), .APBslave_pready(pready),
    .apb_pin(apb_pin),
    .ddr_ctrl_ready_i(ddr_ctrl_ready_i),
    .MIRRORED_SLAVE_AXI4_arready_0(arready),
    .MIRRORED_SLAVE_AXI4_rvalid_0(rvalid),
    .MIRRORED_SLAVE_AXI4_rdata_0(rdata),
    .MIRRORED_SLAVE_AXI4_rlast_0(rlast),
    .MIRRORED_SLAVE_AXI4_rid_0(rid),
    .MIRRORED_SLAVE_AXI4_rresp_0(rresp),
    .MIRRORED_SLAVE_AXI4_awready_0(awready),
    .MIRRORED_SLAVE_AXI4_wready_0(wready),
    .MIRRORED_SLAVE_AXI4_bvalid_0(bvalid),
    .MIRRORED_SLAVE_AXI4_bid_0(bid),
    .MIRRORED_SLAVE_AXI4_bresp_0(bresp),
    .MIRRORED_SLAVE_AXI4_araddr_0(araddr),
    .MIRRORED_SLAVE_AXI4_arvalid_0(arvalid),
    .MIRRORED_SLAVE_AXI4_arid_0(arid),
    .MIRRORED_SLAVE_AXI4_arlen_0(arlen),
    .MIRRORED_SLAVE_AXI4_awaddr_0(awaddr),
    .MIRRORED_SLAVE_AXI4_awvalid_0(awvalid),
    .MIRRORED_SLAVE_AXI4_awid_0(awid),
    .MIRRORED_SLAVE_AXI4_awlen_0(awlen),
    .MIRRORED_SLAVE_AXI4_wdata_0(wdata),
    .MIRRORED_SLAVE_AXI4_wvalid_0(wvalid),
    .MIRRORED_SLAVE_AXI4_wlast_0(wlast),
    .MIRRORED_SLAVE_AXI4_bready_0(bready),
    .MIRRORED_SLAVE_AXI4_rready_0(rready),
    .frm_interrupt_o(frm_interrupt_o)
  );

  //====================================================
  // AXI4 RAM  image 2x2  l'adresse 0
  //====================================================
  axi4_ram #(.AXI_ADDR_WIDTH(32), .AXI_DATA_WIDTH(64), .MEM_DEPTH(512))
  axi_mem (
    .sys_clk_i(SYSCLK), .resetn_i(NSYSRESET),
    .awready(awready), .wready(wready),
    .bid(bid), .bresp(bresp), .bvalid(bvalid),
    .arready(arready),
    .rid(rid), .rdata(rdata), .rresp(rresp), .rlast(rlast), .rvalid(rvalid),
    .awid(awid), .awaddr(awaddr), .awlen(awlen), .awvalid(awvalid),
    .wdata(wdata), .wlast(wlast), .wvalid(wvalid), .bready(bready),
    .arid(arid), .araddr(araddr), .arlen(arlen), .arvalid(arvalid),
    .rready(rready)
  );

  //====================================================
  // APB TASKS
  //====================================================
  task apb_write;
    input [31:0] addr, data;
  begin
    @(posedge SYSCLK); #1;
    psel=1; pwrite=1; paddr=addr; pwdata=data;
    @(posedge SYSCLK); #1;
    while(!pready) @(posedge SYSCLK);
    @(posedge SYSCLK); #1;
    psel=0; pwrite=0;
    $display("[APB WR] 0x%02h = 0x%08h  t=%0t ns", addr, data, $time);
  end
  endtask

  task apb_read;
    input  [31:0] addr;
    output [31:0] rd;
  begin
    @(posedge SYSCLK); #1;
    psel=1; pwrite=0; paddr=addr;
    @(posedge SYSCLK); #1;
    while(!pready) @(posedge SYSCLK);
    rd=prdata;
    @(posedge SYSCLK); #1;
    psel=0;
    $display("[APB RD] 0x%02h = 0x%08h  t=%0t ns", addr, rd, $time);
  end
  endtask

  //====================================================
  // COMPTEURS + MONITEUR
  //====================================================
  integer axi_read_beats, axi_write_beats;
  reg axi_error;
  reg [31:0] status_reg;

  initial begin axi_read_beats=0; axi_write_beats=0; axi_error=0; end

  always @(posedge SYSCLK) begin
    if(arvalid && arready)
      $display("[AXI AR] addr=0x%08h  len=%0d  t=%0t ns", araddr, arlen, $time);
    if(rvalid && rready) begin
      $display("[AXI R ] data=0x%016h  last=%b", rdata, rlast);
      axi_read_beats = axi_read_beats + 1;
    end
    if(awvalid && awready)
      $display("[AXI AW] addr=0x%08h  len=%0d  t=%0t ns", awaddr, awlen, $time);
    if(wvalid && wready) begin
      $display("[AXI W ] data=0x%016h  last=%b", wdata, wlast);
      axi_write_beats = axi_write_beats + 1;
    end
    if(frm_interrupt_o)
      $display("[INT] frm_interrupt_o  t=%0t ns", $time);
    if(bvalid && bready && bresp!=0) begin
      $display("[ERR W] bresp=%b", bresp); axi_error=1;
    end
    if(rvalid && rready && rresp!=0) begin
      $display("[ERR R] rresp=%b", rresp); axi_error=1;
    end 
  end

   //====================================================
  // DEBUG BRUST
  //====================================================
    always @(posedge SYSCLK) begin
        if(rvalid && rready && rlast)
            $display("---- FIN BURST ----");
    end
  //====================================================
  // SQUENCE PRINCIPALE
  //====================================================
  initial begin
    psel=0; pwrite=0; paddr=0; pwdata=0;
    apb_pin=0; 
    ddr_ctrl_ready_i=0;

    wait(NSYSRESET);
    repeat(20) @(posedge SYSCLK);

    // DDR prt (simule FDDR_CORE_CALIB_DONE)
    ddr_ctrl_ready_i = 1'b1;
    $display("[DDR] ddr_ctrl_ready_i=1  t=%0t ns", $time);
    repeat(5) @(posedge SYSCLK);

    // --------------------------------------------------
    // CONFIG APB
    // 0x04 = i_w         horz_resl = i_w+1 (calcul dans apb_wrapper)
    // 0x08 = i_h
    // 0x0C = near
    // 0x14 = adresse DDR base de l'image source   NOUVEAU
    // --------------------------------------------------
    $display("");
    $display("=== CONFIG APB ===");
    apb_write(32'h04, {18'h0, IMG_W_REG});    // i_w=119 horz_resl=120
    apb_write(32'h08, {18'h0, IMG_H_REG});    // i_h=19  H=20
    apb_write(32'h0C, {24'h0, NEAR_VAL});     // near=0
    apb_write(32'h14, DDR_BASE_ADDR);         // adresse DDR source = 0x0
    repeat(5) @(posedge SYSCLK);

    // Vrification lecture registre 0x14
    apb_read(32'h14, status_reg);
    $display("[CHECK] ddr_base_addr lu = 0x%08h (attendu 0x%08h)",
             status_reg, DDR_BASE_ADDR);

    // --------------------------------------------------
    // SOF via apb_pin
    // apb_wrapper : reg_sof <= sw1_sync[1]  chaque cycle
    // apb_pin=1 pendant 380 cycles (2 sync + 367 SOF_PULSE + marge)
    // --------------------------------------------------
    $display("");
    $display("=== SOF (apb_pin=1 ) ===");
    apb_pin = 1'b1;
      repeat(5)@(posedge SYSCLK);
    apb_pin = 1'b0;
    $display("[SOF] FSM doit tre en FEED_PIXELS  t=%0t ns", $time);
    repeat(365) @(posedge SYSCLK);
    
    $display("");
    $display("=== LECTURE DDR 5x3 PIXELS ===");
     // ====================================================
    // LECTURE DDR (pilote par le DUT)
    // ====================================================

    $display("");
    $display("=== START FRAME ===");

    // frame_start_i est maintenant genere automatiquement par jpeg_control_fsm.

    // Attendre activit AXI
    //wait(arvalid);

   $display("=== MONITOR AXI (multi-burst) ===");
/*
    fork
        begin : monitor_reads
            forever begin
                @(posedge SYSCLK);

                if(arvalid && arready) begin
                    burst_count = burst_count + 1;
                    $display(">>> BURST #%0d addr=0x%08h len=%0d t=%0t",
                              burst_count, araddr, arlen, $time);
                end

                if(rvalid && rready) begin
                    $display("[AXI R] data=0x%016h last=%b",
                              rdata, rlast);
                end
                if(arvalid && arready)
                    $display("ARADDR = %h", araddr);
            end
        end

        begin : timeout_block
            repeat(2000) @(posedge SYSCLK);
            $display("=== TIMEOUT MONITOR ===");
        end
    join_any
    disable fork;*/
    $display("[WAIT] Attente fin compression JPEG...");

    wait(frm_interrupt_o);

    $display("[DONE] Compression JPEG terminee t=%0t ns", $time);

    repeat(20) @(posedge SYSCLK);
    // --------------------------------------------------
    // ATTENTE FIN : frm_interrupt_o ou poll APB 0x10
    // --------------------------------------------------
   /* begin : wait_done
      integer timeout;
      timeout=0; status_reg=0;
      $display("[WAIT] Attente frm_interrupt_o...");
      while(!frm_interrupt_o && status_reg[0]==0 && timeout<500) begin
        repeat(20) @(posedge SYSCLK);
        apb_read(32'h10, status_reg);
        timeout = timeout+1;
      end
      if(frm_interrupt_o || status_reg[0])
        $display("[DONE] Compression termine  t=%0t ns", $time);
      else
        $display("[TIMEOUT] Jamais termin aprs %0d polls", timeout);
    end
*/
    repeat(50) @(posedge SYSCLK);

    // --------------------------------------------------
    // RAPPORT
    // --------------------------------------------------
    $display("");
    $display("========================================================");
    $display("  RAPPORT FINAL  Image 1024x1024 JPEG-LS");
    $display("  Config : i_w=%0d  horz_resl=%0d px",
             IMG_W_REG, IMG_W_REG+1);
    $display("           i_h=%0d  H=%0d px",
             IMG_H_REG, IMG_H_REG+1);
    $display("           ddr_base_addr = 0x%08h", DDR_BASE_ADDR);
    $display("  Beats AXI read  (DDRJPEG) : %0d", axi_read_beats);
    $display("  Beats AXI write (JPEGDDR) : %0d", axi_write_beats);
    $display("  Octets JPEG       : %0d", axi_write_beats*8);
    $display("  Errors AXI                : %0s",
             axi_error ? "yes !" : "none");
    if(axi_error)
      $display("  *** CHEC  error AXI ***");
    else if(axi_write_beats > 0)
      $display("  *** SUCCS JPEG pipline ***");
    else if(axi_read_beats > 0)
      $display("  *** PARTIEL  lecture OK mais criture=0 ***");
    else
      $display("  *** BLOQU  DDR_Read ne dmarre pas ***");
    $display("========================================================");

    $stop;
  end

endmodule

//=============================================================================
// AXI4 RAM  source + destination spares pour TB
//=============================================================================
module axi4_ram #(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ID_WIDTH   = 4,
    parameter MEM_DEPTH      = 2000000//256
)(
    input                           sys_clk_i,
    input                           resetn_i,
    // AXI write
    input  [AXI_ADDR_WIDTH-1:0]     awaddr,
    input  [AXI_ID_WIDTH-1:0]       awid,
    input  [7:0]                    awlen,
    input                           awvalid,
    output                          awready,
    input  [AXI_DATA_WIDTH-1:0]     wdata,
    input                           wvalid,
    input                           wlast,
    output                          wready,
    input                           bready,
    output reg [AXI_ID_WIDTH-1:0]   bid,
    output reg [1:0]                bresp,
    output reg                      bvalid,
    // AXI read
    input  [AXI_ADDR_WIDTH-1:0]     araddr,
    input  [AXI_ID_WIDTH-1:0]       arid,
    input  [7:0]                    arlen,
    input                           arvalid,
    output                          arready,
    input                           rready,
    output reg [AXI_ID_WIDTH-1:0]   rid,
    output reg [AXI_DATA_WIDTH-1:0] rdata,
    output reg                      rvalid,
    output reg                      rlast,
    output [1:0]                    rresp
);

reg[AXI_DATA_WIDTH-1:0] mem_src [0:MEM_DEPTH-1];
reg [AXI_DATA_WIDTH-1:0] mem_dst [0:MEM_DEPTH-1];
 //  reg[7:0] mem_src [0:MEM_DEPTH-1];
//  reg [7:0] mem_dst [0:MEM_DEPTH-1];
    assign awready = 1;
    assign wready  = 1;
    assign arready = 1;
    assign rresp   = 2'b00;  // OK

    // =================================================
    // INIT MEMOIRE SOURCE
    // =================================================
    /*initial begin
        integer k;
        for(k=0; k<256; k=k+1) begin
            mem_src[k] = 0;
            mem_dst[k] = 0;
        end

        // 15 pixels  2 beats (64 bits = 8 pixels)
        mem_src[0] = {8'h7c,8'h78,8'h79,8'h7a,8'h80,8'h77,8'h79,8'h86}; 
        mem_src[1] = {8'h79,8'h7a,8'h75,8'h76,8'h76,8'h7a,8'h85,8'h00};
        $display("[INIT] IMAGE 5x3 chargee");
    end*/
    initial begin
        integer k;

        // reset RAM
        for(k=0; k<2000000; k=k+1) begin
            mem_src[k] = 0;
            mem_dst[k] = 0;
        end

        for(k=0; k<2000000; k=k+1) begin
            mem_src[k] = {
               8'(k*8+0),
                8'(k*8+1),
                8'(k*8+2),
                8'(k*8+3),
                8'(k*8+4),
                8'(k*8+5),
                8'(k*8+6),
                8'(k*8+7)
            }; 
            
        end

        $display("IMAGE 1024x1024 CHARGEE");

    end

    // =================================================
    // WRITE AXI
    // =================================================
    reg [AXI_ADDR_WIDTH-1:0] waddr;
    always @(posedge sys_clk_i or negedge resetn_i) begin
        if(!resetn_i)
            waddr <= 0;
        else if(awvalid)
            waddr <= awaddr >> 3;
        else if(wvalid)
            waddr <= waddr + 1;
    end

    always @(posedge sys_clk_i) begin
        if(wvalid)
            mem_dst[waddr % MEM_DEPTH] <= wdata;
    end

    // bvalid generation
    initial begin
        bvalid=0; bid=0; bresp=0;
        forever @(posedge sys_clk_i) begin
            if(wlast) begin
                bvalid <= 1;
                bid    <= awid;
                bresp  <= 2'b00;
                @(posedge sys_clk_i);
                wait(bready);
                bvalid <= 0;
            end
        end
    end

    // =================================================
    // READ AXI MULTI-BEAT CORRECT
    // =================================================
    reg [AXI_ADDR_WIDTH-1:0] raddr_w;
    reg [7:0] rcnt, rlen_reg;
    reg rbusy;
    always @(posedge sys_clk_i or negedge resetn_i) begin
    if(!resetn_i) begin
        rvalid   <= 0;
        rlast    <= 0;
        rid      <= 0;
        rdata    <= 0;
        raddr_w  <= 0;
        rcnt     <= 0;
        rlen_reg <= 0;
        rbusy    <= 0;
    end else begin

        // START BURST
        if(!rbusy && arvalid && arready) begin
            rbusy    <= 1;
            raddr_w  <= araddr >> 3;
            // IMPORTANT :
            // AXI arlen = burst_length - 1
            rlen_reg <= arlen + 1;

            //rlen_reg <= 0; 
            rcnt     <= 0;
            rid      <= arid;
            rvalid   <= 1;
            //rdata    <= mem_dst[araddr >> 3]; 
            rdata    <= mem_src[(araddr >> 3) % MEM_DEPTH];
            //rdata = mem_src[araddr];
            rlast    <= (arlen == 0);
            $display("[AXI READ START] beats=%0d", arlen + 1);
        end

        // BURST EN COURS
        else if(rbusy) begin
            if(rvalid && rready) begin

                if(rlast) begin
                    // FIN BURST
                    rvalid <= 0;
                    rlast  <= 0;
                    rbusy  <= 0;
                    
                    $display("[AXI READ DONE]");
                end else begin
                    rcnt    <= rcnt + 1;
                    raddr_w <= raddr_w + 1;
                    
                  rdata   <= mem_src[(raddr_w + 1) % MEM_DEPTH];
                   // rdata <= mem_dst[raddr_w + rcnt];
                    // IMPORTANT
                    rlast   <= (rcnt + 1 == rlen_reg - 1);
                     $display("[AXI READ] beat=%0d data=%h",
                             rcnt + 1,
                             mem_src[(raddr_w + 1) % MEM_DEPTH]);
                end
            end
        end
    end
end
    
endmodule
