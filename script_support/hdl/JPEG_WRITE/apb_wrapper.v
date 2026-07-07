////////////////////////////////////////////////////////////////////////////////
// apb_wrapper.v
// APB slave: control/status 
// Guard all address comparisons inside the psel='1' check so no metavalue ever creeps in.
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
    output wire [15:0]  horz_resl_o,

  // Status FSM
  input  wire         o_last
);

  // Control registers
  reg [0:0]   reg_sof;
  reg [13:0]  reg_iw;
  reg [13:0]  reg_ih;
  reg [7:0]   reg_near;

  // Connect control registers to FSM outputs
  assign i_sof_ps = reg_sof;
  assign i_w      = reg_iw;
  assign i_h      = reg_ih;
  assign near_val     = reg_near;
  assign horz_resl_o    = {2'b00, reg_iw} + 16'd1; // i_w + 1 = largeur relle

  // Sync for SW1
  reg [1:0] sw1_sync;
  always @(posedge pclk or negedge presetn) begin
      if (~presetn)
          sw1_sync <= 2'b00;
      else
          sw1_sync <= {sw1_sync[0], apb_pin};
  end
  always @(posedge pclk)
    $display("reg_sof=%b", reg_sof);
  // Main APB Protocol Handler
  always @(posedge pclk) begin
    if (~presetn) begin
      // Reset all registers and control signals
      reg_sof          <= 1'b0;
      //reg_iw           <= 14'b0;
      //reg_ih           <= 14'b0;
      reg_iw           <= 14'b00000000101101;
      reg_ih           <= 14'b00000000000111;
      reg_near         <= 8'b0;
      prdata           <= 32'b0;
      pready           <= 1'b0;
    
    end else begin
      // Default values for each cycle
      pready           <= 1'b0;
      
    // reg_sof value from SW1 (for debuging)
    reg_sof <= sw1_sync[1];
    
      if (psel) begin
        // APB transaction is active, safe to use address
        if (pwrite) begin
          // APB Write Transaction
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
            
            default: begin  // Undefined write addresses
              pready <= 1'b1;
            end
          endcase
          
        end else begin
          // APB Read Transaction
          case (paddr[7:0])
            8'h10: begin  // Address 0x10: Status register
              prdata <= {31'b0, o_last};
              pready <= 1'b1;
            end
            
            default: begin  // Undefined read addresses
              prdata <= 32'b0;
              pready <= 1'b1;
            end
          endcase
        end
      end
    end
  end
  
  // Never signal APB error
  assign pslverr = 1'b0;

endmodule

