//=================================================================================================
//-- File Name                           : synchronizer_circuit_ddr_read.v
//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2019 BY MICROSEMI
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================

module synchronizer_circuit_ddr_read
  ( 
    // inputs 
    input  rstn_i,
    input  sys_clk,
    input  data_in,
    // output
    output reg sync_out);
   
   reg 	   data_in_dly1;
   
   always@ (posedge sys_clk , negedge rstn_i )
	if (!rstn_i)
	  begin
	     data_in_dly1 <= 0;
	     sync_out <= 0;
	  end
	else
	  begin
	     data_in_dly1 <= data_in;
	     sync_out <= data_in_dly1;	     
	  end

endmodule
