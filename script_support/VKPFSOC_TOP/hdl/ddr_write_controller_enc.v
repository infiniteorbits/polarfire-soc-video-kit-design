////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, Microchip Corporation
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL MICROCHIP CORPORATIONM BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// APACHE LICENSE
// Copyright (c) 2022, Microchip Corporation 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////

module ddr_write_controller_enc #(parameter g_DDR_AXI_AWIDTH = 32) (
    input              reset_i,       //System Reset
    input              sys_clk_i,     // System clock
    input              wrclk_reset_i, //Write clock reset
    input              wrclk_i,       //Write clock 
    input      [11:0]  fifo_count_i,  //Fifo count
    input              eof_i,         //End of Frame
    
    //from apb wrapper
    input              encoder_en_i,  //enable or start

    input              write_ackn_i,  //Write Acknowledgement
    input              write_done_i,  //Write Done
    input      [9:0]   frame_ddr_addr_i, //Frame address to write
    output             fifo_reset_o,  //fifo reset
    
    output wire        read_fifo_o,    //Read Request to FIFO
    output wire        frm_interrupt_o,//interrupt to MSS
    
    //to arbiter
    output wire                        write_req_o, //Write Request to DDR
    output wire [g_DDR_AXI_AWIDTH-1:0] write_start_addr_o, //DDR memory address to write data
    output wire [7:0]                  write_length_o  //Write Burst size

    );

  localparam  IDLE = 2'b00,
              WRITE_REQUESTING = 2'b01,
              WRITING = 2'b10;
  localparam DDR_BASE_OFFSET = 32'h8800_0000; //DDR base address offset for writing data
  reg  [1:0]   s_state;
  reg          s_eof_wrclk;
  reg  [9:0]   s_eof_sync_reg;
  reg          s_eof_reg;
  wire         s_set_eof_reg;
  reg          s_clr_eof_reg;
  reg          s_write_req;
  reg          s_read_fifo;
  wire[g_DDR_AXI_AWIDTH-1:0] s_write_start_addr;
  reg [8:0]   s_counter;
  reg [8:0]   s_count_max;
  reg [19:0]   s_line_counter;
  reg          s_frm_intr;
  reg          s_last_data_in_frame;
  reg          encoder_en_dly1;
  reg [3:0]    s_clr_eof_cnt;
  reg          frm_sz_vld;
  reg [g_DDR_AXI_AWIDTH-1:0] wr_addr_ptr; // compute the write address pointer based on the frame_ddr_addr_i and line counter
  reg addr_init_done; 


//assign frame_ddr_addr_i = 10'd0; // adresse de dpart = 0
assign write_req_o          = s_write_req;
//assign write_start_addr_o   = s_write_start_addr;
assign write_start_addr_o = wr_addr_ptr;
assign write_length_o       = s_count_max - 1'b1;
assign read_fifo_o          = s_read_fifo;
assign frm_interrupt_o      = s_frm_intr;
assign fifo_reset_o         = ~(encoder_en_i & (~ encoder_en_dly1));
//assign s_write_start_addr   = {frame_ddr_addr_i[9:0], s_line_counter};
assign s_set_eof_reg        = s_eof_sync_reg[9] & (~s_eof_sync_reg[8]) ; //neg edge

/*------------------------------------------------------------------------
-- Name       : EOF_SYNC
-- Description: Process to delay signal and find rising edge
------------------------------------------------------------------------*/
  always @( posedge wrclk_i or  negedge wrclk_reset_i)
  begin
    if (!wrclk_reset_i)   
      s_eof_wrclk <= 1'b0;
    else
      s_eof_wrclk <= eof_i;
  end
/*------------------------------------------------------------------
--  Write Address Pointer Management
--------------------------------------------------------------------*/
 always @(posedge sys_clk_i or negedge reset_i) begin
    if (!reset_i) begin
        //wr_addr_ptr     <= 0;
        wr_addr_ptr     <= DDR_BASE_OFFSET;
        addr_init_done  <= 1'b0;
    end else begin

        // Initialize the write address pointer at the beginning of a frame when the encoder is enabled and there is data in the FIFO
        if (!addr_init_done && s_state == IDLE && encoder_en_i && fifo_count_i > 0) begin
            //wr_addr_ptr    <= frame_ddr_addr_i << 3; // 8 bytes per DDR word
            wr_addr_ptr    <= DDR_BASE_OFFSET + (frame_ddr_addr_i << 3); 
            addr_init_done <= 1'b1;
        end
        else if (write_done_i && s_state == WRITING) begin
            wr_addr_ptr <= wr_addr_ptr + (s_count_max << 3); 
        end

        // Reset the write address pointer when the end of frame is cleared
        if (s_clr_eof_reg) begin
            addr_init_done <= 1'b0;
            //wr_addr_ptr    <= 0; // reset for next frame
            wr_addr_ptr    <= DDR_BASE_OFFSET;
        end
    end
end


///-----------------------------------------------------------------------------
// INTR_GEN: Generate frame done interrupt (auto-clear with timer + FSM ready)
//-----------------------------------------------------------------------------
reg [7:0] intr_timer;  // Counter for auto-clear of interrupt

