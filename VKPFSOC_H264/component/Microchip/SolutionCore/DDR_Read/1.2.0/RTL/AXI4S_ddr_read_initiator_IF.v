//=================================================================================================
//-- File Name                           : AXI4S_ddr_read_initiator_IF.v

//-- Targeted device                     : Microchip
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module AXI4S_ddr_read_initiator_IF
#(
	parameter g_DDR_AXI_DWIDTH_O		= 8
  )
  (
  // Input Ports
  input												CLOCK_I,
  input												RESET_n_I,
  input	[g_DDR_AXI_DWIDTH_O - 1 : 0]		        DATA_I,
  input												DATA_VALID_I,
  input												EOF_I,
  // Output Ports
  output [g_DDR_AXI_DWIDTH_O - 1 : 0]	            TDATA_O,
  output [g_DDR_AXI_DWIDTH_O/8 - 1 : 0]             TSTRB_O,
  output [g_DDR_AXI_DWIDTH_O/8 - 1 : 0]             TKEEP_O,
  output 											TVALID_O,
  output											TLAST_O,
  output [3 : 0]									TUSER_O  
  );

  reg   										 eof_dly1;
  reg   										 data_valid_dly1;
  reg   [g_DDR_AXI_DWIDTH_O - 1 : 0]             data_dly1;
  wire   										 tvalid_fe;
  
  assign TDATA_O		=	data_dly1;
  assign TSTRB_O    	=   {(g_DDR_AXI_DWIDTH_O/8){1'b1}};
  assign TKEEP_O    	=   {(g_DDR_AXI_DWIDTH_O/8){1'b1}};
  assign TVALID_O		=	data_valid_dly1;
  assign TLAST_O		=	tvalid_fe;
  assign TUSER_O[0]		=	eof_dly1;
  assign TUSER_O[3 : 1] =   3'b0;
  
  assign tvalid_fe = (data_valid_dly1 & (~DATA_VALID_I));
  
  always @(posedge CLOCK_I or negedge RESET_n_I)
    if(!RESET_n_I)
      begin
        eof_dly1			<= 0;
		data_valid_dly1		<= 0;
		data_dly1			<= {(g_DDR_AXI_DWIDTH_O){1'b0}};
	  end
	else
	  begin
	    eof_dly1			<= EOF_I;
		data_valid_dly1		<= DATA_VALID_I;
		data_dly1			<= DATA_I;
      end 
 endmodule