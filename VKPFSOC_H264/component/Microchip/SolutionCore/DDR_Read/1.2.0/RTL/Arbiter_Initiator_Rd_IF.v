//=================================================================================================
//-- File Name                           : Arbiter_Initiator_Rd_IF.v

//-- Targeted device                     : Microchip
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module Arbiter_Initiator_Rd_IF
#(
	parameter g_DDR_AXI_DWIDTH_I	= 4
  )
  (
  // Input Ports
  input	[g_DDR_AXI_DWIDTH_I-1 : 0]   RDATA_I,
  input                              RVALID_I,
  input [31 : 0]                     START_ADDR_I,
  input                              REQ_I,
  input [7:0]                        BURST_SIZE_I,
  input                              ARREADY_I,
  input                              BUSER_I, 
  
  // Output Ports
  output [g_DDR_AXI_DWIDTH_I-1 : 0]  DATA_O,
  output                             DATA_VALID_O,
  output [31 : 0]                    ARADDR_O,
  output                             ARVALID_O,
  output [7:0]                       ARSIZE_O,
  output                             R_DONE_O,
  output                             R_ACK_O 
  
  );
  assign DATA_O			    =	RDATA_I;
  assign DATA_VALID_O       =   RVALID_I;
  assign ARADDR_O           =   START_ADDR_I;
  assign ARSIZE_O           =   BURST_SIZE_I;
  assign ARVALID_O          =   REQ_I;
  assign R_DONE_O	        =	BUSER_I;
  assign R_ACK_O	        =	ARREADY_I;
  
 endmodule