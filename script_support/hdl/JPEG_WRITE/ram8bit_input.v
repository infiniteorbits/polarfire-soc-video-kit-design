///////////////////////////////////////////////////////////////////////////////////////////////////
//ram8bit
/////////////////////////////////////////////////////////////////////////////////////////////////// 

//`timescale <time_units> / <precision>

module ram8bit_input #(
    parameter ADDR_WIDTH =3  //4  // 2^3 = 8 adresses (modifie selon besoin)
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [7:0]           dout
);

    // Memory array avec valeurs prdfinies
    reg [7:0] ram_model [0:(1<<ADDR_WIDTH)-1];

    integer i;
    initial begin
        
        // Image 5x1
        ram_model[0] = 8'h84;
        ram_model[1] = 8'h86;
        ram_model[2] = 8'h7A;
        ram_model[3] = 8'h84;
        ram_model[4] = 8'h84;

        /*
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
        // ram_model[15] reste 0*/
    end

    // Lecture synchronise ou combinatoire
    always @(*) begin
        dout = ram_model[addr];
    end

endmodule


