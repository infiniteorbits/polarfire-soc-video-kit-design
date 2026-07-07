/*************************************************************************************************************************************
--
-- File Name    : ddr_read_write_tb.v 
-- Description  : ddr_read_write_tb is provided to test DDR READ and DDR WRITE IP 

-- COPYRIGHT 2024 BY MICROCHIP
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
-- FROM MICROCHIP CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
-- MICROCHIP FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
-- NO BACK-UP OF THE FILE SHOULD BE MADE. 
--
--*************************************************************************************************************************************/
`timescale 1ns/1ns
module ddr_read_write_tb;

    parameter   AXI_ID_WIDTH      =4;
    parameter   AXI_ADDR_WIDTH    =32;
    parameter   AXI_DATA_WIDTH    =512;
    parameter   HORI_RES          =1920/4 ; //Horizontal Resolution
    parameter   LINES             =4 ;   
    parameter   PIXEL_CLK         =8 ;  //125 MHZ
    parameter   DDR_CLK           =6 ; //200 MHZ
    parameter   DATA_WIDTH        =32;
    parameter   FRAMES            =2;
    parameter   LINE_GAP          =16'h1000;
    
// ddr_write inputs 
reg pixel_clk_i ;
reg ddr_clk_i;
reg rstn_i ;
reg ddr_clk_rstn_i ;
reg frame_valid_i ; 
reg data_valid_i ;
reg ddr_ctrl_ready_i ;
reg write_done ;
reg error ;

reg [DATA_WIDTH-1:0] counter_data;
reg [7:0]            frame_ddr_addr_i ;
reg [DATA_WIDTH-1:0] data_i ;
reg [DATA_WIDTH-1:0] exp_data;
reg [15:0]           line_gap_i;

assign line_gap_i = LINE_GAP ;
// ddr_read inputs and outputs 
reg reset_i ;
reg frame_end_i ;
reg read_en_i ;

reg [15:0] horz_resl_i ;

wire data_valid_o ;
wire [DATA_WIDTH-1:0] data_o ;

//AXI4 interface from arbiter to memory
wire                       arready;
wire                       awready;
wire  [AXI_ID_WIDTH-1:0]   bid;
wire  [1:0]                bresp;
wire                       bvalid;
wire  [AXI_DATA_WIDTH-1:0] rdata;
wire  [AXI_ID_WIDTH-1:0]   rid;
wire                       rlast;
wire  [1:0]                rresp;
wire                       rvalid;
wire                       wready;
wire [AXI_ADDR_WIDTH-1:0]  araddr;
wire [AXI_ID_WIDTH-1:0]    arid;
wire [7:0]                 arlen;
wire                       arvalid;
wire [AXI_ADDR_WIDTH-1:0]  awaddr;
wire [AXI_ID_WIDTH-1:0]    awid;
wire [7:0]                 awlen;
wire                       awvalid;
wire                       bready;
wire                       rready;
wire [AXI_DATA_WIDTH-1:0]  wdata;
wire                       wlast;
wire                       wvalid;

//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  DDR_read and write
//////////////////////////////////////////////////////////////////////

DDR_READ_WRITE DUT 
 (
    .pixel_clk_i(pixel_clk_i),
    .ddr_clk_i(ddr_clk_i),
    .rstn_i(rstn_i),
    .ddr_clk_rstn_i(ddr_clk_rstn_i),
    .DDR_WRITE_frame_start_i(frame_valid_i),
    .data_valid_i(data_valid_i),
    .ddr_ctrl_ready_i(ddr_ctrl_ready_i),
    .frame_ddr_addr_i(frame_ddr_addr_i),
    .data_i(data_i),
    .DDR_READ_frame_start_i(frame_end_i),  
    .read_en_i(read_en_i),
    .horz_resl_i(horz_resl_i),
    .data_valid_o(data_valid_o),
    .data_o(data_o),
    .line_gap_i(line_gap_i),
    .MIRRORED_SLAVE_AXI4_arready(arready),
    .MIRRORED_SLAVE_AXI4_awready(awready),
    .MIRRORED_SLAVE_AXI4_bid(bid),
    .MIRRORED_SLAVE_AXI4_bresp(bresp),
    .MIRRORED_SLAVE_AXI4_bvalid(bvalid),
    .MIRRORED_SLAVE_AXI4_rdata(rdata),
    .MIRRORED_SLAVE_AXI4_rid(rid),
    .MIRRORED_SLAVE_AXI4_rlast(rlast),
    .MIRRORED_SLAVE_AXI4_rresp(rresp),
    .MIRRORED_SLAVE_AXI4_rvalid(rvalid),
    .MIRRORED_SLAVE_AXI4_wready(wready),
    .MIRRORED_SLAVE_AXI4_araddr(araddr),
    .MIRRORED_SLAVE_AXI4_arburst(),
    .MIRRORED_SLAVE_AXI4_arcache(),
    .MIRRORED_SLAVE_AXI4_arid(arid),
    .MIRRORED_SLAVE_AXI4_arlen(arlen),
    .MIRRORED_SLAVE_AXI4_arlock(),
    .MIRRORED_SLAVE_AXI4_arprot(),
    .MIRRORED_SLAVE_AXI4_arsize(),
    .MIRRORED_SLAVE_AXI4_arvalid(arvalid),
    .MIRRORED_SLAVE_AXI4_awaddr(awaddr),
    .MIRRORED_SLAVE_AXI4_awburst(),
    .MIRRORED_SLAVE_AXI4_awcache(),
    .MIRRORED_SLAVE_AXI4_awid(awid),
    .MIRRORED_SLAVE_AXI4_awlen(awlen),
    .MIRRORED_SLAVE_AXI4_awlock(),
    .MIRRORED_SLAVE_AXI4_awprot(),
    .MIRRORED_SLAVE_AXI4_awsize(),
    .MIRRORED_SLAVE_AXI4_awvalid(awvalid),
    .MIRRORED_SLAVE_AXI4_bready(bready),
    .MIRRORED_SLAVE_AXI4_rready(rready),
    .MIRRORED_SLAVE_AXI4_wdata(wdata),
    .MIRRORED_SLAVE_AXI4_wlast(wlast),
    .MIRRORED_SLAVE_AXI4_wstrb(),
    .MIRRORED_SLAVE_AXI4_wvalid(wvalid)
    );
 

//////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////
initial 
begin
    rstn_i  		= 1'b0 ;
    reset_i 		= 1'b0 ;
    pixel_clk_i	    = 1'b0 ;
    ddr_clk_i  	    = 1'b0 ;
    ddr_clk_rstn_i  = 1'b0 ;
    frame_valid_i   = 1'b0 ;
    frame_end_i     = 1'b0 ;
    horz_resl_i	    = HORI_RES ;
    write_done      = 1'b0 ;
    error           = 1'b0 ;
    exp_data        = 1'b0 ;
    counter_data    = 1 ;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
    #100            
    rstn_i  			= 1'b1;
    ddr_clk_rstn_i	    = 1'b1;
    ddr_ctrl_ready_i    = 1'b1;
     
end   


//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(pixel_clk_i) 
begin
    #(PIXEL_CLK/2) pixel_clk_i  <= ~ pixel_clk_i ;
end

always @(ddr_clk_i )
begin
    #(DDR_CLK/2) ddr_clk_i      <= ~ ddr_clk_i ;
end

  
//////////////////////////////////////////////////////////////////////
// write config
///////////////////////////////////////////////////////////////////////
initial
begin
    frame_ddr_addr_i                    = 0 ;
    frame_valid_i                       = 0 ;
    data_valid_i                        = 0 ;
    data_i                              = 0 ;
    ddr_ctrl_ready_i                    = 0 ;
    wait (rstn_i)
    repeat(FRAMES)
    tsk_write();
end

task automatic tsk_write ;
begin
    repeat (LINES)
    begin
        for (int i = 0 ; i < (HORI_RES+280) ; i = i + 1 ) 
        begin 
        @(posedge pixel_clk_i) ;
            if (i < HORI_RES)
            begin
                data_i                  = counter_data ;
                data_valid_i            = 1'b1   ;
                counter_data            = counter_data + 1 ; 
            end
            else 
            begin 
                data_valid_i            = 1'b0 ;
                data_i                  = 0 ;
            end
        end
    end
 #(PIXEL_CLK*(HORI_RES+280))frame_end_i       = 1'b1 ;
    frame_valid_i                       = 1'b1 ;
    write_done                          = 1'b1 ;
 #(4*PIXEL_CLK) frame_end_i             = 1'b0 ;
    frame_valid_i                       = 1'b0 ;
    write_done                          = 1'b0 ;
end
endtask

///////////////////////////////////////////////////////////////////////
// Read config
///////////////////////////////////////////////////////////////////////
initial 
begin
    read_en_i  	= 1'b0 ;
    repeat (FRAMES)
    tsk_read();
end

task automatic tsk_read ;
    begin
    wait (frame_end_i) 
    repeat (LINES)
        begin
        read_en_i 	                    = 1'b1 ; 
        #(PIXEL_CLK*HORI_RES)read_en_i	 = 1'b0 ;
        #(PIXEL_CLK*(280/4));
        end
    end
endtask  
 

///////////////////////////////////////////////////////////////////////
// Checker
///////////////////////////////////////////////////////////////////////
initial
begin
    $display("########################################################");
    $display("Horizontal Resolution %d",HORI_RES);
    $display("No of Frames %d",FRAMES);
    $display("No of Lines per Frame %d",LINES);
    $display("Line gap %d",line_gap_i);
    $display("########################################################");
    wait (data_valid_o);
    repeat (FRAMES)
    begin
      repeat (LINES) 
        @(negedge data_valid_o);
    end    
    #100;
    if (error == 1) 
    begin
        $display("\n########################################################");
        $display("------------------Test Failed---------------------------");
        $display(">>>>>>>>Output data not matched with Input data");
        $display("########################################################");
    end  
    else
    begin 
        $display("########################################################");
        $display("------------------Test Passed sucessfully---------------");
        $display(">>>>>>>>Output data matched with Input data");
        $display("########################################################");   
    end
    
    #100 $stop ;
end 

always@(posedge pixel_clk_i)
begin
  if(data_valid_o == 1) begin
    exp_data  = exp_data + 1 ;
    if(data_o      !=  exp_data) 
        error           = 1;
  end   
end

//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  AXI INTERFACE WITH RAM MODULE
//////////////////////////////////////////////////////////////////////
axi4_ram
 #(
   .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
   .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
  )
 axi4_ram_0
 (
    .sys_clk_i(ddr_clk_i),
    .resetn_i(rstn_i),
    .awready(awready),
    .wready(wready),
    .bid(bid),
    .bresp(bresp),
    .bvalid(bvalid),
    .arready(arready),
    .rid(rid),
    .rdata(rdata),
    .rresp(rresp),
    .rlast(rlast),
    .rvalid(rvalid),    
    .awid(awid),
    .awaddr(awaddr),
    .awlen(awlen),
    .awvalid(awvalid),
    .wdata(wdata),
    .wlast(wlast),
    .wvalid(wvalid),
    .bready(bready),
    .arid(arid),
    .araddr(araddr),
    .arlen(arlen),
    .arvalid(arvalid),
    .rready(rready)
    );
endmodule //ddr_read_write_tb

//simplified axi4 wrapper
module axi4_ram 
  #(
    parameter AXI_ADDR_WIDTH=64,
    parameter AXI_DATA_WIDTH=64, 
    parameter   AXI_ID_WIDTH= 4
)
   
(
input                      sys_clk_i,
input                      resetn_i,
//write address channel
input  [AXI_ADDR_WIDTH-1:0]  awaddr,
input  [AXI_ID_WIDTH-1:0]    awid,
input  [7:0]                 awlen,
input                        awvalid,
output                       awready,
//write data channel
input  [AXI_DATA_WIDTH-1:0]  wdata,
input                        wvalid,
input                        wlast,
output                       wready,
//write response channel
input                        bready,
output [AXI_ID_WIDTH-1:0]    bid,
output [1:0]                 bresp,
output reg                   bvalid,
//read address channel
input  [AXI_ADDR_WIDTH-1:0]  araddr,
input  [AXI_ID_WIDTH-1:0]    arid,
input  [7:0]                 arlen,
input                        arvalid,
output                       arready,
//read response channel
input                        rready,
output [AXI_ID_WIDTH-1:0]    rid,
output [AXI_DATA_WIDTH-1:0]  rdata,
output reg                   rvalid,
output reg                   rlast,
output [1:0]                 rresp
);

reg    [AXI_ADDR_WIDTH-1:0]  waddr;
reg    [AXI_ADDR_WIDTH-1:0]  raddr;
reg                          ren;

assign awready = 1;
assign wready  = 1;
assign bid     = awid;
assign bresp   = 0;
assign arready = 1;
assign rid     = arid;
assign rresp   = 0;



function [31:0] addr_log;
   input integer x;
   integer tmp, res;
   begin
      tmp = 1;
      res = 0;
      while(tmp < x) begin
         tmp = tmp * 2;
         res = res + 1;
      end
      addr_log = (res>0) ? res : 1;
   end
endfunction

localparam SLICE = addr_log(AXI_DATA_WIDTH/8) ;


//write address channel
always@(posedge sys_clk_i, negedge resetn_i)
  if (!resetn_i)
    waddr <= 0;
  else if (awvalid)
  waddr <= awaddr[AXI_ADDR_WIDTH-1:SLICE];
  else if (wvalid)
    waddr <= waddr + 1;
    
//write response channel
initial
begin
  bvalid = 0;
  forever@(posedge wlast)
  begin
    @(posedge sys_clk_i);
    bvalid = 1;
    @(posedge sys_clk_i);
    wait(bready);
    bvalid = 0;
  end
end  
  
//read address channel
always@(posedge sys_clk_i, negedge resetn_i)
  if (!resetn_i)
    raddr <= 0;
  else if (arvalid)
  raddr <= araddr[AXI_ADDR_WIDTH-1:SLICE];
  else if (ren)
    raddr <= raddr + 1;
    
//read response channel
always@(posedge sys_clk_i, negedge resetn_i)
begin
  if (!resetn_i)
    rvalid  <= 0;
  else
    rvalid  <= ren;  
end
initial
begin
  ren   = 0;
  rlast = 0;
  forever@(posedge arvalid)
  begin
    wait(rready);    
    repeat(arlen+1)
    begin
      @(posedge sys_clk_i);
      ren = 1;
    end
    @(posedge sys_clk_i);
    ren   = 0;
    rlast = 1;
    wait(rready); 
    @(posedge sys_clk_i);
    rlast = 0;
  end
end
  
//ram instantiation
mem_module
 #(
   .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
   .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
  )
 mem_module_0
  (
   .CLK(sys_clk_i),
   .W_EN(wvalid),
   .W_ADDR (waddr),
   .W_DATA (wdata),
   .R_EN   (ren),
   .R_ADDR (raddr),
   .R_DATA (rdata)
  );
  
endmodule //axi4 wrapper

//memory model
module mem_module
  #(
    parameter AXI_ADDR_WIDTH=64,
    parameter AXI_DATA_WIDTH=64)
   (
    input CLK,    
    input W_EN,
    input [AXI_ADDR_WIDTH-1:0] W_ADDR,
    input [AXI_DATA_WIDTH-1:0] W_DATA,
    input R_EN,
    input [AXI_ADDR_WIDTH-1:0] R_ADDR,
    output reg [AXI_DATA_WIDTH-1:0] R_DATA
    );
    
   logic [AXI_DATA_WIDTH-1:0] mem[*];
   
   always @(posedge CLK)
     if (W_EN)
       mem[W_ADDR] = W_DATA;

   always @(posedge CLK)
     if (R_EN)
       R_DATA <= mem[R_ADDR];
   
endmodule // mem_module

