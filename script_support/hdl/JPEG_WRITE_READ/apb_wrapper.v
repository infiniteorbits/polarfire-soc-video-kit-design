////////////////////////////////////////////////////////////////////////////////
// Module      : apb_wrapper
// Description : APB slave interface for JPEG encoder control and status.
//               Address decoding is performed only during an active APB
//               transaction (psel asserted).
////////////////////////////////////////////////////////////////////////////////

module apb_wrapper (
  // APB Interface Signals
  input  wire         pclk,
  input  wire         presetn,
  input  wire         psel,
  input  wire         pwrite,
  input  wire [31:0]  paddr,
  input  wire [31:0]  pwdata,
  output reg  [31:0]  prdata,
  output reg          pready,
  //output wire         pready,
  output wire         pslverr,
  
  // Control FSM
  output wire         i_sof_ps,
  output wire [13:0]  i_w,
  output wire [13:0]  i_h,
  output wire [7:0]   near_val,
  // switch hardware SW1
  input  wire         apb_pin,
  
 //width DDR_Read (i_w + 1)
  output wire [15:0]  horz_resl_o,
 
  // DDR base adress
  output wire [7:0]  ddr_base_addr_o,
  // Status FSM
  input  wire         o_last
);

  // Control registers
  reg [0:0]   reg_sof;
  reg [13:0]  reg_iw;
  reg [13:0]  reg_ih;
  reg [7:0]   reg_near;
  reg [7:0]  reg_ddr_base_addr;   // DDR base address for source data
 

  // Connect control registers to the encoder control interface
  assign i_sof_ps = reg_sof;
  assign i_w      = reg_iw;
  assign horz_resl_o    = {2'b00, reg_iw} + 16'd1; // Horizontal resolution: i_w + 1
  assign ddr_base_addr_o = reg_ddr_base_addr;
  assign i_h      = reg_ih;
  assign near_val     = reg_near;
  assign pready = psel;

  // Synchronize the external SW1 input to the APB clock domain
  reg [1:0] sw1_sync;
  always @(posedge pclk or negedge presetn) begin
      if (~presetn)
          sw1_sync <= 2'b00;
      else
          sw1_sync <= {sw1_sync[0], apb_pin};
  end
  
  // APB protocol handler
  always @(posedge pclk) begin
    if (~presetn) begin
      // Reset all control and status registers
      reg_sof          <= 1'b0;
        reg_iw <= 14'd4; // Default image width
        reg_ih <= 14'd0; // Default image height
      reg_near         <= 8'b0;
      prdata           <= 32'b0;
      pready           <= 1'b0;
     reg_ddr_base_addr <= 7'h00;    
    end else begin
      // Default APB response for each cycle
      pready           <= 1'b0;
      
    // Update SOF control from the synchronized SW1 input
      reg_sof <= sw1_sync[1];
    
      if (psel) begin
        // Process the transaction only when APB select is asserted.
        if (pwrite) begin
          // APB write transaction
          case (paddr[7:0])
            8'h00: begin  // Address 0x00: SOF control
              reg_sof <= pwdata[0];
              pready  <= 1'b1;
            end
            
            8'h04: begin  // Address 0x04: Image width
              reg_iw <= pwdata[15:0];
              pready <= 1'b1;
            end
            
            8'h08: begin  // Address 0x08: Image height
              reg_ih <= pwdata[15:0];
              pready <= 1'b1;
            end
            
            8'h0C: begin  // Address 0x0C: Near parameter
              reg_near <= pwdata[7:0];
              pready   <= 1'b1;
            end
            
            8'h14: begin // Address 0x14: DDR base address
              reg_ddr_base_addr <= pwdata[7:0];   
              pready <= 1; 
            end
            
            default: begin  // Undefined write address
              pready <= 1'b1;
            end
          endcase
          
        end else begin
          // APB read transaction
          case (paddr[7:0])
            8'h10: begin  // Address 0x10: Status register
              prdata <= {31'b0, o_last};
              pready <= 1'b1;
            end
            
            8'h14:   begin // Address 0x14: DDR base address
              prdata <= reg_ddr_base_addr;        
              pready <= 1;
            end
            
            default: begin  // Undefined read address
              prdata <= 32'b0;
              pready <= 1'b1;
            end
          endcase
        end
      end
    end
  end
  
  // APB error response is permanently deasserted
  assign pslverr = 1'b0;

endmodule