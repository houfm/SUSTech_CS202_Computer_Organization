`timescale 1ns / 1ps

module execute (
    input [31:0] Read_data_1, // rs��������??
    input [31:0] Read_data_2, // rt��������??
    input [31:0] Imme_extend, // immediate��չ���??
    input [5:0] Function_opcode, // ָ��[5:0]
    input [5:0] opcode, // ָ��[31:26]
    input [4:0] Shamt, // ָ��[10:6]����λ��
    input [31:0] PC, // PC, current PC
    input [1:0] ALUOp, // {(R_format || I_format), (Branch || nBranch)}
    input ALUSrc, // 1��ʾ�ڶ�����������������������beq��bne??
    input I_format, // 1��ʾI��ָ�����beq��bne��LW��SW
    input Sftmd, // 1��ʾ����??����λָ??
    input Jr, // 1��ʾ����??��jrָ��

    output Zero, // 1��ʾALU������??0������Ϊ0
    output [31:0] ALU_Result, // ALU������
    output [31:0] Addr_Result // ����õ���ָ���??, ����branchָ��
);

    wire [31:0] Ainput, Binput; // �������ڼ���Ĳ�����
    wire [5:0] Exe_code; // ��������ALU_ctrl�ı�����(I_format==0) ? Function_opcode : {3'b000, Opcode[2:0]}
    wire [2:0] ALU_ctl; // ֱ��Ӱ��ALU�����Ŀ�����??
    wire [2:0] Sftm; // ����ʶ����λָ�����ͣ�����Function_opcode[2:0]
    reg [31:0] ALU_output_mux; // ������???������Ľ�??
    reg [31:0] Shift_Result; // ��λ�����Ľ�??
    reg [31:0] reg_ALU_Result; // ALU������
    wire [31:0] Branch_Addr; // ָ��ļ����??��Addr_Result��Branch_Addr[31:0]
    wire [31:0] PC_plus_4 = PC + 4; // PC+4

    // ѡ��A��B��������??
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Imme_extend[31:0];

    // ����ALU�����ź�
    assign Exe_code = (I_format == 0) ? Function_opcode : {3'b000, opcode[2:0]};
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Sftm = Function_opcode[2:0];

    // ALU����
    always @ (ALU_ctl or Ainput or Binput) begin
                case (ALU_ctl)
                    3'b000: ALU_output_mux = Ainput & Binput;
                    3'b001: ALU_output_mux = Ainput | Binput;
                    3'b010: ALU_output_mux = $signed(Ainput) + $signed(Binput);
                    3'b011: ALU_output_mux = Ainput + Binput;
                    3'b100: ALU_output_mux = Ainput ^ Binput;
                    3'b101: ALU_output_mux = ~(Ainput | Binput);
                    3'b110: ALU_output_mux = $signed(Ainput) - $signed(Binput);
                    3'b111: ALU_output_mux = Ainput - Binput;
                    default: ALU_output_mux = 32'h00000000;
                endcase
            end


    // ��λ����
    always @* begin
        if (Sftmd) begin
            case (Sftm[2:0])
                3'b000: Shift_Result = Binput << Shamt; // Sll rd, rt, shamt 00000
                3'b010: Shift_Result = Binput >> Shamt; // Srl rd, rt, shamt 00010
                3'b100: Shift_Result = Binput << Ainput; // Sllv rd, rt, rs 000100
                3'b110: Shift_Result = Binput >> Ainput; // Srlv rd, rt, rs 000110
                3'b011: Shift_Result = $signed(Binput) >>> Shamt; // Sra rd, rt, shamt 00011
                3'b111: Shift_Result = $signed(Binput) >>> Ainput; // Srav rd, rt, rs 00111
                default: Shift_Result = Binput;
            endcase
        end else begin
            Shift_Result = Binput;
        end
    end


    // �������Ͳ�����slt, slti, sltu, sltiu??
    // ��???lui����
    // ��???��λ��??
    // ��???����ALU�������������߼�����??
    always @* begin
        if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1)) || ((ALU_ctl[2:1] == 2'b11) && (I_format == 1))) begin
            reg_ALU_Result = ALU_output_mux[31] == 1 ? 1 : 0;
        end else if ((ALU_ctl == 3'b101) && (I_format == 1)) begin
            reg_ALU_Result[31:0] = {Binput[15:0], {16{1'b0}}};
        end else if (Sftmd == 1) begin
            reg_ALU_Result = Shift_Result;
        end else begin
            reg_ALU_Result = ALU_output_mux[31:0];
        end
    end


    // �ж�ALU�������Ƿ�??0
    assign Zero = (ALU_output_mux == 32'b0) ? 1'b1 : 1'b0;

    // �����ָ֧��ĵ�??
    assign Branch_Addr = PC_plus_4[31:2] + Imme_extend; // to do: +4 ����
    assign Addr_Result = Branch_Addr[31:0];

    assign ALU_Result = reg_ALU_Result;

endmodule