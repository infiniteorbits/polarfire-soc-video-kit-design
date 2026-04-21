/*=================================================================================================
File Name                           : DDR_Write.v

Author                              : India Solutions Team

COPYRIGHT 2021 BY MICROCHIP
THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROCHIP
CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROCHIP FOR USE OF THIS
FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.

=================================================================================================*/
module DDR_Write#(
    parameter g_HORIZ_RESOL	            = 3840,
	parameter g_DDR_AXI_DWIDTH_I        = 8,
	parameter g_DDR_AXI_DWIDTH_O        = 512,
	parameter g_AXI4S_FORMAT            = 1,
	parameter g_FORMAT                  = 1,	// 0= Native and 1= businterface
	parameter g_FRAME_GAP               = 1,
    parameter g_NO_OF_PIXEL             = 4,
    parameter g_DATA_WIDTH              = g_DDR_AXI_DWIDTH_I * g_NO_OF_PIXEL 
	)
    (
    // Inputs
    input                                 rstn_i,
    input                                 pixel_clk_i,
    input                                 ddr_clk_i,
	input 								  ddr_clk_rstn_i,
    input [15 : 0]                        line_gap_i,
    input [7 : 0]                         frame_ddr_addr_i,
    input                                 frame_start_i,
    input                                 write_ackn_i,
    input                                 write_done_i,
    input                                 data_valid_i,
    input [g_DATA_WIDTH-1 : 0]      data_i,
	input                                 AWREADY_I,
    input                                 BUSER_I,
	input [g_DATA_WIDTH-1 : 0]      TDATA_I,
    input                                 TVALID_I,
	input [3:0]                           TUSER_I,
	
    // Outputs
    output                                TREADY_O,	
	output [g_DDR_AXI_DWIDTH_O-1 : 0]	  WDATA_O,
    output                                WVALID_O,
    output [31 : 0]                       AWADDR_O,
    output                                AWVALID_O,
    output [7 : 0]                        AWSIZE_O,
    output [7 : 0]                        burst_size_o,
    output [31 : 0]                       write_start_addr_o,
    output [7  : 0]                       display_frame_addr_o,
    output                                write_req_o,
    output                                data_rdy_o,
    output [g_DDR_AXI_DWIDTH_O-1 : 0]     data_o
    );
	
	wire write_ackn_axi;
	wire write_done_axi;
	wire write_req_axi;
	wire [31 : 0] write_start_addr_axi;
	wire [7 : 0] burst_size_axi;
	wire data_valid_axi;
	wire [g_DDR_AXI_DWIDTH_O-1 : 0] data_axi;
	wire frame_start_axi4s;
	wire data_valid_axi4s;
	wire [g_DATA_WIDTH-1 : 0] data_axi4s;

