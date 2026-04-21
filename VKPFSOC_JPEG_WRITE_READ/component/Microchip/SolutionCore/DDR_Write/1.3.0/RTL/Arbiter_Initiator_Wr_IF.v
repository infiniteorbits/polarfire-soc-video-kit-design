//=================================================================================================
//-- File Name                           : Arbiter_Initiator_Wr_IF.v

//-- Targeted device                     : Microchip
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module Arbiter_Initiator_Wr_IF
#(
	parameter g_DDR_AXI_DWIDTH_O	    = 4
  )
  (
  // Input Ports
  input								    CLOCK_I,
  input								    RESET_n_I,
  input	[g_DDR_AXI_DWIDTH_O-1 : 0]      DATA_I,
  input                                 DATA_VALID_I,
  input	[31 : 0]                        START_ADDR_I,
  input                                 REQ_I,
  input [7:0]                           BURST_SIZE_I,
  input                                 AWREADY_I,
  input                                 BUSER_I, 
  
  // Output Ports
  output [g_DDR_AXI_DWIDTH_O-1 : 0]	    WDATA_O,
  output                                WVALID_O,
  output [31 : 0]                       AWADDR_O,
  output                                AWVALID_O,
  output [7:0]                          AWSIZE_O,
  output                                W_DONE_O,
  output                                W_ACK_O 
  );
  
  
  assign WDATA_O		=	DATA_I;
  assign WVALID_O		=	DATA_VALID_I;
  assign AWADDR_O		=	START_ADDR_I;
  assign AWVALID_O      =   REQ_I;
  assign AWSIZE_O       =   BURST_SIZE_I;
  assign W_ACK_O        =   AWREADY_I;
  assign W_DONE_O		=	BUSER_I;
  
  

 endmodule