always @ (posedge sys_clk_i or negedge reset_i)
begin
    if (!reset_i) begin
        s_frm_intr <= 1'b0;
        intr_timer <= 8'd0;
    end else begin
        // Set the interrupt when the end of frame is detected and the encoder is enabled
        if (s_set_eof_reg && encoder_en_i) begin
            s_frm_intr <= 1'b1;
            intr_timer <= 8'd0;
        end
        // Clear the interrupt either after a certain number of cycles or when the FSM is idle and the FIFO is empty
        else if (s_frm_intr) begin
            intr_timer <= intr_timer + 1'b1;

            // Auto-clear after a certain number of cycles (e.g., 10 cycles, adjust as needed)
            if (intr_timer >= 8'd10)  
                s_frm_intr <= 1'b0;

            // Or clear if the FSM is IDLE and FIFO is empty
            if (s_state == IDLE && fifo_count_i == 0)
                s_frm_intr <= 1'b0;
        end
        else if (s_frm_intr) begin
            intr_timer <= intr_timer + 1'b1;

            // Auto-clear aprs un certain nombre de cycles
            if (intr_timer >= 8'd10)  // par exemple 10 cycles,  ajuster
                s_frm_intr <= 1'b0;

            // Ou clear si le FSM est IDLE et FIFO vide
            if (s_state == IDLE && fifo_count_i == 0)
                s_frm_intr <= 1'b0;
        end
    end
end

/*------------------------------------------------------------------------
-- Name       : SIGNAL_DELAY
-- Description: Process to delay signal and find rising edge
------------------------------------------------------------------------*/
  always @ (posedge sys_clk_i or negedge reset_i)
  begin
	if (!reset_i) begin
		s_eof_sync_reg     <= 0 ;
		s_eof_reg          <= 1'b0 ;
        encoder_en_dly1    <= 1'b0 ;
	end
	else begin
		s_eof_sync_reg     <= {s_eof_sync_reg[8:0], s_eof_wrclk | eof_i} ;
        encoder_en_dly1    <= encoder_en_i;
		if (s_set_eof_reg)      s_eof_reg <= 1'b1;
		else if (s_clr_eof_reg) s_eof_reg <= 1'b0;
	end
  end

/*------------------------------------------------------------------------
-- Name       : Write_FSM_PROC
-- Description: Controls the DDR write transaction sequence.
--              The FSM requests data from the FIFO and manages AXI write
--              request and completion handshaking.
------------------------------------------------------------------------*/
  always @ (posedge sys_clk_i or negedge reset_i)
  begin
	if (!reset_i) begin
		s_state              <= IDLE;
		s_write_req          <= 1'b0;
		s_read_fifo          <= 1'b0;
		s_count_max          <= 0 ;
		s_counter            <= 0 ;     
		s_line_counter       <= 20'd0 ;
		s_last_data_in_frame <= 1'b0 ;
		s_clr_eof_reg        <= 1'b0;
    end
	else begin                         
		case({s_state})
			IDLE : begin
				s_write_req <= 1'b0 ;
				s_read_fifo <= 1'b0 ;
				s_counter   <= 0 ;		

                // 1. Handle end-of-frame cleanup.
                // When EOF is received and the FIFO is empty, assert the cleanup flag.
                s_clr_eof_reg <= s_eof_reg && (fifo_count_i == 0);

                if (s_clr_eof_reg || !encoder_en_i) begin
                    s_line_counter <= 0;
                end
                
                // 2. Burst request condition.
                // Start a write when:
                // - End-of-frame data remains in the FIFO, or
                // - The FIFO contains enough data for an efficient burst.
                
                if (!s_clr_eof_reg && ((s_eof_reg && |fifo_count_i) || (fifo_count_i >= 12'd16))) begin
                    
                    // 3. Calculate the burst length.
                    if (fifo_count_i > 256) begin
                        s_count_max <= 9'd256; // Maximum AXI4 burst length
                    end else begin
                        s_count_max <= fifo_count_i[8:0];
                    end
                    // 4. Transition to the write-request state.
                    s_state              <= WRITE_REQUESTING;
                    s_last_data_in_frame <= s_eof_reg; 
                end
			end
			WRITE_REQUESTING : begin
				if(write_ackn_i) begin
					s_write_req <= 1'b0;
					s_state     <= WRITING;
				end
				else begin
					s_write_req <= 1'b1 ;
				end
			end
                
			WRITING : begin
				if(write_done_i) begin     
					s_read_fifo    <= 1'b0;
					s_state        <= IDLE;
					s_clr_eof_reg  <= s_last_data_in_frame;
				end
				else if(s_counter >= s_count_max) begin
					s_read_fifo <= 1'b0;
				end
				else begin
					s_counter   <= s_counter + 1'b1;
					s_read_fifo <= 1'b1;
				end
			end
			default : s_state <= IDLE;
		endcase
	end
end

/*------------------------------------------------------------------------
-- Name       : s_clr_eof_cnt
-- Description: frm sz valid
------------------------------------------------------------------------*/
  always @ (posedge sys_clk_i or negedge reset_i)
  begin
	if (!reset_i) begin
      s_clr_eof_cnt  <= 0;
      frm_sz_vld     <= 0;
    end
    else begin
      if (s_clr_eof_reg)
        s_clr_eof_cnt  <= 1;
      else if (s_clr_eof_cnt != 0)
        s_clr_eof_cnt  <= s_clr_eof_cnt + 1;
        
      if (s_clr_eof_cnt > 3)
        frm_sz_vld  <= 1;
      else
        frm_sz_vld  <= 0;
    end 
  end   

endmodule