//	localparam g_Pixel_width = (g_DDR_AXI_DWIDTH_I * g_NO_OF_PIXEL) ;
    
	generate if (g_FORMAT == 0 && g_AXI4S_FORMAT == 0)
	    DDR_Write_Native #(
	             // Parameters
				  .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Write_Native_0
				  (
				  // Input Ports
				  .rstn_i               (rstn_i             ),
                  .sys_clk_i            (pixel_clk_i        ),
                  .ddr_clk_i            (ddr_clk_i          ),
                  .line_gap_i           (line_gap_i         ),
                  .frame_ddr_addr_i     (frame_ddr_addr_i   ),
                  .frame_valid_i        (frame_start_i      ),
                  .write_ackn_i         (write_ackn_i       ),
                  .write_done_i         (write_done_i       ),
                  .data_valid_i         (data_valid_i       ),
                  .data_i               (data_i             ),
                  .ddr_clk_rstn_i       (ddr_clk_rstn_i     ),				  
				  // Output Ports
				  .burst_size_o         (burst_size_o        ),
                  .write_start_addr_o   (write_start_addr_o  ),
                  .display_frame_addr_o (display_frame_addr_o),
                  .write_req_o          (write_req_o         ),
                  .data_rdy_o           (data_rdy_o          ),
                  .data_o               (data_o              )
				  );
	
	else if (g_FORMAT == 0 && g_AXI4S_FORMAT == 1 )
	    DDR_Write_Native #(
	             // Parameters
				  .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Write_Native_1
				  (
				  // Input Ports
				  .rstn_i               (rstn_i            ),
                  .sys_clk_i            (pixel_clk_i        ),
                  .ddr_clk_i            (ddr_clk_i        ),
                  .line_gap_i           (line_gap_i         ),
                  .frame_ddr_addr_i     (frame_ddr_addr_i   ),
                  .frame_valid_i        (frame_start_axi4s    ),
                  .write_ackn_i         (write_ackn_i       ),
                  .write_done_i         (write_done_i       ),
                  .data_valid_i         (data_valid_axi4s   ),
                  .data_i               (data_axi4s       ),
				  .ddr_clk_rstn_i       (ddr_clk_rstn_i        ),
				  // Output Ports
				  .burst_size_o         (burst_size_o        ),
                  .write_start_addr_o   (write_start_addr_o  ),
                  .display_frame_addr_o (display_frame_addr_o),
                  .write_req_o          (write_req_o         ),
                  .data_rdy_o           (data_rdy_o          ),
                  .data_o               (data_o              )
				  );			      	
	
    else if (g_FORMAT == 1 && g_AXI4S_FORMAT == 0)
	    DDR_Write_Native #(
	             // Parameters
				  .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Write_Native_axi_0
				  (
				  // Input Ports
				  .rstn_i              (rstn_i             ),
                  .sys_clk_i            (pixel_clk_i         ),
                  .ddr_clk_i          (ddr_clk_i         ),
                  .line_gap_i           (line_gap_i          ),
                  .frame_ddr_addr_i     (frame_ddr_addr_i    ),
                  .frame_valid_i          (frame_start_i         ),
                  .write_ackn_i         (write_ackn_axi      ),
                  .write_done_i         (write_done_axi      ),
                  .data_valid_i         (data_valid_i        ),
                  .data_i               (data_i              ),
				  .ddr_clk_rstn_i          (ddr_clk_rstn_i        ),
				  // Output Ports
				  .burst_size_o         (burst_size_axi      ),
                  .write_start_addr_o   (write_start_addr_axi),
                  .display_frame_addr_o (display_frame_addr_o),
                  .write_req_o          (write_req_axi       ),
                  .data_rdy_o           (data_valid_axi      ),
                  .data_o               (data_axi            )
				  );
	
	else if (g_FORMAT == 1 && g_AXI4S_FORMAT == 1 )
	    DDR_Write_Native #(
	             // Parameters
				  .g_HORIZ_RESOL	     (g_HORIZ_RESOL	      ), 
                  .g_DDR_AXI_DWIDTH_I    (g_DDR_AXI_DWIDTH_I  ),
                  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  ),
				  .g_FRAME_GAP			 (g_FRAME_GAP         ),
				  .g_NO_OF_PIXEL		 (g_NO_OF_PIXEL       )
				  ) DDR_Write_Native_axi_1
				  (
				  // Input Ports
				  .rstn_i               (rstn_i             ),
                  .sys_clk_i            (pixel_clk_i         ),
                  .ddr_clk_i            (ddr_clk_i         ),
                  .line_gap_i           (line_gap_i          ),
                  .frame_ddr_addr_i     (frame_ddr_addr_i    ),
                  .frame_valid_i        (frame_start_axi4s     ),
                  .write_ackn_i         (write_ackn_axi      ),
                  .write_done_i         (write_done_axi      ),
                  .data_valid_i         (data_valid_axi4s    ),
                  .data_i               (data_axi4s        ),
				  .ddr_clk_rstn_i       (ddr_clk_rstn_i        ),
				  // Output Ports
				  .burst_size_o         (burst_size_axi      ),
                  .write_start_addr_o   (write_start_addr_axi),
                  .display_frame_addr_o (display_frame_addr_o),
                  .write_req_o          (write_req_axi       ),
                  .data_rdy_o           (data_valid_axi      ),
                  .data_o               (data_axi            )
				  );
                      
	endgenerate
	
	generate if (g_FORMAT == 1)
         	Arbiter_Initiator_Wr_IF #(
				  .g_DDR_AXI_DWIDTH_O    (g_DDR_AXI_DWIDTH_O  )
				  ) ARBITER_INITIATOR_WR_IF_0
				  (
				  // Input Ports
				  .CLOCK_I     (ddr_clk_i),
                  .RESET_n_I   (rstn_i),
                  .DATA_I      (data_axi),
                  .DATA_VALID_I(data_valid_axi),
                  .START_ADDR_I(write_start_addr_axi),
                  .REQ_I       (write_req_axi),
                  .BURST_SIZE_I(burst_size_axi),
                  .AWREADY_I   (AWREADY_I),
                  .BUSER_I     (BUSER_I),
				  // Output Ports
                  .WDATA_O     (WDATA_O),
                  .WVALID_O    (WVALID_O),
                  .AWADDR_O    (AWADDR_O),
                  .AWVALID_O   (AWVALID_O),
                  .AWSIZE_O    (AWSIZE_O),
                  .W_DONE_O    (write_done_axi),
                  .W_ACK_O     (write_ackn_axi)
				  );
	endgenerate
	
	generate if (g_AXI4S_FORMAT == 1 )					
	        AXI4S_ddr_write_target_IF #(
				 // Parameters
				 .g_DDR_AXI_DWIDTH_I		(g_DATA_WIDTH)
				 ) AXI4S_ddr_write_target_IF_0
				 (
				 //Input Ports
				 .TDATA_I      (TDATA_I),
				 .TVALID_I     (TVALID_I),
				 .TUSER_I      (TUSER_I),
				 //Output Ports
				 .TREADY_O     (TREADY_O),
				 .DATA_O       (data_axi4s),
				 .FRAME_VALID_O(),
				 .DATA_VALID_O (data_valid_axi4s),
				 .FRAME_END_O  (frame_start_axi4s)
				 );
	endgenerate
    
    
	endmodule