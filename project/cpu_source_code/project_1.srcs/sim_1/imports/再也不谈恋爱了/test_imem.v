
module imem (
    input  [13:0] addr,
    output [31:0] imem_o
);
    wire [31:0] imem_reg[0:4096];

    assign imem_o = imem_reg[addr];
    // addi $26, $0, 1
    assign imem_reg[0] = 32'h0320c020;
    // addi $20, $0, 2
//    assign imem_reg[1] = 32'hafe10c60;
//    assign imem_reg[2] = 32'h8fe10c72;
//    assign imem_reg[3] = 32'hafe10c62;
//    assign imem_reg[4] = 32'h23180005;
//    assign imem_reg[5] = 32'h03e00008;
    // assign imem_reg[2] = 32'b001000_10100_10100_0000000000000010;
    // assign imem_reg[3] = 32'b001000_10100_10100_0000000000000010;
    // assign imem_reg[4] = 32'b001000_10100_10100_0000000000000010;
    // assign imem_reg[5] = 32'b001000_10100_10100_0000000000000010;
    // assign imem_reg[6] = 32'b001000_10100_10100_0000000000000010;
    // assign imem_reg[7] = 32'b001000_10100_11000_0000000000000010;

endmodule