/*************************************************************************************************************************************
--
-- File Name    : DDR_AXI4_ARBITER_PF_tb.v 
-- Description  : DDR_AXI4_ARBITER_PF_tb is provided to test DDR_AXI4_ARBITER IP with 2 read 
                  channels and 2 write channels with Bus Interface

-- COPYRIGHT 2023 BY MICROSEMI 
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
-- FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
-- MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
-- NO BACK-UP OF THE FILE SHOULD BE MADE. 
--
--*************************************************************************************************************************************/

`timescale 1ns/100ps
`include "../coreparameters.v"

module DDR_AXI4_ARBITER_PF_tb;

parameter SYSCLK_PERIOD = 10;// 100MHZ

parameter burst_len    = 15;  //16 beats
    
reg SYSCLK;
reg NSYSRESET;

//wr ch 0
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_0;
reg  [7:0]                AWSIZE_I_0;
reg                       AWVALID_I_0;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_0;
reg                       WVALID_I_0;
reg                       AWREADY_O_0;
wire                      BUSER_O_0;
//wr ch 1
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_1;
reg  [7:0]                AWSIZE_I_1;
reg                       AWVALID_I_1;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_1;
reg                       WVALID_I_1;
reg                       AWREADY_O_1;
wire                      BUSER_O_1;
`ifdef WR_CH //> 2 // Not used
//wr ch 2
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_2;
reg  [7:0]                AWSIZE_I_2;
reg                       AWVALID_I_2;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_2;
reg                       WVALID_I_2;
reg                       AWREADY_O_2;
wire                      BUSER_O_2;
//wr ch 3
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_3;
reg  [7:0]                AWSIZE_I_3;
reg                       AWVALID_I_3;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_3;
reg                       WVALID_I_3;
reg                       AWREADY_O_3;
wire                      BUSER_O_3;
//wr ch 4
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_4;
reg  [7:0]                AWSIZE_I_4;
reg                       AWVALID_I_4;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_4;
reg                       WVALID_I_4;
reg                       AWREADY_O_4;
wire                      BUSER_O_4;
//wr ch 5
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_5;
reg  [7:0]                AWSIZE_I_5;
reg                       AWVALID_I_5;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_5;
reg                       WVALID_I_5;
reg                       AWREADY_O_5;
wire                      BUSER_O_5;
//wr ch 6
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_6;
reg  [7:0]                AWSIZE_I_6;
reg                       AWVALID_I_6;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_6;
reg                       WVALID_I_6;
reg                       AWREADY_O_6;
wire                      BUSER_O_6;
//wr ch 7
reg  [AXI_ADDR_WIDTH-1:0] AWADDR_I_7;
reg  [7:0]                AWSIZE_I_7;
reg                       AWVALID_I_7;
reg  [AXI_DATA_WIDTH-1:0] WDATA_I_7;
reg                       WVALID_I_7;
reg                       AWREADY_O_7;
wire                      BUSER_O_7;
`endif

//rd ch 0
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_0;
reg  [7:0]                ARSIZE_I_0;
reg                       ARVALID_I_0;
reg                       ARREADY_O_0;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_0;
reg                       RLAST_O_0;
reg                       RVALID_O_0;
//rd ch 1
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_1;
reg  [7:0]                ARSIZE_I_1;
reg                       ARVALID_I_1;
reg                       ARREADY_O_1;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_1;
reg                       RLAST_O_1;
reg                       RVALID_O_1;
`ifdef RD_CH // > 2 // Not used
//rd ch 2
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_2;
reg  [7:0]                ARSIZE_I_2;
reg                       ARVALID_I_2;
reg                       ARREADY_O_2;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_2;
reg                       RLAST_O_2;
reg                       RVALID_O_2;
//rd ch 3
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_3;
reg  [7:0]                ARSIZE_I_3;
reg                       ARVALID_I_3;
reg                       ARREADY_O_3;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_3;
reg                       RLAST_O_3;
reg                       RVALID_O_3;
//rd ch 4
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_4;
reg  [7:0]                ARSIZE_I_4;
reg                       ARVALID_I_4;
reg                       ARREADY_O_4;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_4;
reg                       RLAST_O_4;
reg                       RVALID_O_4;
//rd ch 5
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_5;
reg  [7:0]                ARSIZE_I_5;
reg                       ARVALID_I_5;
reg                       ARREADY_O_5;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_5;
reg                       RLAST_O_5;
reg                       RVALID_O_5;
//rd ch 6
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_6;
reg  [7:0]                ARSIZE_I_6;
reg                       ARVALID_I_6;
reg                       ARREADY_O_6;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_6;
reg                       RLAST_O_6;
reg                       RVALID_O_6;
//rd ch 7
reg  [AXI_ADDR_WIDTH-1:0] ARADDR_I_7;
reg  [7:0]                ARSIZE_I_7;
reg                       ARVALID_I_7;
reg                       ARREADY_O_7;
reg  [AXI_DATA_WIDTH-1:0] RDATA_O_7;
reg                       RLAST_O_7;
reg                       RVALID_O_7;
`endif

