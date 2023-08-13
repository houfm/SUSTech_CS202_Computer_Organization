 module top(
     input fpga_rst,
     input fpga_clk,
     input [23:0]switch2N4,
     output [23:0]led2N4,
     input start_pg,
     input rx,
     output tx,
     output [7:0] segment_led,
     output [7:0] seg_en,
     output buzzer,
     output [3:0] red,
     output [3:0] green,
     output [3:0] blue, 
     output hsync,
     output vsync
//     output [31:0] addr,
//     output [31:0] instr
//     output clk1,
//     output clk2
 ); 

     wire ram_wen;
     wire [31:0] ram_adr_i;
     wire [31:0] ram_dat_i;
     wire [31:0] ram_dat_o;
     wire [31:0] imem_instr;
     wire [31:0] imem_addr;
//     assign addr = imem_addr;
//     assign instr = imem_instr;

     // UART Programmer Pinouts 
     wire upg_clk, upg_clk_o, upg_clk2; 
     wire upg_wen_o; //Uart write out enable 
     wire upg_done_o; //Uart rx data have done 
     //data to which memory unit of program_rom/dmemory32 
     wire [14:0] upg_adr_o; //data to program_rom or dmemory32 
     wire [31:0] upg_dat_o;
     wire spg_bufg; 
     //BUFG1 U1(.clk(fpga_clk), .nrst(fpga_rst), .key_in(start_pg), .key_out(spg_bufg)); // de-twitter 
     BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
     // Generate UART Programmer reset signal 
     reg upg_rst; 
     always @ (posedge fpga_clk) 
     begin 
         if (spg_bufg) 
             upg_rst = 0; 
         if (fpga_rst) 
             upg_rst = 1; 
     end
     wire rst = fpga_rst | !upg_rst;

     wire upg_clk1;
     wire bgm_clk;
     
     cpuclk clk(
     .clk_out1(upg_clk1),
     .clk_out2(upg_clk_o), 
     .clk_out3(upg_clk2),
     .clk_out4(bgm_clk), 
     .clk_in1(fpga_clk));
     //////////////////////////////////23                10

     reg[31:0] low_clk;
     always @(posedge upg_clk1)low_clk=low_clk+1;
     assign upg_clk=low_clk[2];//upg_clk1;//
     //1010 1010 1010 1010
        wire [31:0] show_t8;
          wire [31:0] show_k1;
          wire [31:0] input_t9;
          wire use_outter_t9;
    
     wire clkout=low_clk[12];
     wire [31:0] data;
     //freq uency_divider #(100_000)divider2(fpga_clk,fpga_rst,clkout);
     segment seg(.clk(clkout),.rst(fpga_rst),.in(data),.segment_led(segment_led),.seg_en(seg_en));
     //uart??wires
     wire upg_clk_w; //????dmemory32
     wire upg_wen_w; //????dmemory32
     wire[14:0] upg_adr_w; //????dmemory32
     wire[31:0] upg_dat_w; //????dmemory32 and decoder
     wire upg_done_w; //????dmemory32

     uart_bmpg_0 uart(.upg_clk_i(upg_clk_o),.upg_rst_i(upg_rst),.upg_rx_i(rx),
     .upg_clk_o(upg_clk_w),.upg_wen_o(upg_wen_w),.upg_adr_o(upg_adr_w),
     .upg_dat_o(upg_dat_w),.upg_done_o(upg_done_w),.upg_tx_o(tx));

     wire cpu_clk1=upg_clk1;
     wire cpu_rst = !fpga_rst;
     wire cpu_clk2 = upg_clk2;
//     assign clk1 = cpu_clk1;
//     assign clk2 = cpu_clk2;

     
     assign input_t9=switch2N4[23:0];
     assign use_outter_t9=switch2N4[23];
     assign led2N4=data[23:0];
     assign data=show_t8;//PC_plus_4_w;//show_t8;//Instruction_o_w;//

     cpu u_cpu(
         .clk(cpu_clk1),
         .clk2(cpu_clk2),
         .reset(!cpu_rst),
         .ram_wen_w(ram_wen),
         .ram_adr_i_w(ram_adr_i),
         .ram_dat_i_w(ram_dat_i),
         .ram_dat_o_w(ram_dat_o),
         .imem_instr(imem_instr),
         .imem_addr(imem_addr),
         .ram_reg_o(show_t8),
         .ram_reg_o2(show_k1),
         .outter_input(use_outter_t9),
         .outter_t9(input_t9)
     );
     
      RenaiCirculation bgm(
        .clk(bgm_clk),
        .enable(switch2N4[22:22]),
        .music(buzzer)
    );

     programrom imem(
         .rom_clk_i(cpu_clk2),
         .rom_adr_i(imem_addr),
         .Instruction_o(imem_instr),
         .upg_rst_i(upg_rst),
         .upg_clk_i(upg_clk_w),
         .upg_wen_i(upg_wen_w&!upg_adr_w[14]),
         .upg_adr_i(upg_adr_w),
         .upg_dat_i(upg_dat_w),
         .upg_done_i(upg_done_w)
     );
//     prgrom instmem(
//     .clka(!cpu_clk1),
//     .addra(imem_addr[15:2]),
//     .douta(imem_instr),
//     .wea(1'b0),
//     .dina(32'b00000000_00000000_00000000)
//     );

     dmemory32 dmem(
         .ram_clk_i(cpu_clk2),
         .ram_wen_i(ram_wen),
         .ram_adr_i(ram_adr_i[15:2]),
         .ram_dat_i(ram_dat_i),
         .ram_dat_o(ram_dat_o),
         .upg_rst_i(upg_rst),.upg_clk_i(upg_clk_w),
         .upg_wen_i(upg_wen_w&upg_adr_w[14]),
         .upg_adr_i(upg_adr_w),
         .upg_dat_i(upg_dat_w),
         .upg_done_i(upg_done_w)
     );
     
     vga_top vga(
        .clk(fpga_clk),
        .switch2N4(switch2N4[7:0]),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
     );

 endmodule