module simple_fifo (
    input         clk,
    input         rst,
    input  [7:0]  data_i,
    input         data_valid_i
);

reg [7:0] fifo_mem [0:1023];
reg [9:0] wr_ptr;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wr_ptr <= 10'd0;
    end
    else if (data_valid_i) begin
        fifo_mem[wr_ptr] <= data_i;
        wr_ptr <= wr_ptr + 1'b1;
    end
end

endmodule