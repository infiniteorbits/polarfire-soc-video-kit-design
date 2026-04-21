//=================================================================================================
//-- File Name                           : DDR_Read.v

//-- Targeted device                     : Microchip
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2021 BY MICROCHIP
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module DDR_Read#( 
        parameter g_HORIZ_RESOL	            = 3840,
        parameter g_DDR_AXI_DWIDTH_I        = 512,
        parameter g_DDR_AXI_DWIDTH_O        = 8,
		parameter g_AXI4S_FORMAT            = 1,            // 0= Native and 1= AXI4 Stream Interface
		parameter g_FORMAT                  = 1,			// 0= Native and 1= bus interface
		parameter g_DDR_AXI_AWIDTH			= 32,
		parameter g_FRAME_GAP               = 1,
		parameter g_NO_OF_PIXEL             = 4,
        parameter g_DATA_WIDTH              = g_DDR_AXI_DWIDTH_O * g_NO_OF_PIXEL 
		)
        (
        // Inputs
        input                                   reset_i,
        input                                   pixel_clk_i,
        input                                   ddr_clk_i,
        input [15 :0]                           line_gap_i,
        input [15 : 0]                          horz_resl_i,
        input                                   frame_start_i,
        input [7  : 0]                          frame_start_addr_i,
        input [11 : 0]                          h_offset_i,
        input [11 : 0]                          v_offset_i,
        input                                   read_en_i,
        input                                   read_ackn_i,
        input                                   read_done_i,
        input                                   ddr_data_valid_i,
        input [g_DDR_AXI_DWIDTH_I-1 : 0]        wdata_i,
		input [g_DDR_AXI_DWIDTH_I-1 : 0]        RDATA_I,
        input                                   RVALID_I,
		input                                   ARREADY_I,
        input                                   BUSER_I,
        // Outputs                              
		output [31 : 0]                         ARADDR_O,
        output                                  ARVALID_O,
        output [7:0]                            ARSIZE_O,
        output [g_DDR_AXI_AWIDTH-1 : 0]         read_start_addr_o,
        output                                  read_req_o,
        output [7 : 0]                          burst_size_o,
        output                                  data_valid_o,
        output [g_DATA_WIDTH-1 : 0]       data_o,
		output [g_DATA_WIDTH - 1 : 0]	    TDATA_O,
        output [g_DATA_WIDTH/8 - 1 : 0]   TSTRB_O,
        output [g_DATA_WIDTH/8 - 1 : 0]   TKEEP_O,
        output 								    TVALID_O,
        output									TLAST_O,
        output [3 : 0]							TUSER_O
		
        );
		
		wire read_ackn_axi;
		wire read_done_axi;
		wire ddr_data_valid_axi;
		wire [g_DDR_AXI_DWIDTH_I-1 : 0] data_axi;
		wire [g_DDR_AXI_AWIDTH-1:0] read_start_addr_axi;
		wire read_req_axi;
		wire [7:0] burst_size_axi;
		wire data_valid_axi4s;
		wire [g_DATA_WIDTH-1 : 0] data_axi4s;
		wire [31 : 0] data_axi4s_24;
		wire [31:0] w_data_1;
		wire [31:0] w_data_2;
	
		generate if (g_FORMAT == 0 && g_AXI4S_FORMAT == 0)
		    DDR_Read_Native #( 
			      .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_DATA_WIDTH			 (g_DATA_WIDTH        ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Read_Native_0
				  (
				  // Input Ports
				  .reset_i           (reset_i),
                  .sys_clk_i         (pixel_clk_i),
                  .ddr_clk_i         (ddr_clk_i),
                  .line_gap_i        (line_gap_i),
                  .horz_resl_i       (horz_resl_i),
                  .frame_end_i       (frame_start_i),
                  .frame_start_addr_i(frame_start_addr_i),
                  .h_pan_i           (h_offset_i),
                  .v_pan_i           (v_offset_i),
                  .read_en_i         (read_en_i),
                  .read_ackn_i       (read_ackn_i),
                  .read_done_i       (read_done_i),
                  .ddr_data_valid_i  (ddr_data_valid_i),
                  .wdata_i           (wdata_i),
				  // Output Ports
				  .read_start_addr_o  (read_start_addr_o),
                  .read_req_o         (read_req_o),
                  .burst_size_o       (burst_size_o),
                  .data_valid_o       (data_valid_o),
                  .data_o             (data_o)
				  );
		
		else if (g_FORMAT == 0 && g_AXI4S_FORMAT == 1)
		    DDR_Read_Native #( 
			      .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_DATA_WIDTH			 (g_DATA_WIDTH        ),				  
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Read_Native_1
				  (
				  // Input Ports
				  .reset_i           (reset_i),
                  .sys_clk_i         (pixel_clk_i),
                  .ddr_clk_i         (ddr_clk_i),
                  .line_gap_i        (line_gap_i),
                  .horz_resl_i       (horz_resl_i),
                  .frame_end_i       (frame_start_i),
                  .frame_start_addr_i(frame_start_addr_i),
                  .h_pan_i           (h_offset_i),
                  .v_pan_i           (v_offset_i),
                  .read_en_i         (read_en_i),
                  .read_ackn_i       (read_ackn_i),
                  .read_done_i       (read_done_i),
                  .ddr_data_valid_i  (ddr_data_valid_i),
                  .wdata_i           (wdata_i),
				  // Output Ports
				  .read_start_addr_o  (read_start_addr_o),
                  .read_req_o         (read_req_o),
                  .burst_size_o       (burst_size_o),
                  .data_valid_o       (data_valid_axi4s),
                  .data_o             (data_axi4s)
				  );		
		else if (g_FORMAT == 1 && g_AXI4S_FORMAT == 0)
		    DDR_Read_Native #( 
			      .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_DATA_WIDTH			 (g_DATA_WIDTH        ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Read_Native_5
				  (
				  // Input Ports
				  .reset_i           (reset_i),
                  .sys_clk_i         (pixel_clk_i),
                  .ddr_clk_i         (ddr_clk_i),
                  .line_gap_i        (line_gap_i),
                  .horz_resl_i       (horz_resl_i),
                  .frame_end_i       (frame_start_i),
                  .frame_start_addr_i(frame_start_addr_i),
                  .h_pan_i           (h_offset_i),
                  .v_pan_i           (v_offset_i),
                  .read_en_i         (read_en_i),
                  .read_ackn_i       (read_ackn_axi),
                  .read_done_i       (read_done_axi),
                  .ddr_data_valid_i  (ddr_data_valid_axi),
                  .wdata_i           (data_axi),
				  // Output Ports
				  .read_start_addr_o  (read_start_addr_axi),
                  .read_req_o         (read_req_axi),
                  .burst_size_o       (burst_size_axi),
                  .data_valid_o       (data_valid_o),
                  .data_o             (data_o)
				  );		
		else if (g_FORMAT == 1 && g_AXI4S_FORMAT == 1 )
		    DDR_Read_Native #( 
			      .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_DATA_WIDTH			 (g_DATA_WIDTH        ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Read_Native_6
				  (
				  // Input Ports
				  .reset_i           (reset_i),
                  .sys_clk_i         (pixel_clk_i),
                  .ddr_clk_i         (ddr_clk_i),
                  .line_gap_i        (line_gap_i),
                  .horz_resl_i       (horz_resl_i),
                  .frame_end_i       (frame_start_i),
                  .frame_start_addr_i(frame_start_addr_i),
                  .h_pan_i           (h_offset_i),
                  .v_pan_i           (v_offset_i),
                  .read_en_i         (read_en_i),
                  .read_ackn_i       (read_ackn_axi),
                  .read_done_i       (read_done_axi),
                  .ddr_data_valid_i  (ddr_data_valid_axi),
                  .wdata_i           (data_axi),
				  // Output Ports
				  .read_start_addr_o  (read_start_addr_axi),
                  .read_req_o         (read_req_axi),
                  .burst_size_o       (burst_size_axi),
                  .data_valid_o       (data_valid_axi4s),
                  .data_o             (data_axi4s)
				  );
				  
		endgenerate
		
		generate if (g_FORMAT == 1)
		    Arbiter_Initiator_Rd_IF #(
			     .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  )
				 ) ARBITER_INITIATOR_RD_IF_0
				 (
				 // Input Ports
				 .RDATA_I     (RDATA_I),
                 .RVALID_I    (RVALID_I),
                 .START_ADDR_I(read_start_addr_axi),
                 .REQ_I       (read_req_axi),
                 .BURST_SIZE_I(burst_size_axi),
                 .ARREADY_I   (ARREADY_I),
                 .BUSER_I     (BUSER_I),
				 //Output Ports
				 .DATA_O       (data_axi),
                 .DATA_VALID_O (ddr_data_valid_axi),
                 .ARADDR_O     (ARADDR_O),
                 .ARVALID_O    (ARVALID_O),
                 .ARSIZE_O     (ARSIZE_O),
                 .R_DONE_O     (read_done_axi),
                 .R_ACK_O      (read_ackn_axi)
				 );
	    endgenerate
		
		generate if (g_AXI4S_FORMAT == 1)					
	        AXI4S_ddr_read_initiator_IF #(
				 // Parameters
				 .g_DDR_AXI_DWIDTH_O		(g_DATA_WIDTH)
				 ) AXI4S_ddr_read_initiator_0
				 (
				 //Input Ports
				 .CLOCK_I		(pixel_clk_i),
				 .RESET_n_I		(reset_i),
				 .DATA_I	    (data_axi4s),
				 .DATA_VALID_I	(data_valid_axi4s),
				 .EOF_I			(frame_start_i),
				 //Output Ports
				 .TDATA_O  (TDATA_O),
				 .TSTRB_O  (TSTRB_O),
				 .TKEEP_O  (TKEEP_O), 
				 .TVALID_O (TVALID_O),
                 .TLAST_O  (TLAST_O),
                 .TUSER_O  (TUSER_O)
				 );
        endgenerate
		endmodule