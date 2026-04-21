//=================================================================================================
//-- File Name                           : data_packer.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROSEMI
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module data_packer
#(
	parameter g_DDR_AXI_DWIDTH_I = 32,
	parameter g_DDR_AXI_DWIDTH_O = 128,
    parameter g_NO_OF_PIXEL      = 4,
    parameter g_DATA_WIDTH           = g_DDR_AXI_DWIDTH_I * g_NO_OF_PIXEL 
 )
    
   (	
	// System reset
	input	rstn_i,

	// System clock
	input 	sys_clk_i,

	// enable
	input 	data_valid_i,

	//Frame end input
	input	frame_end_i,

	// Data Input
	input [g_DATA_WIDTH-1 : 0] data_i,

	// Data Enable
	output 	data_valid_o,

	// Start DDR write
	output 	start_ddr_w_o,

	// FIFO reset
	output 	fifo_reset_o,

	//Horizontal count detected
	output [15 : 0]	brust_len_o,

	// Data output
	output [g_DDR_AXI_DWIDTH_O-1 : 0] data_o
    );
//=================================================================================================
// Parameter declarations
//=================================================================================================
  localparam CNTR_MOD     = (g_NO_OF_PIXEL == 4) ? g_DDR_AXI_DWIDTH_O/g_DATA_WIDTH : 
                               (g_DDR_AXI_DWIDTH_O < (g_DATA_WIDTH*4)) ? (g_DDR_AXI_DWIDTH_O/g_DATA_WIDTH) : ((g_DDR_AXI_DWIDTH_O/(g_DATA_WIDTH*4))*4);
  localparam counter_max  = (g_DDR_AXI_DWIDTH_O >> (log(g_DATA_WIDTH)));
  localparam cntr_bits    = log(counter_max);
  function [31:0] log;
   input integer x;
   integer tmp, res;
   begin
      tmp = 1;
      res = 0;
      while(tmp * 2 <= x) begin
         tmp = tmp * 2;
         res = res + 1;
      end
      log = res ;
   end
endfunction
  
//=================================================================================================
// Signal declarations
//=================================================================================================
  reg [cntr_bits-1  : 0]   	        s_counter;
  reg [15 : 0]		 				brust_len;
  reg [15 : 0]		 				brust_len_latch;
  wire [g_DDR_AXI_DWIDTH_O-1 : 0]	s_data_pack;
  reg [3  : 0]		 				s_dv_fe_ctr;
  reg 		 						s_data_valid_dly1;
  reg 		 						s_data_valid_dly2;
  reg                               s_data_valid_fe_dly;
  reg                               s_data_valid_fe_dly2;
  reg                               s_data_valid_o;
  wire 		 						s_data_valid_fe;
  reg 		 						s_frame_valid_dly1;
  reg 		 						s_frame_valid_dly2;
  wire 		 						s_frame_valid_re;
  reg		 						s_dv_fe_ctr_en;
  reg		 						s_ddr_start;
  reg  [g_DATA_WIDTH-1:0]		s_data_arr[0:counter_max-1];

//=================================================================================================
// Top level output port assignments
//=================================================================================================
  assign data_valid_o           = s_data_valid_o;
  assign data_o                 = s_data_pack;
  assign brust_len_o            = brust_len_latch;
  assign start_ddr_w_o          = s_ddr_start;
  assign fifo_reset_o           = !(s_frame_valid_re);
    
//=================================================================================================
// Asynchronous blocks
//=================================================================================================
  assign s_data_valid_fe   	    = s_data_valid_dly1 & (!data_valid_i);
  assign s_frame_valid_re    	= s_frame_valid_dly1 & (!s_frame_valid_dly2);
  
//=================================================================================================
//=================================================================================================
// Synchronous blocks
//=================================================================================================

//--------------------------------------------------------------------------
// Name       : DATA_COUNTER
// Description: Counter to count data
//--------------------------------------------------------------------------	
always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		s_counter      <= 0;
	end
	else begin 
    if( data_valid_i == 1 && s_counter < CNTR_MOD - 1)begin 
			s_counter <= s_counter + 1;
		end
		else begin 
			s_counter <= 0;
		end
	end
