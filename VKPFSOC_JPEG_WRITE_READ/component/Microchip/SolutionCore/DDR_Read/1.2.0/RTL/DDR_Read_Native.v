//=================================================================================================
//-- File Name                           : DDR_Read_Native.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module DDR_Read_Native #( 
        parameter g_HORIZ_RESOL	            = 3840,
        parameter g_DDR_AXI_DWIDTH_I        = 256,
        parameter g_DDR_AXI_DWIDTH_O        = 40,
        parameter g_FRAME_GAP               = 1,
        parameter g_NO_OF_PIXEL             = 4,
        parameter g_DATA_WIDTH	            = 32	
        )
        (
        // Inputs
        input                               reset_i,
        input                               sys_clk_i,
        input                               ddr_clk_i,
        input [15 :0]                       line_gap_i,
        input [15 : 0]                      horz_resl_i,
        input                               frame_end_i,
        input [7  : 0]                      frame_start_addr_i,
        input [11 : 0]                      h_pan_i,
        input [11 : 0]                      v_pan_i,
        input                               read_en_i,
        input                               read_ackn_i,
        input                               read_done_i,
        input                               ddr_data_valid_i,
        input [g_DDR_AXI_DWIDTH_I-1 : 0]    wdata_i,
        // Outputs
        output [31 : 0]                     read_start_addr_o,
        output                              read_req_o,
        output [7 : 0]                      burst_size_o,
        output                              data_valid_o,
        output [g_DATA_WIDTH -1 : 0]        data_o
        );

localparam   g_VIDEO_FIFO_DEPTH      = 2*((g_HORIZ_RESOL*g_DATA_WIDTH)/g_DDR_AXI_DWIDTH_I);
localparam   g_FIFO_AWIDTH           = $clog2(g_VIDEO_FIFO_DEPTH);
//localparam   g_DATA_WIDTH            = (g_DDR_AXI_DWIDTH_O * g_NO_OF_PIXEL);

//=================================================================================================
// Signal declarations
//=================================================================================================
wire [g_DATA_WIDTH-1 : 0]           data_o_net_0               ;
wire                                data_valid_o_net_0         ;
wire [7 : 0]                        brust_hcount_o_net_0       ;
wire [15 : 0]                       beats_to_read_o_net_0      ;
wire                                data_unpacker_0_fifo_read_o;
wire                                read_req_o_net_0           ;
wire [31 : 0]                       read_start_addr_o_net_0    ;
wire [g_DDR_AXI_DWIDTH_I-1 : 0]     video_fifo_0_rdata_o_1     ;
wire                                video_fifo_0_rdata_rdy_o   ;
 
wire                                AND2_0_Y                   ;
 
//=================================================================================================
// Top level output port assignments
//=================================================================================================
 assign read_start_addr_o       = read_start_addr_o_net_0;
 assign read_req_o              = read_req_o_net_0;
 assign burst_size_o            = brust_hcount_o_net_0[7:0];    
 assign data_valid_o            = data_valid_o_net_0;
 assign data_o                  = data_o_net_0;
 
//=================================================================================================
// Asynchronous assignments
//=================================================================================================
 assign AND2_0_Y                = reset_i &(!frame_end_i);
 
//=================================================================================================
// Component instances
//=================================================================================================

//-------------------------------------------------------
// data_unpacker_0   
//-------------------------------------------------------

data_unpacker#(
        .g_DDR_AXI_DWIDTH_I     ( g_DDR_AXI_DWIDTH_I    ),
        .g_DDR_AXI_DWIDTH_O     ( g_DDR_AXI_DWIDTH_O    ),
        .g_NO_OF_PIXEL          ( g_NO_OF_PIXEL         )
        )
    data_unpacker_0( 
        // Inputs
        .reset_i           ( reset_i                    ),
        .resolution_i      ( horz_resl_i               ),
        .disp_clk_i        ( sys_clk_i                  ),
        .read_en_i         ( read_en_i                  ),
        .fifo_data_valid_i ( video_fifo_0_rdata_rdy_o   ),  
        .data_i            ( video_fifo_0_rdata_o_1     ),
        // Outputs
        .data_valid_o      ( data_valid_o_net_0         ),
        .fifo_read_o       ( data_unpacker_0_fifo_read_o),
        .beats_to_read_o   ( beats_to_read_o_net_0      ),
        .data_o            ( data_o_net_0               ) 
        );
        
//-------------------------------------------------------    
// DDR_read_controller_0
//-------------------------------------------------------

DDR_read_controller#(
        .g_FRAME_GAP        (g_FRAME_GAP)
        )
    DDR_read_controller_0( 
        // Inputs
        .reset_i             ( reset_i              ),
        .sys_clk_i           ( ddr_clk_i            ),
        .c_LINE_GAP          ( line_gap_i           ),
        .burst_len_i         ( beats_to_read_o_net_0),
        .read_en_i           ( read_en_i            ),
        .read_ackn_i         ( read_ackn_i          ),
        .read_done_i         ( read_done_i          ),
        .frame_end_i         ( frame_end_i          ),
        .frame_start_addr_i  ( frame_start_addr_i   ),
        .h_pan_i             ( h_pan_i              ),
        .v_pan_i             ( v_pan_i              ),
        // Outputs
        .read_req_o          ( read_req_o_net_0     ),
        .read_start_addr_o   ( read_start_addr_o_net_0),
        .burst_hcount_o      ( brust_hcount_o_net_0 )
        );        
        
//-------------------------------------------------------   
//video_fifo_0 
//-------------------------------------------------------

video_fifo_ddr_read#( 
    .g_VIDEO_FIFO_AWIDTH            ( g_FIFO_AWIDTH              ),
    .g_DDR_AXI_DWIDTH               ( g_DDR_AXI_DWIDTH_I         )
    )
    video_fifo_r( 
        // Inputs
		.aresetn_i	   ( reset_i						),
        .wclock_i      ( ddr_clk_i                      ),
        .wresetn_i     ( AND2_0_Y                       ),
        .wen_i         ( ddr_data_valid_i               ),
        .rclock_i      ( sys_clk_i                      ),
        .reset_i       ( AND2_0_Y                       ),
        .ren_i         ( data_unpacker_0_fifo_read_o    ),
        .wdata_i       ( wdata_i                        ),
        // Outputs
        .wfull_o       (    ),
        .wafull_o      (    ),
        .rdata_rdy_o   ( video_fifo_0_rdata_rdy_o       ),
        .rempty_o      (    ),
        .raempty_o     (    ),
        .rhempty_o     (    ),
        .wdata_count_o (    ),
        .rdata_o       ( video_fifo_0_rdata_o_1         ),
        .rdata_count_o (    ) 
        );     
      
//-------------------------------------------------------   
//synchronizer_circuit_ddr_read
//-------------------------------------------------------

 synchronizer_circuit_ddr_read
  synchronizer_circuit_ddr_read_0(
	// inputs 
	.rstn_i			(reset_i							), 
	.sys_clk		(sys_clk_i							),
	.data_in		(AND2_0_Y							),
	// output
	.sync_out		(sync_out1							)
	);

//-------------------------------------------------------   
//synchronizer_circuit_ddr_read
//-------------------------------------------------------

 synchronizer_circuit_ddr_read
  synchronizer_circuit_ddr_read_1(
	// inputs 
	.rstn_i			(reset_i							), 
	.sys_clk		(ddr_clk_i						),
	.data_in		(AND2_0_Y							),
	// output
	.sync_out		(sync_out2							)
	);
      		
endmodule

