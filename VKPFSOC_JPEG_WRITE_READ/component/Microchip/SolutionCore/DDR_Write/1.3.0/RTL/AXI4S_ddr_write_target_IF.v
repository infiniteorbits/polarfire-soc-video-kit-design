//=================================================================================================
//-- File Name                           : AXI4S_ddr_write_target_IF.v

//-- Targeted device                     : Microchip
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module AXI4S_ddr_write_target_IF
#(
	parameter g_DDR_AXI_DWIDTH_I     = 8
 )
 (
    input [g_DDR_AXI_DWIDTH_I-1 : 0] TDATA_I,
    input TVALID_I,
    output TREADY_O,
    input [3:0] TUSER_I,
	output [g_DDR_AXI_DWIDTH_I-1 : 0] DATA_O,
    output FRAME_VALID_O,
    output DATA_VALID_O,
	output FRAME_END_O
 );
 
assign DATA_O		     = TDATA_I;
assign DATA_VALID_O		 = TVALID_I;
assign FRAME_END_O		 = TUSER_I[0];
assign FRAME_VALID_O     = TUSER_I[3];
assign TREADY_O          = 1'b1;

endmodule