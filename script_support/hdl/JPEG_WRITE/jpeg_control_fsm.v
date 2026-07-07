
// jpeg_control_fsm.v
// Version complte corrige avec buffer FEED_PIXELS
module jpeg_control_fsm #(
    parameter ADDR_WIDTH =6,// 3, //24,
    parameter LINE_STORAGE_MODE = 0
)(
    input  wire                   clk,
    input  wire                   rstn,
    // control inputs from APB wrapper
    input  wire                   i_sof_ps,
    input  wire [13:0]            i_w,
    input  wire [13:0]            i_h,
    input  wire [7:0]             near,

    // outputs to JPEG core
    output reg                    i_sof,
    output reg                    i_e,
    output reg  [7:0]             i_x,

    // inputs from JPEG core
    input  wire [15:0]            o_data,
    input  wire                   o_e,
    input  wire                   o_last,
    
    //output to data packer 
    output  reg [15:0]            o_data_pck,
    output  reg                   o_e_pck,
    // flags of the image compression 
    output reg                     sof_flag,
    output reg                     eof_flag,

    // shared RAM interface
    input  wire [7:0]             ram_read_data,
    output reg [ADDR_WIDTH-1:0]   ram_read_addr,
    //input   wire                  ram_data_valid,
    output wire [15:0]    line_gap_o,
    input wire [15:0]    horz_resl_o,
    input wire w0_done,
    output reg  read_en_i,
    output reg          frame_start_i,
    //size of compressed image 
    output  reg [31:0]            compressed_size_o,
    // status back to APB
    output reg                    o_last_flag,
    
    output reg                    encoder_active_o

);

    // FSM states
    localparam IDLE         = 3'd0;
    localparam SOF_PULSE    = 3'd1;
    localparam FEED_PIXELS  = 3'd2;
    //localparam STORE_OUTPUT = 3'd3;
    localparam FINISH       = 3'd3;

    reg [2:0] state, next_state;

    // Counters & configuration
    reg [31:0] total_pixels;
    reg [31:0] pixel_count;
    reg [ADDR_WIDTH-1:0] output_base_addr;
    reg [31:0] compressed_size;  // taille en octets
    reg [13:0] width_reg;
    reg [13:0] height_reg;

    reg last_seen;
    reg [8:0] sof_counter;
    reg [8:0] idle_counter;
    reg pixels_done;

    // -------------------------------
    // Buffer signals for FEED_PIXELS
    reg [7:0] pixel_buffer;
    reg buffer_full;
    reg wait_ram;
    reg pixel_ready_to_send;
    reg pixel_consumed;
    reg pixel_valid;
    
    
    // combinational total pixels computed from inputs (avoids X propagation)
    wire [47:0] total_pixels_comb;
    assign total_pixels_comb = ( {34'd0, i_w} + 1 ) * ( {34'd0, i_h} + 1 );
   
    // encoder enable internal (equivalent encoder_en_o)
    reg encoder_active;

    // resolution tracking
    reg [13:0] width_prev;
    reg [13:0] height_prev;
    wire res_change;
    assign res_change = (width_prev != i_w) || (height_prev != i_h);

    reg eof_pulse_sent;
     //============================
    // line_gap
    //============================
  // LINE_STORAGE_MODE:
    // 0 = compact storage, no padding between lines (lignes stockes bout  bout, sans trou)
    // 1 = padded storage, round each line up to a 64-bit word boundary (lignes arrondies au multiple de 8 octets, pratique pour le bus DDR 64 bits)
    assign line_gap_o = (LINE_STORAGE_MODE == 1'b0)
                      ? horz_resl_o
                      : ((horz_resl_o + 16'd7) & 16'hFFF8);
   reg write_done;
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
      reg o_last_flag_d;
      wire o_last_flag_fall;

        assign o_last_flag_fall = o_last_flag_d & ~o_last_flag;
      always @(posedge clk or negedge rstn) begin
           /* if (!rstn)
                write_done <= 1'b0;
            else if (state == IDLE)
                write_done <= 1'b0;
            else if (w0_done)
                write_done <= 1'b1;
            */
            if (!rstn)
                o_last_flag_d <= 1'b0;
            else
                o_last_flag_d <= o_last_flag;
        end
        
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
          case (read_state)

              RD_IDLE: begin
                  read_en_i        <= 1'b0;
                  frame_start_i <= 1'b0;
                  read_pixel_timer <= 14'd0;
                  read_gap_timer   <= 8'd0;

                     // if (!frame_start_done && write_done) begin
                     if (!frame_start_done && o_last_flag_fall) begin
                          frame_start_i <= 1'b1;
                          if (frame_start_cnt >= 3'd6) begin
                              frame_start_i    <= 1'b0;
                              frame_start_cnt  <= 3'd0;
                              frame_start_done <= 1'b1;
                          end else begin
                              frame_start_cnt <= frame_start_cnt + 1'b1;
                          end
                      end 
                       else if(frame_start_done) begin
                          if (read_line_count < height_lines) begin
                              read_en_i        <= 1'b1;
                              read_pixel_timer <= 14'd0;
                              read_state       <= RD_LINE;
                          end
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
  
    // -------------------------------
    // FSM state register
    always @(posedge clk or negedge rstn) begin
        if (!rstn) state <= IDLE;
        else state <= next_state;
    end

    // -------------------------------
    // FSM next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (i_sof_ps) next_state = SOF_PULSE;
            SOF_PULSE: 
                if (sof_counter >= 9'd367) //next_state = FEED_PIXELS;
                    next_state = encoder_active ? FEED_PIXELS : FINISH;
            FEED_PIXELS:
                if (pixels_done && last_seen)
                    next_state = FINISH;
            FINISH: 
                if (idle_counter >= 9'd320) next_state = IDLE;
            default: 
                next_state = IDLE;
        endcase
    end



    // -------------------------------
    // FEED_PIXELS: buffered RAM read to i_x
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sof_flag <= 1'b0;
            i_sof        <= 0;
            i_e          <= 0;
            i_x          <= 0;
            pixel_count  <= 0;
            total_pixels <= 0;
            width_reg    <= 0;
            height_reg   <= 0;
            pixels_done  <= 0;
            output_base_addr <= 0;
            sof_counter  <= 0;
            idle_counter <= 0;
            o_last_flag  <= 0;
            eof_flag <= 1'b0; 
            eof_pulse_sent <= 1'b0;  // pulse non encore envoy
            pixel_buffer       <= 0;
            buffer_full        <= 0;
            wait_ram           <= 0;
            pixel_ready_to_send<= 0;
            pixel_consumed     <= 1;
            compressed_size <= 32'd0;
            compressed_size_o <= 32'd0;
            encoder_active     <= 1'b0;
            encoder_active_o   <= 1'b0;
            width_prev <= 14'd0;
            height_prev <= 14'd0;
            last_seen <= 1'b0;
        end else begin
            i_e <= 1'b0;
            // Par dfaut, rien n'est valide
            o_e_pck     <= 1'b0;
            eof_flag <= 1'b0; // par dfaut inactif
            // Gnrer le pulse exactement 1 cycle
            if (state == FINISH && last_seen && !eof_pulse_sent) begin
                eof_flag <= 1'b1;       // pulse 1 cycle
                eof_pulse_sent <= 1'b1; // marque que le pulse a t envoy
            end

            // reset pour la prochaine image
            if (state == IDLE) begin
                eof_pulse_sent <= 1'b0;
            end
                   
             // Dtecte le dbut de l'image compresse
            if (o_e && !sof_flag)begin
                sof_flag <= 1'b1;
            end else if (eof_flag == 1)begin
                sof_flag <= 1'b0;
                compressed_size_o <= compressed_size; // tu peux stocker ou lire la taille
            end
            encoder_active_o <= encoder_active;

            // IDLE reset
            if (state == IDLE) begin
                pixel_count <= 0;
                pixels_done <= 0;
                sof_counter <= 0;
                idle_counter<= 0;
                o_last_flag <= 0;
                eof_flag <= 1'b0;                   
                output_base_addr <= 0;
                buffer_full        <= 0;
                wait_ram           <= 0;
                pixel_ready_to_send<= 0;
                pixel_consumed     <= 1;
                i_e <= 1'b0;
                compressed_size_o <= 32'd0;

            end

            // SOF_PULSE: latch config once at entry cycle (sof_counter==0) 
            if (state == SOF_PULSE) begin 
            
                if (sof_counter == 9'd0) begin 
                    if (width_prev == 0 && height_prev == 0)
                        encoder_active <= 1'b1; // premire trame
                    else if (res_change)
                        encoder_active <= 1'b0; // bloquer encodeur si rsolution diffrente
                    else
                        encoder_active <= 1'b1; // sinon encoder activ
                    
                    // Latch width/height and compute total pixels and output base addr 
                    // compute using a combinational temp
                    width_reg        <= i_w;
                    height_reg       <= i_h;
                    total_pixels     <= total_pixels_comb[31:0];
                    output_base_addr <= total_pixels_comb[ADDR_WIDTH-1:0];
                    compressed_size <= 32'd0;
                    pixel_count <= 32'd0;
                    pixels_done <= 1'b0;
                    o_last_flag <= 0;
                    eof_flag <= 1'b0;                   
                    last_seen <= 1'b0;
                    $display("SOF latched: W=%0d H=%0d total_pixels=%0d output_base=%0d", i_w+1, i_h+1,total_pixels,                                            output_base_addr); 
                   
                end
                // maintain i_sof pulse for the duration
                i_sof <= 1'b1;
                i_e <= 1'b0;
                
                if (sof_counter < 9'd367) begin
                    sof_counter <= sof_counter + 1'b1;
                end else begin
                    sof_counter <= 9'd0;
                    i_sof <= 1'b0;
                end
            end else begin
            // ensure i_sof cleared outside SOF_PULSE 
            if (state != SOF_PULSE) 
                i_sof <= 1'b0; 
            end

            // FEED_PIXELS buffer
            //if (state == FEED_PIXELS && !pixels_done) begin
            if (state == FEED_PIXELS && encoder_active && !pixels_done) begin
                // RAM read
                if (!buffer_full && !wait_ram) begin
                    ram_read_addr <= pixel_count[ADDR_WIDTH-1:0];
                    wait_ram <= 1;

                end else if (wait_ram) begin
                    pixel_buffer <= ram_read_data;
                    buffer_full <= 1;
                    wait_ram <= 0;
                    pixel_ready_to_send <= 1;
                    
                end

                // send pixel
                if (pixel_ready_to_send && pixel_consumed) begin
                    i_x <= pixel_buffer;
                    i_e <= 1'b1;
                    pixel_ready_to_send <= 0;
                    buffer_full <= 0;
                    pixel_count <= pixel_count + 1;
                    pixel_consumed <= 0;
                    $display("[FEED] i_x=%02h pixel_count=%0d", pixel_buffer, pixel_count);
                    if (pixel_count + 1 >= total_pixels) begin
                        pixels_done <= 1'b1;
                    end
                end else begin
                    i_e <= 0;
                    if (!pixel_ready_to_send)
                        pixel_consumed <= 1;
                end
            end
            /*if (state == FEED_PIXELS && encoder_active && !pixels_done) begin
                // Adresse en continu (ou contrle par un read_enable si ton IP en a un)
                ram_read_addr <= pixel_count[ADDR_WIDTH-1:0];

                if (ram_data_valid) begin
                    i_x <= ram_read_data;
                    i_e <= 1'b1;
                    pixel_count <= pixel_count + 1;
                    if (pixel_count + 1 >= total_pixels)
                        pixels_done <= 1'b1;
                end
                else begin
                    i_e <= 1'b0;
                end
            end*/
            // ======================
            // JPEG OUTPUT PIPELINE
            // ======================
            if (o_e) begin
                o_data_pck <= o_data;
                o_e_pck <= 1'b1;
                compressed_size <= compressed_size + 2;
            end 

            if (o_last) begin
                last_seen <= 1'b1;
                //eof_flag <= 1'b0;
                width_prev <= width_reg;
                height_prev <= height_reg;
            end
            /*else begin 
                eof_flag <= 1'b1;   // retour  l'tat normal
            end*/
            if (state == FINISH) begin
                idle_counter <= idle_counter + 1;
                //encoder_active <= 1'b0;
                if (idle_counter >= 9'd320) begin
                    encoder_active <= 1'b0; // FIN RELLE DE FRAME
                end
                if (last_seen)begin
                    o_last_flag <= 1'b1;
                end else begin
                    o_last_flag <= 1'b0;
                end

            end else begin
                idle_counter <= 0;
                o_last_flag <= 0;
                                  

            end
        end
    end

endmodule

