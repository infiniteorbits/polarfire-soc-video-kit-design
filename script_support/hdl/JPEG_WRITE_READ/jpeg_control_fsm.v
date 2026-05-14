// jpeg_control_fsm_fixed.v
// CORRECTIONS :
//   [1] reading mis  1 ds l'entre en FEED_PIXELS
//   [2] read_en_i gnre des PULSES (1 cycle ON / 1 cycle OFF)
//       et s'arrte quand tous les pixels sont demands
//   [3] pixel_valid_hold sans condition sur `reading`
//   [4] read_counter et pixel_count bien spars
//       read_counter = pixels demands au DDR_Read
//       pixel_count  = pixels envoys au JLS encoder
module jpeg_control_fsm #(
    parameter ADDR_WIDTH = 3,
    parameter LINE_STORAGE_MODE = 1'b0
)(
    input  wire         clk,
    input  wire         rstn,

    input  wire         i_sof_ps,
    input  wire [13:0]  i_w,
    input  wire [13:0]  i_h,
    input  wire [7:0]   near,

    // JPEG core
    output reg          i_sof,
    output reg          i_e,
    output reg  [7:0]   i_x,

    input  wire [15:0]  o_data,
    input  wire         o_e,
    input  wire         o_last,

    output reg  [15:0]  o_data_pck,
    output reg          o_e_pck,

    output reg          sof_flag,
    output reg          eof_flag,

    // Read interface vers DDR_Read
    input wire           read_ackn_i,
    input wire           read_done_i,
    output reg          read_en_i,       // pulse vers DDR_Read.read_en_i
    output reg          frame_start_i,   // pulse vers DDR_Read.frame_start_i
    input wire [15:0]    horz_resl_o,
    output wire [15:0]    line_gap_o,
    input  wire [7:0]   ram_read_data,
    input  wire         ram_data_valid,
    output reg          o_last_flag,
    output reg          encoder_active_o
);

    //============================
    // TATS FSM
    //============================
    localparam IDLE        = 3'd0;
    localparam SOF_PULSE   = 3'd1;
    localparam FEED_PIXELS = 3'd2;
    localparam FINISH      = 3'd3;

    reg [2:0] state, next_state;

    //============================
    // REGISTRES
    //============================
    reg [31:0] total_pixels;
    reg [31:0] pixel_count;    // pixels envoys au JLS encoder
    reg [31:0] read_counter;   // pixels demands au DDR_Read
    reg [13:0] width_reg, height_reg;
    reg [8:0]  sof_counter;
    reg [8:0]  idle_counter;
    reg        pixels_done;
    reg        last_seen;
    reg        encoder_active;
    reg [7:0] pixel_hold;
    reg       pixel_valid_hold;
        reg [7:0] ram_data_d;
    reg       ram_valid_d;
    reg read_en_i_d; 
    reg read_phase; 
   
    reg [31:0] total_beats;
    //============================
    // TOTAL PIXELS
    //============================
    wire [47:0] total_pixels_comb;
    assign total_pixels_comb = ({34'd0, i_w} + 1) * ({34'd0, i_h} + 1);
   //============================
    // line_gap
    //============================
  // LINE_STORAGE_MODE:
    // 0 = compact storage, no padding between lines (lignes stockes bout  bout, sans trou)
    // 1 = padded storage, round each line up to a 64-bit word boundary (lignes arrondies au multiple de 8 octets, pratique pour le bus DDR 64 bits)
    assign line_gap_o = (LINE_STORAGE_MODE == 1'b0)
                      ? horz_resl_o
                      : ((horz_resl_o + 16'd7) & 16'hFFF8);
   
   //============================
    // frame_start_i / read_en_i
    //============================
  reg [13:0] read_line_count;
  reg [13:0] read_pixel_timer;
  reg [7:0]  read_gap_timer;
  reg [1:0]  read_state;
  reg [2:0]  frame_start_cnt;
  reg        frame_start_done;

  localparam RD_IDLE = 2'd0;
  localparam RD_LINE = 2'd1;
  localparam RD_GAP  = 2'd2;

  wire [13:0] width_pixels;
  wire [13:0] height_lines;

  assign width_pixels = width_reg + 14'd1;
  assign height_lines = height_reg + 14'd1;

  always @(posedge clk or negedge rstn) begin
      if (!rstn) begin
          read_en_i        <= 1'b0;
          read_line_count  <= 14'd0;
          read_pixel_timer <= 14'd0;
          read_gap_timer   <= 8'd0;
          read_state       <= RD_IDLE;
          frame_start_i    <= 1'b0;
          frame_start_cnt  <= 3'd0;
          frame_start_done <= 1'b0;
      end else begin
        if (state == IDLE) begin
              read_en_i        <= 1'b0;
              frame_start_i    <= 1'b0;
              read_line_count  <= 14'd0;
              read_pixel_timer <= 14'd0;
              read_gap_timer   <= 8'd0;
              read_state       <= RD_IDLE;
              frame_start_cnt  <= 3'd0;
              frame_start_done <= 1'b0;
          end else if (state != FEED_PIXELS || !encoder_active || pixels_done) begin
              read_en_i        <= 1'b0;
              frame_start_i    <= 1'b0;
              read_pixel_timer <= 14'd0;
              read_gap_timer   <= 8'd0;
              read_state       <= RD_IDLE;
          end else begin

          case (read_state)

              RD_IDLE: begin
                  read_en_i        <= 1'b0;
                  read_pixel_timer <= 14'd0;
                  read_gap_timer   <= 8'd0;

                      if (!frame_start_done) begin
                          frame_start_i <= 1'b1;
                          if (frame_start_cnt >= 3'd4) begin
                              frame_start_i    <= 1'b0;
                              frame_start_cnt  <= 3'd0;
                              frame_start_done <= 1'b1;
                          end else begin
                              frame_start_cnt <= frame_start_cnt + 1'b1;
                          end
                      end
                      else
                      if (read_line_count < height_lines) begin
                          read_en_i        <= 1'b1;
                          read_pixel_timer <= 14'd0;
                          read_state       <= RD_LINE;
                      end
              
              end

              RD_LINE: begin
                  read_en_i <= 1'b1;

                  if (read_pixel_timer >= width_pixels - 1'b1) begin
                      read_en_i       <= 1'b0;
                      read_line_count <= read_line_count + 1'b1;
                      read_gap_timer  <= 8'd0;
                      read_state      <= RD_GAP;
                  end else begin
                      read_pixel_timer <= read_pixel_timer + 1'b1;
                  end
              end

              RD_GAP: begin
                  read_en_i <= 1'b0;

                  // Equivalent du TB: #(PIXEL_CLK*(280/4))
                  // A ajuster selon ton besoin.
                  if (read_gap_timer >= 8'd69) begin
                      read_gap_timer <= 8'd0;
                      read_state     <= RD_IDLE;
                  end else begin
                      read_gap_timer <= read_gap_timer + 1'b1;
                  end
              end

              default: begin
                  read_en_i  <= 1'b0;
                  read_state <= RD_IDLE;
              end
          endcase
            end
          
      end
  end

    //============================
    // PIPELINE RAM (2 registres)
    //============================
    always @(posedge clk) begin
        ram_data_d  <= ram_read_data;
        ram_valid_d <= ram_data_valid;
    end
    //============================
    // REGISTRE D'TAT FSM
    //============================
    always @(posedge clk or negedge rstn) begin
        if (!rstn) state <= IDLE;
        else       state <= next_state;
    end
    //============================
    // LOGIQUE NEXT STATE
    //============================
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:
                if (i_sof_ps)
                    next_state = SOF_PULSE;
            SOF_PULSE:
                if (sof_counter >= 9'd367)
                    next_state = encoder_active ? FEED_PIXELS : FINISH;
            FEED_PIXELS:
                if (pixels_done && last_seen)
                    next_state = FINISH;
            FINISH:
                if (idle_counter >= 9'd32)
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

 //============================
    // MAIN LOGIC
    //============================
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            i_sof <= 0;
            i_e   <= 0;
            i_x   <= 0;

            pixel_count  <= 0;
            total_pixels <= 0;
            pixels_done  <= 0;

            sof_counter  <= 0;
            idle_counter <= 0;

            encoder_active <= 0;
            encoder_active_o <= 0;

            sof_flag <= 0;
            eof_flag <= 0;
            last_seen <= 0;

        end else begin
            //--------------------------------------------------
            // DEFAULTS (IMPORTANT)
            //--------------------------------------------------
            i_e <= 0;
            o_e_pck <= 0;
            eof_flag <= 0;

            encoder_active_o <= encoder_active;

            //--------------------------------------------------
            // IDLE
            //--------------------------------------------------
            if (state == IDLE) begin
                pixel_count <= 0;
                pixels_done <= 0;
                sof_counter <= 0;
                idle_counter <= 0;
                last_seen <= 0;
            end

            //--------------------------------------------------
            // SOF
            //--------------------------------------------------
            if (state == SOF_PULSE) begin
                if (sof_counter == 0) begin
                    width_reg  <= i_w;
                    height_reg <= i_h;
                    total_pixels <= total_pixels_comb;

                    encoder_active <= 1'b1;

                    $display("[SOF] total_pixels=%0d", total_pixels_comb);
                end

                i_sof <= 1'b1;

                if (sof_counter < 9'd367)
                    sof_counter <= sof_counter + 1;
                else begin
                    i_sof <= 0;
                    sof_counter <= 0;
                end
            end else begin
                i_sof <= 0;
            end

            //--------------------------------------------------
            //  FEED_PIXELS (FIX FINAL)
            //--------------------------------------------------
            if (state == FEED_PIXELS && encoder_active && !pixels_done) begin
                if(ram_valid_d)begin
                    i_x <= ram_data_d;
                    i_e <= 1'b1;

                    pixel_count <= pixel_count + 1;

                    $display("[PIXEL] %02h count=%0d", i_x, pixel_count);

                    if (pixel_count + 1 >= total_pixels)
                        pixels_done <= 1'b1;
                end
            end

            //--------------------------------------------------
            // JPEG OUTPUT
            //--------------------------------------------------
            if (o_e) begin
                o_data_pck <= o_data;
                o_e_pck <= 1'b1;
            end

            if (o_last)
                last_seen <= 1'b1;

            //--------------------------------------------------
            // FINISH
            //--------------------------------------------------
            if (state == FINISH) begin
                idle_counter <= idle_counter + 1;

                if (last_seen) begin
                    o_last_flag <= 1'b1;
                    eof_flag    <= 1'b1;
                end

                if (idle_counter >= 32)
                    encoder_active <= 0;
            end else begin
                o_last_flag <= 0;
                idle_counter <= 0;
            end
        end
    end

endmodule

