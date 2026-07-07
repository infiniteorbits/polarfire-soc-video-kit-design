///////////////////////////////////////////////////////////////////////////////////////////////////
//ram8bit
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module ram8bit_input #(
    parameter ADDR_WIDTH =6//3  //4  // 2^3 = 8 adresses (modifie selon besoin)
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [7:0]           dout
);

    // Memory array avec valeurs prdfinies
    reg [7:0] ram_model [0:2000000];

    integer i;
    initial begin
        /*
        // Image 5x1
        ram_model[0] = 8'h84;
        ram_model[1] = 8'h86;
        ram_model[2] = 8'h7A;
        ram_model[3] = 8'h84;
        ram_model[4] = 8'h84;

        */
        // Nouvelles donnes
        ram_model[0]  = 8'h86;
        ram_model[1]  = 8'h79;
        ram_model[2]  = 8'h77;
        ram_model[3]  = 8'h80;
        ram_model[4]  = 8'h7a;
        ram_model[5]  = 8'h79;
        ram_model[6]  = 8'h78;
        ram_model[7]  = 8'h7c;
        ram_model[8]  = 8'h85;
        ram_model[9]  = 8'h7a;
        ram_model[10] = 8'h76;
        ram_model[11] = 8'h76;
        ram_model[12] = 8'h75;
        ram_model[13] = 8'h7a;
        ram_model[14] = 8'h79;
        ram_model[15] = 8'h79;
        ram_model[16] = 8'h79;
        ram_model[17] = 8'h79;
        ram_model[18] = 8'h79;
        ram_model[19] = 8'h79;
        ram_model[20] = 8'h79;
        ram_model[21] = 8'h79;
        ram_model[22] = 8'h79;
        ram_model[23] = 8'h79;
        ram_model[24] = 8'h79;
        ram_model[25] = 8'h79;
        ram_model[26] = 8'h79;
        ram_model[27] = 8'h79;
        ram_model[28] = 8'h79;
        ram_model[29] = 8'h79;
        ram_model[30] = 8'h79;
        ram_model[31] = 8'h79;
        ram_model[32] = 8'h79;
        ram_model[33] = 8'h79;
        ram_model[34] = 8'h79;
        ram_model[35] = 8'h79;
        ram_model[36] = 8'h79;
        ram_model[37] = 8'h79;
        ram_model[38] = 8'h79;
        ram_model[39] = 8'h79;
        ram_model[40] = 8'h79;
        ram_model[41] = 8'h79;
        ram_model[42] = 8'h79;
        ram_model[43] = 8'h79;
        ram_model[44] = 8'h79;
        ram_model[45] = 8'h79;



        // ram_model[15] reste 0
    end

    // Lecture synchronise ou combinatoire
    always @(*) begin
        dout = ram_model[addr];
    end

endmodule




