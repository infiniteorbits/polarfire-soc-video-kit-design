`timescale 1ns / 100ps

module data_packer_jpeg #(
    parameter integer g_IP_DW = 16,
    parameter integer g_OP_DW = 64
)(
    input  wire                 reset_i,
    input  wire                 sys_clk_i,
    input  wire                 data_valid_i,
    input  wire                 frame_end_i,
    input  wire [g_IP_DW-1:0]   data_i,
    output reg                  data_valid_o,
    output reg                  frame_end_o,
    output reg  [g_OP_DW-1:0]   data_o
);

    localparam integer C_MC = g_OP_DW / g_IP_DW;
    localparam integer C_CW = (C_MC <= 1) ? 1 : $clog2(C_MC);

    reg [C_CW-1:0] wr_idx;
    reg frame_end_d1;
    reg frame_end_d2;
    wire frame_end_pulse;

    assign frame_end_pulse = frame_end_d1 & ~frame_end_d2;

    always @(posedge sys_clk_i or negedge reset_i) begin
        if (!reset_i) begin
            frame_end_d1 <= 1'b0;
            frame_end_d2 <= 1'b0;
        end else begin
            frame_end_d1 <= frame_end_i;
            frame_end_d2 <= frame_end_d1;
        end
    end

    always @(posedge sys_clk_i or negedge reset_i) begin
        if (!reset_i) begin
            wr_idx      <= {C_CW{1'b0}};
            data_o      <= {g_OP_DW{1'b0}};
            data_valid_o <= 1'b0;
            frame_end_o <= 1'b0;
        end else begin
            data_valid_o <= 1'b0;
            frame_end_o  <= 1'b0;

            if (data_valid_i) begin
                data_o[g_IP_DW*wr_idx +: g_IP_DW] <= data_i;
                if (wr_idx == C_MC-1) begin
                    wr_idx      <= {C_CW{1'b0}};
                    data_valid_o <= 1'b1;
                end else begin
                    wr_idx <= wr_idx + 1'b1;
                end
            end

            if (frame_end_pulse) begin
                if (wr_idx != {C_CW{1'b0}}) begin
                    data_valid_o <= 1'b1;
                end
                frame_end_o <= 1'b1;
                wr_idx <= {C_CW{1'b0}};
            end
        end
    end

endmodule
