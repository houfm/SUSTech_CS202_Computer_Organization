// gen_regs - 寄存器文件模�??
// clk - 时钟信号
// reset - 异步复位信号
// wen - 写使能信�??
// regRAddr1, regRAddr2 - 两个读端口的寄存器地�??
// regWAddr - 写端口的寄存器地�??
// regWData - 写入寄存器的数据
// regRData1, regRData2 - 两个读端口的寄存器数�??

module gen_regs (
    input  clock,
    input  reset,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input write,
    input [4:0] write_reg,
    input [31:0] write_data,
    input outter_input,
    input [31:0] outter_t9,
    output reg[31:0] ram_reg_o,
    output reg[31:0] ram_reg_o2,
    output [31:0] read_data_1,
    output [31:0] read_data_2
);

    reg[31:0] register[0:31];

    integer i;
    always @(posedge clock) begin
        if(reset) begin
        for(i=0;i<=31;i=i+1) 
            register[i] <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        end
        else begin
            ram_reg_o<= register[24];
            //ram_reg_o2<=register[26];
            ram_reg_o2<=register[12];
            if(outter_input) register[25]<=outter_t9; else begin end
            if (write) register[write_reg]<=write_data; else begin end
        end
    end

    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];

endmodule