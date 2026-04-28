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
    parameter ADDR_WIDTH = 3
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
    /*reg [31:0] pixel_count_read;
 assign read_en_i = (state == FEED_PIXELS) && encoder_active && (pixel_count_read < total_pixels);
*/
reg [31:0] total_beats;
    //============================
    // TOTAL PIXELS (combinatoire)
    //============================
    wire [47:0] total_pixels_comb;
    assign total_pixels_comb = ({34'd0, i_w} + 1) * ({34'd0, i_h} + 1);
reg [3:0] read_en_cnt;   // largeur  adapter

reg read_req_pending;
reg read_wait_ack;
reg read_wait_done;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_en_i        <= 0;
        read_req_pending <= 0;
    end else begin

        read_en_i <= 0; // IMPORTANT : pulse unique

        if (state == FEED_PIXELS &&
            !read_req_pending &&
            !pixels_done) begin

            read_en_i <= 1'b1;
            read_req_pending <= 1'b1;
        end

        // ACK libre le pipeline
        if (read_ackn_i) begin
            // optionnel: debug state
        end

        // DONE libre nouvelle requte
        if (read_done_i) begin
            read_req_pending <= 0;
        end
    end
end
/*reg read_req_pending;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_en_i        <= 0;
        read_req_pending <= 0;
    end else begin

        case (state)

        FEED_PIXELS: begin

            // 1) si besoin de donnes
            if (!pixels_done && !read_req_pending) begin
                read_en_i        <= 1'b1;   // START REQUEST
                read_req_pending <= 1'b1;
            end

            // 2) une fois ACK reu  stop request
            if (read_ackn_i) begin
                read_en_i <= 1'b0;
            end

            // 3) reset request quand transaction finie
            if (read_done_i) begin
                read_req_pending <= 1'b0;
            end
        end

        default: begin
            read_en_i        <= 0;
            read_req_pending <= 0;
        end

        endcase
    end
end*/
/*    
   // reg read_toggle;
 always @(posedge clk or negedge rstn) begin
     if (!rstn) begin 
        read_en_i <= 0;
        read_counter <= 0; 
   //     read_toggle <= 0; 
    end else begin
        if (state == FEED_PIXELS && encoder_active && !pixels_done) begin 
            // Gnrer un pulse 1 cycle sur 2
             //read_toggle <= ~read_toggle;
            // if (read_toggle && (read_counter < total_pixels)) begin 
            //if (!ram_valid_d && (read_counter < total_pixels)) begin 
                read_en_i <= 1'b1; 
                read_counter <= read_counter + 1; 
            end else begin 
                read_en_i <= 1'b0; 
            end 
        end else begin
             read_en_i <= 0; 
             read_counter <= 0;
           //  read_toggle <= 0; 
        end 
    end 
end
    */
/*always @(posedge clk or negedge rstn) begin
    if (!rstn)
        total_beats <= 0;
    else if (state == SOF_PULSE && sof_counter == 0) begin
        // ceil(total_pixels / 8)
        total_beats <= (total_pixels_comb + 7) >> 3;
    end
end
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_en_i    <= 0;
        read_counter <= 0;
    end else begin
        read_en_i <= 0; // pulse 1 cycle

        if (state == FEED_PIXELS && encoder_active && !pixels_done) begin

            // envoyer une requte SEULEMENT si :
            // - pas fini
            // - ET (optionnel) buffer libre
            //if (read_counter < total_beats) begin
            //if (!ram_valid_d && (read_counter < total_pixels)) begin
            if (read_counter < total_pixels) begin
                read_en_i <= 1'b1;
                read_counter <= read_counter + 1;
            end else begin
            read_en_i <= 0;
        end

        end else begin
            read_counter <= 0;
        end
    end
end*/
/*
reg toggle;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_en_i    <= 0;
        read_counter <= 0;
        toggle       <= 0;
    end else begin

        if (state == FEED_PIXELS && encoder_active && !pixels_done) begin

            if (read_counter < total_beats) begin
                toggle <= ~toggle;       //  toggle  chaque cycle
                read_en_i <= toggle;     //  sortie toggle

                //  compter seulement sur front montant
                if (toggle == 0) begin   // (car il va devenir 1)
                    read_counter <= read_counter + 1;
                end

            end else begin
                read_en_i <= 0;
            end

        end else begin
            read_en_i    <= 0;
            read_counter <= 0;
            toggle       <= 0;
        end
    end
end*/
/*
 always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_en_i   <= 0;
        read_counter <= 0;
        read_en_i_d <= 0;
        read_phase   <= 0;
    end else begin
        read_en_i <= 0; //  IMPORTANT : pulse 1 cycle
        if (state == FEED_PIXELS && encoder_active && !pixels_done) begin

            //  DEMANDE UNIQUEMENT SI BUFFER VIDE
           // if (!ram_valid_d && (read_counter < total_pixels)) begin
            if (read_counter < total_beats) begin
                //read_en_i   <= 1'b1;
                //read_en_i <= ~read_en_i_d; // front pour data_unpacker
                //read_en_i_d <= read_en_i; 
                //read_counter <= read_counter + 1;
               if (!read_phase) begin
                    read_en_i  <= 1'b1;   //  front montant
                    read_phase <= 1'b1;
                    read_counter <= read_counter + 1;
                end else begin
                    read_phase <= 1'b0;   //  retour  0 obligatoire
                end
            //end else begin
            //    read_en_i <= 1'b0;
            end

        end else begin
            //read_en_i   <= 0;
            read_counter <= 0;
             read_phase   <= 0;
        end
    end
end*/


    //============================
    // PIPELINE RAM (2 registres)
    //============================


    always @(posedge clk) begin
        ram_data_d  <= ram_read_data;
        ram_valid_d <= ram_data_valid;
    end
   

   
    //============================
    // PIXEL HOLD
    // FIX [3] : suppression de la condition sur `reading`
    // Le pixel est accept ds qu'il est valide et que le buffer est libre
    //============================


    /*always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pixel_hold       <= 8'h00;
            pixel_valid_hold <= 1'b0;
        end else begin
            if (state == FEED_PIXELS) begin
                // Stocker si buffer libre et donne valide
               // if (ram_valid_d && !pixel_valid_hold) begin
               if (ram_valid_d && !pixel_valid_hold) begin
                    pixel_hold       <= ram_data_d;
                    pixel_valid_hold <= 1'b1;
                end
                // Consommer quand le FSM envoie au JLS
                else if (pixel_valid_hold && encoder_active) begin
                    pixel_valid_hold <= 1'b0;
                end
            end else begin
                pixel_valid_hold <= 1'b0;
            end
        end
    end*/
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

                //if (pixel_valid_hold) begin
                //    i_x <= pixel_hold;
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