
//=================================================================================================
//-- File Name                           : data_unpacker.v

//-- Targeted device                     : Microsemi-SoC
//-- Author                              : India Solutions Team
//--
//-- COPYRIGHT 2019 BY MICROSEMI
//-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
//-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
//-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
//--
//=================================================================================================
module data_unpacker #(  
	parameter g_DDR_AXI_DWIDTH_I = 128,
	parameter g_DDR_AXI_DWIDTH_O = 96,
    parameter g_NO_OF_PIXEL      = 4,
    parameter g_DATA_WIDTH       = g_DDR_AXI_DWIDTH_O * g_NO_OF_PIXEL
    )
	(
	// System reset
    input	reset_i,

    // Display clock
    input 	disp_clk_i,

    // Read enable signal from DDR
    input 	read_en_i,

    // data ready from FIFO
    input	fifo_data_valid_i,

    // Data Input
    input	[g_DDR_AXI_DWIDTH_I-1 : 0]	data_i,
    
    input   [15 : 0]  resolution_i,

    // data output valid
    output	reg data_valid_o,

    // Read request for FIFO
    output fifo_read_o,

    // Number of 128 bit packets to read 
    output  [15 : 0]	beats_to_read_o,
    
    // Data output
    output [g_DATA_WIDTH -1 : 0] data_o
    );
    
    
//=================================================================================================
// Signal declarations
//=================================================================================================
reg  [15 : 0]                   s_packet_counter;
reg  [7  : 0]					s_mod_read_counter;
wire [15 : 0]					s_line_count_max;
reg  [15 : 0]					s_line_counter;
reg  [g_DDR_AXI_DWIDTH_I-1 : 0] s_data_pack;
reg  [g_DATA_WIDTH-1 : 0]      s_data_unpacked;
reg  							s_read_latch;
reg                             s_read_latch_dly;
wire                            s_read_latch_fe;
reg  							s_read_fifo;
reg  							s_ddr_read_en_dly;
reg  							s_ddr_read_en_dly2;
wire 							s_ddr_read_en_fe;

reg  [15:0]                     brust_len_latch ;
reg  [15:0]                     brust_len;
reg  [7:0]                      brust_len_check ;
wire [15:0]                     horz_resl_i;

//=================================================================================================
// Parameter declarations
//================================================================================================= 
localparam CNTR_MOD           = (g_NO_OF_PIXEL == 4) ? g_DDR_AXI_DWIDTH_I/g_DATA_WIDTH : 
                                    g_DDR_AXI_DWIDTH_I < (g_DATA_WIDTH*4) ? g_DDR_AXI_DWIDTH_I/g_DATA_WIDTH : (g_DDR_AXI_DWIDTH_I/(g_DATA_WIDTH*4))*4;
localparam c_len              = 8192/CNTR_MOD ;
localparam shift_bits         = $clog2(8192) ;
localparam C_EQUAL_DW         = (CNTR_MOD == 1)? 1'b1 : 1'b0;
//=================================================================================================
// Top level output port assignments
//=================================================================================================
assign  data_o              = s_data_unpacked;
assign	fifo_read_o         = s_read_fifo;
assign  beats_to_read_o     = brust_len_latch ;  
assign  horz_resl_i         = resolution_i;
//=================================================================================================
// Asynchronous blocks
//=================================================================================================
assign s_line_count_max     = brust_len_latch ; 
assign s_ddr_read_en_fe     = s_ddr_read_en_dly2 & (!(s_ddr_read_en_dly));  
assign s_read_latch_fe      = s_read_latch_dly & (!s_read_latch) ;
//=================================================================================================
// Synchronous blocks
//================================================================================================= 
always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		brust_len <= 0 ;
        brust_len_check <= 0 ;
    end
    else begin
        brust_len           <= ((horz_resl_i*c_len)>> shift_bits) ;
        brust_len_check     <= (horz_resl_i - (brust_len*CNTR_MOD));
    end
    end
//--------------------------------------------------------------------------
//Name       : Brust_length
//Description: Brust length calulation 
//--------------------------------------------------------------------------
always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		brust_len_latch <= 0 ;
    end
    else begin 
        if(brust_len_check > CNTR_MOD) begin
        brust_len_latch <= brust_len + 2 ;
    end
    else if( brust_len_check != 0) begin
        brust_len_latch <= brust_len + 1 ;
    end
    else
        brust_len_latch <= brust_len ;
    end
    end
    
