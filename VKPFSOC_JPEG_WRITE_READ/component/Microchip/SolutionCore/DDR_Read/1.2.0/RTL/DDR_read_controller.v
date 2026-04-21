//=================================================================================================
//-- File Name                           : DDR_read_controller.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2019 BY MICROSEMI
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module DDR_read_controller#(  
	parameter g_FRAME_GAP        = 1
    )
(
	// System reset
    input			reset_i,
    
    // System clock
    input			sys_clk_i,
    
    // line gap
    input [15 :0]   c_LINE_GAP,
    
    
    input [15 : 0]  burst_len_i,

    
    // Read enable
    input			read_en_i,
	
	// Read Acknowledgment input
    input			read_ackn_i,
		
	// Read done input
    input			read_done_i,
	
	// Vertical sync signal
    input			frame_end_i,

	// DDR READ START ADDRESS
	input  [7 : 0]	frame_start_addr_i,

	// Horizontal PAN value
	input  [11 : 0]	h_pan_i,

	// Vertical PAN value
	input  [11 : 0]	v_pan_i,
	
	// Read request to DDR
	output			read_req_o,
    
    output  [7:0]   burst_hcount_o,
	
	// DDR READ START ADDRESS
	output [31 : 0]	read_start_addr_o
);

//=================================================================================================
// Parameter declarations
//=================================================================================================
localparam	IDLE			= 2'd0;
localparam	READ_TRIG		= 2'd1;
localparam	READING			= 2'd2;
localparam  BRUST_LEN_CHK	= 2'd3;
localparam  MAX_BIT_WIDTH   = 256;


//=================================================================================================
// Signal declarations
//=================================================================================================
reg 	[1  : 0]					s_state;
reg     [15 : 0] 					s_hcount;
reg     [15 : 0] 					s_count_max;
reg						 			s_read_en_dly1;	
reg						 			s_read_en_dly2;	
reg						 			s_read_en_re;	
reg						 			s_read_req;	
reg		[31 : 0]	                s_read_start_addr;
reg		[11 : 0]				 	s_pan_h;
reg		[11 : 0]				 	s_pan_h_dly;
reg		[11 : 0]				 	s_pan_v;
reg		[11 : 0]				 	s_pan_v_dly;

wire     [7:0]					    frame_start_addr_temp;
reg                                 dummy1;
//=================================================================================================
// Top level output port assignments
//=================================================================================================
assign	read_req_o			= s_read_req;
assign	read_start_addr_o	= s_read_start_addr;
assign  burst_hcount_o      = s_count_max - 1 ;

assign frame_start_addr_temp = frame_start_addr_i << g_FRAME_GAP ;

//=================================================================================================
// Asynchronous blocks
//=================================================================================================	


//=================================================================================================
// Synchronous blocks
//=================================================================================================

//--------------------------------------------------------------------------
// Name       : SIGNAL_DELAY
// Description: Process to delay signal and find rising edge
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_read_en_dly1	<= 0;
		s_read_en_dly2	<= 0;
		s_read_en_re	<= 0;
		s_pan_h     	<= 0;
		s_pan_h_dly    	<= 0;
		s_pan_v     	<= 0;
		s_pan_v_dly    	<= 0;
	end
	else begin
		s_read_en_dly1	<= read_en_i;
		s_read_en_dly2	<= s_read_en_dly1;
		s_read_en_re	<= s_read_en_dly1 & (!s_read_en_dly2);
		s_pan_h     	<= h_pan_i;
		s_pan_v     	<= v_pan_i;
		s_pan_h_dly    	<= s_pan_h;
		s_pan_v_dly    	<= s_pan_v;	
	end
end


//--------------------------------------------------------------------------
// Name       : CORDIC_FSM_PROC
// Description: FSM implements cordic operations
//--------------------------------------------------------------------------
always@(posedge sys_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_state  			<= IDLE;			
		s_read_req			<= 0;
        s_count_max			<= 0;
		s_hcount			<= 0;
		dummy1              <= 0;
		s_read_start_addr	<= {frame_start_addr_temp, s_pan_v_dly, s_pan_h_dly};
	end
	else begin 
		case(s_state)
			IDLE :
			begin 
				s_read_req		<= 0;
				if(frame_end_i == 1) begin 
					s_read_start_addr	<= {frame_start_addr_temp, s_pan_v_dly, s_pan_h_dly};
				end
				if(s_read_en_re == 1) begin 
                    if (burst_len_i     >= MAX_BIT_WIDTH ) begin
                        s_count_max	    <= MAX_BIT_WIDTH ;
                        s_hcount	    <= (burst_len_i) - (MAX_BIT_WIDTH) ;
					end else begin
                        s_count_max     <= burst_len_i ;
                        s_hcount  	    <= 0 ;
					end
                        s_state 	    <= READ_TRIG;
				end
			end
			
			READ_TRIG :
			begin 
				if(read_ackn_i == 1) begin
					s_read_req	<= 0;
					s_state 	<= READING;
				end
				else begin 
					s_read_req	<= 1;
				end
			end
			
			READING :
			begin
				if(read_done_i == 1) begin
                    s_state 	                <= BRUST_LEN_CHK;
					{dummy1,s_read_start_addr}	<= s_read_start_addr + c_LINE_GAP;
                end
			end
			
			BRUST_LEN_CHK :
			begin
				if (s_hcount    >= MAX_BIT_WIDTH) begin
					s_count_max <= MAX_BIT_WIDTH ;
					s_hcount	<= s_hcount - MAX_BIT_WIDTH ;
					s_state 	<= READ_TRIG ;
				end
				else if (s_hcount != 0) begin 
					s_count_max <= s_hcount ;
					s_hcount	<= 0  ;
					s_state 	<= READ_TRIG ;
				end else begin
					s_state 	<= IDLE ;
				end
			end
			default :
			begin
					s_state     <= IDLE;
			end
		endcase
	end
end
endmodule