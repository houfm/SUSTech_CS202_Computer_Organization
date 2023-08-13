`timescale 1ns/1ps

module test_sim ();
    reg clk;
    reg reset;
    wire ram_wen_w;
    wire [31:0] ram_adr_i_w;
    wire [31:0] ram_dat_i_w;
    wire [31:0] ram_dat_o_w;
    wire [31:0] imem_instr;
    wire [31:0] imem_addr;
    wire [31:0] ram_reg_o;
    wire [31:0] ram_reg_o2;
    wire outter_input = 1'b1;
    wire [31:0] outter_t9 = 32'b00000000000000000000000000000011;

    cpu u_cpu(
        .clk(clk),
        .reset(reset),
        .ram_wen_w(ram_wen_w),
        .ram_adr_i_w(ram_adr_i_w),
        .ram_dat_i_w(ram_dat_i_w),
        .ram_dat_o_w(ram_dat_o_w),
        .imem_instr(imem_instr),
        .imem_addr(imem_addr),
        .ram_reg_o(ram_reg_o),
        .ram_reg_o2(ram_reg_o2),
        .outter_input(outter_input),
        .outter_t9(outter_t9)
        );

    dmem u_dmem(
        .addr(ram_adr_i_w[13:2]),
        .we(ram_wen_w),
        .din(ram_dat_i_w),
        .clk(clk),
        .dout(ram_dat_o_w)
    );

    imem u_imem(
        .addr(imem_addr[15:2]),
        .imem_o(imem_instr)
    );

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        reset = 1'b0;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
        #1 clk <= ~clk;
    end

    initial
        begin
            $dumpfile("test_sim.vcd");
            $dumpvars(0,test_sim);
        end
    
endmodule