///////////////////////////////////////////////////////////////////////////////////////////////////
// File: tb_ddr_read_ip.v
/////////////////////////////////////////////////////////////////////////////////////////////////// 

`timescale 1ns/100ps

module tb_ddr_read_ip;

reg reset_i;
reg pixel_clk_i;
reg ddr_clk_i;

reg frame_start_i;
reg read_en_i;

reg [15:0] line_gap_i;
reg [15:0] horz_resl_i;
reg [11:0] h_offset_i;
reg [11:0] v_offset_i;

reg read_ackn_i;
reg read_done_i;
reg ddr_data_valid_i;

reg [7:0] frame_start_addr_i;
reg [63:0] wdata_i;

wire read_req_o;
wire [31:0] read_start_addr_o;
wire [7:0] burst_size_o;

wire data_valid_o;
wire [7:0] data_o;


////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////
DDR_Read_C0 DUT (

.reset_i(reset_i),
.pixel_clk_i(pixel_clk_i),
.ddr_clk_i(ddr_clk_i),

.frame_start_i(frame_start_i),
.read_en_i(read_en_i),

.line_gap_i(line_gap_i),
.horz_resl_i(horz_resl_i),
.h_offset_i(h_offset_i),
.v_offset_i(v_offset_i),

.read_ackn_i(read_ackn_i),
.read_done_i(read_done_i),

.ddr_data_valid_i(ddr_data_valid_i),

.frame_start_addr_i(frame_start_addr_i),
.wdata_i(wdata_i),

.read_req_o(read_req_o),
.read_start_addr_o(read_start_addr_o),
.burst_size_o(burst_size_o),

.data_valid_o(data_valid_o),
.data_o(data_o)

);

////////////////////////////////////////////////////
// Clock generation
////////////////////////////////////////////////////

always #4 ddr_clk_i = ~ddr_clk_i;    // 125 MHz
always #4 pixel_clk_i = ~pixel_clk_i;

////////////////////////////////////////////////////
// Reset
////////////////////////////////////////////////////

initial begin

pixel_clk_i = 0;
ddr_clk_i   = 0;

reset_i = 0;

frame_start_i = 0;
read_en_i = 0;

read_ackn_i = 0;
read_done_i = 0;
ddr_data_valid_i = 0;

#50;
reset_i = 1;

end

////////////////////////////////////////////////////
// Stimulus
////////////////////////////////////////////////////

initial begin

#100;

horz_resl_i = 16'd5;
line_gap_i  = 16'd0;

h_offset_i = 0;
v_offset_i = 0;

frame_start_addr_i = 8'h00;

frame_start_i = 1;
#10;
frame_start_i = 0;

read_en_i = 1;

repeat(3) @(posedge pixel_clk_i);

read_en_i = 0;

end

////////////////////////////////////////////////////
// DDR Arbiter Simulation
////////////////////////////////////////////////////

always @(posedge ddr_clk_i) begin

if(read_req_o) begin

    read_ackn_i <= 1;
    @(posedge ddr_clk_i);
    read_ackn_i <= 0;

   @(posedge ddr_clk_i);
    ddr_data_valid_i <= 1;
    wdata_i <= 64'h84867A8484000000;

    @(posedge ddr_clk_i);
    ddr_data_valid_i <= 0;

    @(posedge ddr_clk_i);
    read_done_i <= 1;

    @(posedge ddr_clk_i);
    read_done_i <= 0;

end

end

////////////////////////////////////////////////////
// Monitor signals
////////////////////////////////////////////////////
initial begin
    $monitor("time=%0t req=%b valid=%b data=%h",
              $time, read_req_o, data_valid_o, data_o);
end
       
always @(posedge pixel_clk_i) begin

if(data_valid_o) begin
    $display("Time=%0t Data=%h", $time, data_o);
end

end

////////////////////////////////////////////////////
// Simulation stop
////////////////////////////////////////////////////

initial begin
#10000;
$stop;
end

endmodule