reg   [7:0]               data_init0;
reg   [7:0]               data_init1;
reg                       err0;
reg                       err1;

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
    
/************************************************************************
  write channel 0
*************************************************************************/
initial
begin
  AWADDR_I_0    = 0;
  AWSIZE_I_0    = 0;
  AWVALID_I_0   = 0;
  WVALID_I_0    = 0;
  WDATA_I_0     = 0;
  data_init0 = 0;
  wait(NSYSRESET);
  @(posedge SYSCLK);
  @(posedge SYSCLK);
  AWADDR_I_0[AXI_ADDR_WIDTH-1 : AXI_ADDR_WIDTH-2] = 2'b01;
  AWSIZE_I_0     = burst_len; 
  data_init0 = 0;  
  arb_write(AWSIZE_I_0,data_init0,AWVALID_I_0,AWREADY_O_0,WVALID_I_0,WDATA_I_0);  
end 
/************************************************************************
  write channel 1
*************************************************************************/
initial
begin
  AWADDR_I_1    = 0;
  AWSIZE_I_1    = 0;
  AWVALID_I_1   = 0;
  WVALID_I_1    = 0;
  WDATA_I_1     = 0;
  data_init1 = 0;
  wait(NSYSRESET);
  @(posedge SYSCLK);
  @(posedge SYSCLK);
  AWADDR_I_1[AXI_ADDR_WIDTH-1 : AXI_ADDR_WIDTH-2] = 2'b10;
  AWSIZE_I_1     = burst_len;
  data_init1 = 8'h80;  
  arb_write(AWSIZE_I_1,data_init1,AWVALID_I_1,AWREADY_O_1,WVALID_I_1,WDATA_I_1);  
end
/************************************************************************
  read channel 0
*************************************************************************/
initial
begin
  ARADDR_I_0    = 0;
  ARSIZE_I_0    = 0;
  ARVALID_I_0   = 0;
  err0       = 0;
  wait(BUSER_O_1); // wait for writes
  @(posedge SYSCLK);
  ARADDR_I_0[AXI_ADDR_WIDTH-1 : AXI_ADDR_WIDTH-2] = 2'b01;
  ARSIZE_I_0     = burst_len;
  arb_read(ARSIZE_I_0,data_init0,ARVALID_I_0,ARREADY_O_0,RVALID_O_0,RDATA_O_0,RLAST_O_0,err0);  
end 
/************************************************************************
  read channel 1
*************************************************************************/
initial
begin
  ARADDR_I_1    = 0;
  ARSIZE_I_1    = 0;
  ARVALID_I_1   = 0;
  err1       = 0;
  wait(BUSER_O_1); // wait for writes
  @(posedge SYSCLK);
  ARADDR_I_1[AXI_ADDR_WIDTH-1 : AXI_ADDR_WIDTH-2] = 2'b10;
  ARSIZE_I_1     = burst_len;
  arb_read(ARSIZE_I_1,data_init1,ARVALID_I_1,ARREADY_O_1,RVALID_O_1,RDATA_O_1,RLAST_O_1,err1);  
end 
/************************************************************************
  test result
*************************************************************************/
initial
begin
   if (NO_OF_READ_CHANNELS != 2 || NO_OF_WRITE_CHANNELS != 2 || FORMAT != 1)
   begin
     $display("**********************************************************\n");
     $display("To run this testbench, the number of Read and Write channels must be configured to 2 with Bus Interface configuration.\n"); 
     $display("**********************************************************\n");
     #100;
     $stop;
   end  
   wait(RLAST_O_0);
   $display("**********************************************************\n");
   #20;
   if (err0 == 1)
     $display("Channel 0 Test Failed\n");  
   else 
     $display("Channel 0 Test Passed\n");      
   wait(RLAST_O_1);
   $display("**********************************************************\n");
   #20;
   if (err1 == 1)
     $display("Channel 1 Test Failed\n");  
   else 
     $display("Channel 1 Test Passed\n");  
   $display("**********************************************************\n");
   #100;
   $stop;