end		
//--------------------------------------------------------------------------
// Name       : data_valid_o
// Description: Process to generate s_datapack_valid
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		s_data_valid_o	<= 0;
	end
	else begin
        if (CNTR_MOD == 1 && data_valid_i == 1 ) begin
            s_data_valid_o	<= 1;
        end
        else if(s_counter == CNTR_MOD -1 && CNTR_MOD != 1) begin 
			s_data_valid_o	<= 1;
		end
		else if ( s_data_valid_fe && s_counter != 1'b0 ) 
            s_data_valid_o	<= 1;
        else begin 
			s_data_valid_o	<= 0;
		end
	end
end


//--------------------------------------------------------------------------
// Name       : BRUST_COUNT_LATCH_PROC
// Description: Process latches s_h_count output at falling edge of data enable
//--------------------------------------------------------------------------	
always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		brust_len	<= 0;
	end
	else begin 
        if(s_data_valid_o) begin
            brust_len <= brust_len + 1 ;
        end
        else if(s_data_valid_fe_dly2 == 1)begin
            brust_len       <= 0;
		end
    end
end
	

always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		brust_len_latch <= 0;
	end
	else begin 
        if(s_data_valid_fe_dly2 == 1)begin
			brust_len_latch <= brust_len  ;
		end
	end
end	
	
//--------------------------------------------------------------------------
// Name       : DELAY
// Description: Process delays input signals
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		s_data_valid_dly1       <= 0 ;
		s_data_valid_dly2       <= 0 ;
		s_frame_valid_dly1      <= 0 ;
		s_frame_valid_dly2      <= 0 ;
        s_data_valid_fe_dly     <= 0 ;
        s_data_valid_fe_dly2    <= 0 ;
	end
	else begin 
		s_data_valid_dly1       <= data_valid_i;
		s_data_valid_dly2       <= s_data_valid_dly1;
		s_frame_valid_dly1      <= frame_end_i;
		s_frame_valid_dly2      <= s_frame_valid_dly1;
        s_data_valid_fe_dly     <= s_data_valid_fe ;
        s_data_valid_fe_dly2    <= s_data_valid_fe_dly;
	end
end

//--------------------------------------------------------------------------
// Name       : DATA_VALID_FE_COUNTER
// Description: PROCESS to extend data_valid falling edge signal to 4 clock cycles
//--------------------------------------------------------------------------	
always@(posedge sys_clk_i, negedge rstn_i) begin 
	if(!rstn_i) begin 
		s_dv_fe_ctr             <= 0;
		s_dv_fe_ctr_en          <= 0;
		s_ddr_start 	        <= 0;
	end
	else begin 
		if(s_data_valid_fe_dly == 1)begin 
			s_dv_fe_ctr_en      <= 1;
			s_ddr_start 	    <= 1;
		end
		else if(s_dv_fe_ctr == 4'h4)begin 
			s_dv_fe_ctr_en      <= 0;
			s_ddr_start 	    <= 0;
		end
		
		if(s_dv_fe_ctr_en == 1) begin 
			s_dv_fe_ctr         <= s_dv_fe_ctr + 1;
		end
		else begin 
			s_dv_fe_ctr         <= 0;
		end
	end
end	
	
//--------------------------------------------------------------------------
// Name       : DATA PACK
// Description: Process to generates the data packing
//--------------------------------------------------------------------------
generate
	genvar I;
	for (I=0; I<CNTR_MOD; I=I+1) begin
        assign s_data_pack[g_DATA_WIDTH*(I+1)-1 : g_DATA_WIDTH*I] = s_data_arr[I];
		always@(posedge sys_clk_i, negedge rstn_i) begin 
			if(!rstn_i) begin 
				s_data_arr[I]	        <= 0;
			end
			else if(data_valid_i == 1 && s_counter == I)begin 
				s_data_arr[I]	<= data_i;
			end
		end
	end
endgenerate

generate if (CNTR_MOD*g_DATA_WIDTH < g_DDR_AXI_DWIDTH_O)
  assign s_data_pack[g_DDR_AXI_DWIDTH_O-1 : CNTR_MOD*g_DATA_WIDTH] = 0; 
endgenerate
  
endmodule


