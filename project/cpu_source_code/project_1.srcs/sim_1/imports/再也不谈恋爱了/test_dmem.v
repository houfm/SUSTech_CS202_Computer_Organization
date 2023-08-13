module dmem(
    input [11:0] addr,
    input we,
    input [31:0] din,
    input clk,

    output reg [31:0] dout
);
    reg [31:0] dmem_reg[0:4095];
    
    always @(posedge clk) begin
        if(we) begin
            dmem_reg[addr] <= din;
        end
            dout <= dmem_reg[addr];
    end
endmodule