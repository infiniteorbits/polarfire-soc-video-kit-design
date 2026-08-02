`timescale 1ns/100ps

module top_ddr_write_read_tb;

//============================================================
// PARAMTRES
//============================================================
parameter SYSCLK_PERIOD = 10;
parameter DDR_CLK_HALF  = 3;
parameter PIXEL_CLK_HALF= 4;

parameter HORI_RES = 8;   // DEBUG SIMPLE
parameter LINES    = 1;

parameter ARBITER_DATA_WIDTH = 64;
parameter OUTPUT_DATA_WIDTH  = 8;

localparam PIXELS_PER_WORD = 8;
localparam BYTES_PER_WORD  = 8;

//============================================================
// CLOCKS & RESET
//============================================================
reg sys_clk;
reg ddr_clk;
reg pixel_clk;
reg reset_n;

initial begin
    sys_clk   = 0;
    ddr_clk   = 0;
    pixel_clk = 0;
    reset_n   = 0;

    #100;
    reset_n = 1;
end

always #(SYSCLK_PERIOD/2) sys_clk   = ~sys_clk;
always #(DDR_CLK_HALF)    ddr_clk   = ~ddr_clk;
always #(PIXEL_CLK_HALF)  pixel_clk = ~pixel_clk;

//============================================================
// DDR READ SIGNALS
//============================================================
reg arready= 1'b0;
reg rvalid  = 1'b0;
reg rlast = 1'b0;
reg [63:0] rdata;

integer addr;
wire data_valid_o;
wire [7:0] data_o;
reg read_en_i= 1'b0;
reg frame_start_i_read_ddr = 1'b0;

// DEBUG READ_EN
always @(posedge sys_clk) begin
    if (read_en_i)
        $display("[READ EN] actif  t=%0t", $time);
end
//============================================================
// DDR WRITE MOCK
//============================================================
reg [63:0] ddr_mem [0:1023];
integer write_count;

wire awready = 1'b1;
wire wready  = 1'b1;
reg  bvalid= 1'b0;

//============================================================
// APB
//============================================================
reg psel, pwrite;
reg [31:0] paddr, pwdata;
wire [31:0] prdata;
wire pready;

//============================================================
// DUT (TON TOP FINAL)
//============================================================
top_ddr_write_read dut (

    .sys_clk_i(sys_clk),
    .reset_i(reset_n),
    .ddr_ctrl_ready_i({1{1'b1}}),
    // ===== READ SIDE =====
    .frame_start_i_read_ddr(frame_start_i_read_ddr),
    .read_en_i(read_en_i),
    .MIRRORED_SLAVE_AXI4_arready_0(arready),
    .MIRRORED_SLAVE_AXI4_rvalid_0(rvalid),
    .MIRRORED_SLAVE_AXI4_rdata_0(rdata),
    .MIRRORED_SLAVE_AXI4_rlast_0(rlast),

    // ===== WRITE SIDE =====
    .MIRRORED_SLAVE_AXI4_awready_0(awready),
    .MIRRORED_SLAVE_AXI4_wready_0(wready),
    .MIRRORED_SLAVE_AXI4_bvalid_0(bvalid),
    
    // ===== APB =====
    .APBslave_psel(psel),
    .APBslave_pwrite(pwrite),
    .APBslave_paddr(paddr),
    .APBslave_pwdata(pwdata),
    .APBslave_prdata(prdata),
    .APBslave_pready(pready)
);

//============================================================
// DDR MEMORY (READ SIDE)
//============================================================
reg [63:0] sim_mem [0:1023];

task preload_mem;
    integer i;
    begin
        for (i=0; i<1024; i=i+1)
            sim_mem[i] = {8{i[7:0]}};
        $display("[INIT] DDR READ MEM READY");
    end
endtask

/////////////////////////////////////////////////
//AXI4 READ
/////////////////////////////////////////////////


/*always @(posedge sys_clk) begin
    if (!reset_n) begin
        arready <= 0;
        rvalid  <= 0;
        rlast   <= 0;
        addr    <= 0;
    end else begin
    
        // handshake adresse
        //if (dut.MIRRORED_SLAVE_AXI4_arvalid_0 && !arready) begin
        // handshake adresse
        if (dut.MIRRORED_SLAVE_AXI4_arvalid_0) begin
            arready <= 1;  // on reste prt jusqu' ce que DUT capture arvalid
            addr <= dut.MIRRORED_SLAVE_AXI4_araddr_0 >> 3;
        end

        // envoyer data si arready est actif
        if (arready) begin
            rvalid <= 1;
            rdata  <= sim_mem[addr];
            rlast  <= 1;

            $display("[AXI READ] addr=%0d data=%h", addr, sim_mem[addr]);

            // incrment d'adresse si DUT capture rready
            if (dut.MIRRORED_SLAVE_AXI4_rready_0) begin
                addr <= addr + 1;
                rvalid <= 0;
                rlast  <= 0;
                arready <= 0;
            end
        end
    end
end*/
always @(posedge sys_clk) begin
    if (!reset_n) begin
        arready <= 0;
        rvalid  <= 0;
        rlast   <= 0;
        addr <=0;
    end else begin

        // handshake adresse
        if (dut.MIRRORED_SLAVE_AXI4_arvalid_0) begin
            arready <= 1;
            addr = dut.MIRRORED_SLAVE_AXI4_araddr_0 >> 3;
        end else begin
            arready <= 0;
        end

        // envoi data
        if (arready) begin
            rvalid <= 1;
            rdata  <= sim_mem[addr];
            rlast  <= 1;

            $display("[AXI READ] addr=%0d data=%h", addr, rdata);

            addr = addr + 1;
        end
        else if (dut.MIRRORED_SLAVE_AXI4_rready_0) begin
            rvalid <= 0;
            rlast  <= 0;
        end
    end
end

//============================================================
// DDR WRITE MOCK
//============================================================
always @(posedge sys_clk) begin
    if (!reset_n) begin
        write_count <= 0;
        bvalid <= 0;
    end else begin
        if (dut.MIRRORED_SLAVE_AXI4_wvalid_0) begin
            ddr_mem[write_count] <= dut.MIRRORED_SLAVE_AXI4_wdata_0;
            write_count = write_count + 1;
            bvalid <= 1;
            $display("[DDR WRITE] data=%h count=%0d",
                dut.MIRRORED_SLAVE_AXI4_wdata_0, write_count);

            bvalid <= 1;
        end else if (bvalid && dut.MIRRORED_SLAVE_AXI4_bready_0) begin
            bvalid <= 0;
        end
    end
end

//============================================================
// APB TASK
//============================================================
task apb_write(input [31:0] addr, input [31:0] data);
begin
    @(posedge sys_clk);
    psel   <= 1;
    pwrite <= 1;
    paddr  <= addr;
    pwdata <= data;

    @(posedge sys_clk);
    psel   <= 0;
    pwrite <= 0;

    $display("[APB] WRITE addr=%h data=%h", addr, data);
end
endtask

//============================================================
// TEST SEQUENCE
//============================================================
initial begin

    integer l;

    psel = 0; 
    pwrite = 0;
    read_en_i = 0;

    preload_mem();

    wait(reset_n);

    // CONFIG JPEG
    apb_write(32'h04, 8);
    apb_write(32'h08, 1);

    // START
    apb_write(32'h00, 1);

    repeat(10) @(posedge sys_clk);
    frame_start_i_read_ddr =1'b1;
    
    frame_start_i_read_ddr =1'b0;
    // DRIVE READ
    for (l = 0; l < LINES; l = l + 1) begin
        @(posedge sys_clk);
        read_en_i = 1;

        repeat(HORI_RES) @(posedge sys_clk);

        read_en_i = 0;
        frame_start_i_read_ddr =1'b0;
        
        repeat(20) @(posedge sys_clk);
    end

    // RUN
    #5000;

    $display("========= RESULT =========");
    $display("TOTAL WRITES = %0d", write_count);

    $finish;
end

endmodule