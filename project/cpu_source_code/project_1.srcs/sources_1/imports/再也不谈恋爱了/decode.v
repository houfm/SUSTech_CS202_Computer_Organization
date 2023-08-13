// this is the decode module for a minisys cpu

module decode(
    input [31:0] instr,

    output Jr,// 1 indicates the instruction is "jr", otherwise it's not "jr" 
    output Jmp,// 1 indicate the instruction is "j", otherwise it's not 
    output Jal, // 1 indicate the instruction is "jal", otherwise it's not 
    output Branch, // 1 indicate the instruction is "beq" , otherwise it's not 
    output nBranch, // 1 indicate the instruction is "bne", otherwise it's not 
    output RegDST,// 1 indicate destination register is "rd",otherwise it's "rt" 
    output MemtoReg, // 1 indicate read data from memory and write it into register 
    output RegWrite, // 1 indicate write register, otherwise it's not 
    output MemWrite, // 1 indicate write data memory, otherwise it's not 
    output ALUSrc, // 1 indicate the 2nd data is immidiate (except "beq","bne") 
    output I_format, // 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" 
    output Sftmd, // 1 indicate the instruction is shift instruction 
    // if the instruction is R-type or I_format, ALUOp is 2'b10; if the instruction is"beq" or "bne", ALUOp is 2'b01??
    // if the instruction is"lw" or "sw", ALUOp is 2'b00?? 
    output [1:0] ALUOp,
    output[4:0] rs_addr,
    output[4:0] rt_addr,
    output[4:0] rd_addr,
    output [4:0] Shamt,
    output  [31:0] imm_extended,
    output[5:0] Opcode,
    output [5:0] Function_opcode
);

    reg R_format, Lw, Sw;
    reg reg_Jr;
    reg reg_Jmp;
    reg reg_Jal;
    reg reg_Branch;
    reg reg_nBranch;
    reg reg_RegDST;
    reg reg_MemtoReg;
    reg reg_RegWrite;
    reg reg_MemWrite;
    reg reg_ALUSrc;
    reg reg_I_format;
    reg reg_Sftmd;
    reg [1:0] reg_ALUOp;

    assign Opcode = instr[31:26];
    assign Function_opcode = instr[5:0];
    assign rs_addr = instr[25:21];
    assign rt_addr = instr[20:16];
    assign rd_addr = instr[15:11];
    wire [15:0]  immediate = instr[15:0];
    assign Shamt = instr[10:6];
    
    always @(*) begin
        R_format = (instr[31:26] == 6'b000000) ? 1'b1 : 1'b0;
        Lw = (instr[31:26] == 6'b100011) ? 1'b1 : 1'b0;
        Sw = (instr[31:26] == 6'b101011) ? 1'b1 : 1'b0;
        reg_Jr = ((Function_opcode==6'b001000)&&(Opcode==6'b000000)) ? 1'b1 : 1'b0;
        reg_Jmp = (Opcode==6'b000010) ? 1'b1 : 1'b0;
        reg_Jal = (Opcode==6'b000011) ? 1'b1 : 1'b0;
        reg_Branch = (Opcode==6'b000100) ? 1'b1 : 1'b0;
        reg_nBranch = (Opcode==6'b000101) ? 1'b1 : 1'b0;
        reg_RegDST = R_format;
        reg_MemtoReg = Lw;
        reg_RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
        reg_MemWrite = Sw;
        reg_I_format = (Opcode[5:3]==3'b001) ? 1'b1:1'b0;
        reg_ALUSrc = (I_format || Lw || Sw) ? 1'b1 : 1'b0;
        reg_ALUOp = {(R_format || I_format),(Branch || nBranch)};
        reg_Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010) ||(Function_opcode==6'b000011)||(Function_opcode==6'b000100) ||(Function_opcode==6'b000110)||(Function_opcode==6'b000111)) && R_format)? 1'b1:1'b0;
    end

    // immediate number
    assign imm_extended = (6'b001100 == Opcode || 6'b001101 == Opcode)?{{16{1'b0}},immediate}:{{16{instr[15]}},immediate};

    assign Jr = reg_Jr;
    assign Jmp = reg_Jmp;
    assign Jal = reg_Jal;
    assign Branch = reg_Branch;
    assign nBranch = reg_nBranch;
    assign RegDST = reg_RegDST;
    assign MemtoReg = reg_MemtoReg;
    assign RegWrite = reg_RegWrite;
    assign MemWrite = reg_MemWrite;
    assign ALUSrc = reg_ALUSrc;
    assign I_format = reg_I_format;
    assign ALUOp = reg_ALUOp;
    assign Sftmd = reg_Sftmd;

endmodule