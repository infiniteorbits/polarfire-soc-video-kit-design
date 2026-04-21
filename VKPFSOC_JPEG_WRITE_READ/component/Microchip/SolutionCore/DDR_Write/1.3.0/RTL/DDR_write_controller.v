//=================================================================================================
//-- File Name                           : DDR_write_controller.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2019 BY MICROSEMI
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module DDR_write_controller #(
	parameter g_DDR_AXI_DWIDTH_I = 32,
	parameter g_DDR_AXI_DWIDTH_O = 128,
	parameter g_FRAME_GAP        = 1
    )
	(
	// System reset
    input 									reset_i,
    
    // System clock
    input 									sys_clk_i,
    
    // Line gap
    
    input   [15 : 0]				        c_LINE_GAP,
    
    // write enable
    input 									start_i,
	                                    
	// write Acknowledgment input      
    input 									write_ackn_i,
	                                    
	// write done input                 
    input 									write_done_i,	
	
	// frame end signal from video source
    input 									frame_end_i,
	
    //brust length
	input [15 : 0]							brust_len_i,
	
    //Frame DDR address
    input [7 : 0]							frame_ddr_addr_i,
	
	// write request to DDR
	output 									write_req_o,
	
	// Read request to fifo
	output 									read_fifo_o,
	
	// DDR write FRAME ADDRESS
	output [7 : 0]							display_frame_addr_o,
	
	// DDR write START ADDRESS
	output [31 : 0]			                write_start_addr_o,
	
	// Number of Bytes to write
	output [15 : 0]							write_length_o
);


//=================================================================================================
// parameter declarations
//=================================================================================================
localparam  MAX_BIT_WIDTH               = 256;
localparam	IDLE						= 2'd0;
localparam	WRITE_REQUESTING			= 2'd1;
localparam	WRITING						= 2'd2;
localparam  BRUST_LEN_CHK				= 2'd3;

//=================================================================================================
// Signal declarations
//=================================================================================================
reg		[1  : 0]				  s_state;
reg 							  s_frame_end_dly1;	
reg 							  s_frame_end_dly2;	
wire 							  s_frame_end_re;	
reg 							  s_start_dly1;	
reg 							  s_start_dly2;	
wire 							  s_start_fe;	
reg 							  s_write_req;	
reg 							  s_read_fifo;	
wire [31 : 0]                     s_write_start_addr;
reg  [15 : 0] 					  s_counter;
reg  [15 : 0] 					  s_hcount;
reg  [15 : 0] 					  s_count_max;
reg  [23 + g_FRAME_GAP : 0] 	  s_line_counter;
reg  [1  : 0] 					  s_frame_index;
wire [1  : 0] 					  s_disp_frame_index;

reg                				dummy1;
//=================================================================================================
//	 Top level output port assignments
//=================================================================================================
assign write_req_o					= s_write_req;
assign write_start_addr_o			= s_write_start_addr;
assign write_length_o				= s_count_max - 1;
assign read_fifo_o					= s_read_fifo;
assign display_frame_addr_o 		= {frame_ddr_addr_i[7:2] , s_disp_frame_index};

//=================================================================================================
// 	Asynchronous blocks
//=================================================================================================
assign s_disp_frame_index			= s_frame_index - 1;
assign s_frame_end_re				= s_frame_end_dly1 & (!s_frame_end_dly2);
assign s_start_fe		    		= s_start_dly2 & (!s_start_dly1);
assign s_write_start_addr			= {frame_ddr_addr_i[7:2+g_FRAME_GAP] , s_frame_index , s_line_counter};

//=================================================================================================
//	 Synchronous blocks
//-=================================================================================================

//--------------------------------------------------------------------------
// Name       : SIGNAL_DELAY
// Description: Process to delay signal and find rising edge
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_frame_end_dly1	<= 0;
		s_frame_end_dly2	<= 0;
		s_start_dly1	    <= 0;
		s_start_dly2	    <= 0;
	end
	else begin 
		s_frame_end_dly1	<= frame_end_i;
		s_frame_end_dly2	<= s_frame_end_dly1;			
		s_start_dly1	    <= start_i;			
		s_start_dly2	    <= s_start_dly1;	
	end
end

//--------------------------------------------------------------------------
// Name       : CORDIC_FSM_PROC
// Description: FSM implements cordic operations
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_state  			<= IDLE;			
		s_write_req			<= 0;
		s_read_fifo 		<= 0;
		s_count_max			<= 0;
		s_counter			<= 0;
		s_hcount			<= 0;
		s_frame_index		<= 0;
		s_line_counter		<= 0;
		dummy1          	<= 0;
	end
	else begin 
		case(s_state)
			IDLE	:
			begin 		
				s_write_req		<= 0;
				s_read_fifo 	<= 0;
				s_counter		<= 0;
				if(s_frame_end_re == 1) begin 					
					s_frame_index	<= s_frame_index + 1;
					s_line_counter	<= 0;
				end
				if(s_start_fe == 1) begin
					if (brust_len_i >= MAX_BIT_WIDTH ) begin
                        s_count_max	<= MAX_BIT_WIDTH ;
                        s_hcount	<= brust_len_i - MAX_BIT_WIDTH ;
					end else begin
                        s_count_max <= brust_len_i ;
                        s_hcount  	<= 0 ;
					end
					s_state 	    <= WRITE_REQUESTING;
				end
			end
			
			WRITE_REQUESTING	:
			begin 
				s_counter 		<= 0 ;
				if(write_ackn_i == 1) begin 
					s_write_req	<= 0;
					s_state 	<= WRITING;
				end
				else begin 
					s_write_req	<= 1;
				end
			end
			
			WRITING	:
			begin 
				if(write_done_i == 1) begin 
					s_state 	<= BRUST_LEN_CHK;
					{dummy1,s_line_counter}		<= s_line_counter + c_LINE_GAP;	
				end
				else if(s_counter >= s_count_max) begin 
					s_read_fifo <= 0;
				end
				else begin 
					s_counter 	<= s_counter + 1;
					s_read_fifo	<= 1;
				end
			end
			
			BRUST_LEN_CHK :
			begin
				if (s_hcount >= MAX_BIT_WIDTH) begin
					s_count_max <= MAX_BIT_WIDTH ;
					s_hcount	<= s_hcount - MAX_BIT_WIDTH ;
					s_state 	<= WRITE_REQUESTING ;
				end
				else if (s_hcount != 0) begin 
					s_count_max <= s_hcount ;
					s_hcount	<= 0  ;
					s_state 	<= WRITE_REQUESTING ;
				end else begin
					s_state 	<= IDLE ;
				end
			end
			
			default	:
			begin 
					s_state <= IDLE;
			end
		endcase
	end
end


endmodule