//--------------------------------------------------------------------------
// Name       : DELAY_PROC_DISP_CLK
// Description: Generate the delayed signals
//--------------------------------------------------------------------------   
always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_ddr_read_en_dly  	<= 0;
		s_ddr_read_en_dly2 	<= 0;
	end
	else begin 
		s_ddr_read_en_dly  	<= read_en_i;
		s_ddr_read_en_dly2 	<= s_ddr_read_en_dly;
        s_read_latch_dly    <= s_read_latch ;
	end
end  
//--------------------------------------------------------------------------
// Name       : READING_PROC
// Description: Generate read FIFO signals
//--------------------------------------------------------------------------  
always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_read_latch        <= 0;
		s_read_fifo         <= 0;
        s_mod_read_counter  <= 0;
        s_packet_counter    <= 0;
	end
	else begin 
		if(s_ddr_read_en_fe == 1) begin 
          s_read_latch <= 1;
		end
        else if(s_line_counter == s_line_count_max-C_EQUAL_DW) begin 
            s_read_latch       <= 0;
        end
        if(s_read_latch == 1 ) begin
            if (s_mod_read_counter < CNTR_MOD -1)
                s_mod_read_counter <= s_mod_read_counter + 1;
            else  
                s_mod_read_counter <= 0;
            if(s_mod_read_counter == 0  && s_line_counter < s_line_count_max-C_EQUAL_DW )  
                s_read_fifo     <= 1;             
            else  
                s_read_fifo     <= 0;
        end
        else begin
			s_read_fifo         <= 0;
            s_mod_read_counter  <= 0;
        end
        if (data_valid_o == 1) begin
            if (s_packet_counter <= horz_resl_i - 1)
            s_packet_counter <= s_packet_counter + 1 ;
        end
        if(s_ddr_read_en_dly2 && s_ddr_read_en_fe )
            s_packet_counter <= 1'b0 ;
	end
end  
     
//--------------------------------------------------------------------------
// Name       : DATA_ASSIGN
// Description: Process assigns data based on counter value
//--------------------------------------------------------------------------   
generate if(g_DDR_AXI_DWIDTH_I != g_DATA_WIDTH) begin
  always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_data_pack      <= 0;
		s_line_counter   <= 0;
		s_data_unpacked  <= 0;
		data_valid_o     <= 0;
	end
	else begin
		if(s_read_fifo == 1)begin
          s_line_counter   <= s_line_counter + 1;
        end
        else if(s_read_latch == 0) begin
            s_line_counter <= 0;  
        end 
        
		if(fifo_data_valid_i == 1)begin
          s_data_pack      <= {{(g_DATA_WIDTH){1'b0}},data_i[g_DDR_AXI_DWIDTH_I-1 : g_DATA_WIDTH]};
          s_data_unpacked  <= data_i[g_DATA_WIDTH-1 : 0];            
          data_valid_o     <= 1;
		end
		else begin
          if(data_valid_o == 1) begin
		  	s_data_pack      <= {{(g_DATA_WIDTH){1'b0}},s_data_pack[g_DDR_AXI_DWIDTH_I-1 : g_DATA_WIDTH]};
		  	s_data_unpacked  <= s_data_pack[g_DATA_WIDTH-1 : 0];
          end
          else begin
		  	s_data_unpacked  <= 0;
          end
          
          if (s_packet_counter >= horz_resl_i - 1) begin
              data_valid_o <= 0;
          end
		end
	end
  end
end
else begin
  always@(posedge disp_clk_i, negedge reset_i) begin 
	if(!reset_i) begin 
		s_line_counter   <= 0;
		s_data_unpacked  <= 0;
		data_valid_o     <= 0;
	end
	else begin
		if(s_read_fifo == 1)begin
          s_line_counter   <= s_line_counter + 1;
        end
        else if(s_read_latch == 0) begin
            s_line_counter <= 0;  
        end 
        
		if(fifo_data_valid_i == 1)begin
          s_data_unpacked      <= data_i;        
          data_valid_o         <= 1;
		end
        else begin
		  s_data_unpacked  <= 0;                 
          if (s_packet_counter >= horz_resl_i - 1) begin
              data_valid_o <= 0;
          end
		end
	end
  end
end
endgenerate

endmodule