end   
   
/************************************************************************
  write channel task
*************************************************************************/ 
task automatic arb_write;
  input [7:0]  awlen;
  input [7:0]  data_init;
  ref logic    awvalid;
  ref logic    awready;
  ref logic    wvalid;
  ref logic [AXI_DATA_WIDTH-1:0] wdata;
 begin
  reg [7:0] val; 
  integer i;
  awvalid = 0;
  wvalid  = 0; 
  wdata   = 0;
  val     = data_init;
  @(posedge SYSCLK);
  awvalid = 1;
  wait(awready);
  @(posedge SYSCLK);
  awvalid = 0;
  repeat(awlen+1)
  begin
    @(posedge SYSCLK);
    wvalid  = 1;
    for(i=0; i < AXI_DATA_WIDTH/8 ; i = i+1)
    begin
      wdata[(i*8)     +: 8] = val + i;
    end  
    val = val + AXI_DATA_WIDTH/8;
  end
  @(posedge SYSCLK);    
  wvalid = 0;
 end
endtask 
/************************************************************************
  read channel task
*************************************************************************/ 
task automatic arb_read;
  input [7:0]                  arlen;
  input [7:0]                  data_init;
  ref logic                    arvalid;
  ref logic                    arready;
  ref logic                    rvalid;
  ref logic [AXI_DATA_WIDTH-1:0] rdata;
  ref logic                    rlast;
  ref logic                    err;
 begin
  reg [7:0] val; 
  reg [AXI_DATA_WIDTH-1:0] exp_data;
  integer i;
  arvalid = 0;
  val     = data_init;
  exp_data= 0;
  err     = 0;
  @(posedge SYSCLK);
  arvalid = 1;
  wait(arready);
  @(posedge SYSCLK);
  arvalid = 0;
  repeat(arlen+1)
  begin
    wait(rvalid);    
    for(i=0; i < AXI_DATA_WIDTH/8 ; i = i+1)
    begin
      exp_data[(i*8)     +: 8] = val + i;        
    end  
    @(posedge SYSCLK);
    if(rdata != exp_data)
      err = 1;    
    val = val + AXI_DATA_WIDTH/8;
  end
  wait(rlast); 
 end
endtask 

wire sys_clk_i;
wire reset_i;
wire ddr_ctrl_ready_i;

assign sys_clk_i = SYSCLK;
assign reset_i   = NSYSRESET;
assign ddr_ctrl_ready_i = NSYSRESET;
//unused
wire BUSER_O_r0;
wire BUSER_O_r1;
wire [2:0] awsize;
wire [1:0] awburst;
wire [1:0] awlock;
wire [3:0] awcache;
wire [2:0] awprot;
wire [(AXI_DATA_WIDTH/8)-1:0] wstrb;
wire [2:0] arsize;
wire [1:0] arburst;
wire [1:0] arlock;
wire [3:0] arcache;
wire [2:0] arprot;

//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  DDR_AXI4_ARBITER_PF_C0
//////////////////////////////////////////////////////////////////////
generate if (NO_OF_READ_CHANNELS != 2 || NO_OF_WRITE_CHANNELS != 2 || FORMAT != 1)
  DDR_AXI4_ARBITER_PF_C0 DDR_AXI4_ARBITER_PF_C0_0 (
    // Inputs
    .sys_clk_i(SYSCLK),
    .reset_i(NSYSRESET),
    .ddr_ctrl_ready_i(NSYSRESET)
    );
else
  DDR_AXI4_ARBITER_PF_C0 DDR_AXI4_ARBITER_PF_C0_0 ( .*  );
endgenerate

axi4_ram
 #(
   .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
   .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
  )
 axi4_ram_0
 (
    .sys_clk_i(SYSCLK),
    .resetn_i(NSYSRESET),
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
endmodule //DDR_AXI4_ARBITER_PF_C0_tb

//simplified axi4 wrapper
module axi4_ram
  #(
    parameter AXI_ADDR_WIDTH=64,
    parameter AXI_DATA_WIDTH=64)
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

//write address channel
always@(posedge sys_clk_i, negedge resetn_i)
  if (!resetn_i)
    waddr <= 0;
  else if (awvalid)
    waddr <= awaddr;
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
    raddr <= araddr;
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