module sim_coe();
     reg reset;
     reg clk;
     wire [23:0]switch2N4 = 24'hB00081;
     wire [23:0]led2N4;
     wire start_pg = 1'b0;
     wire rx = 1'b0;
     wire tx;
     wire [7:0] segment_led;
     wire [7:0] seg_en = 8'hFF;
     wire [3:0] red;
     wire [3:0] green;
     wire [3:0] blue; 
     wire hsync;
     wire vsync;
//     wire [31:0] addr;
//     wire [31:0] instr;
//     wire clk1;
//     wire clk2;
     
     top u_top(
        .fpga_rst(reset),
        .fpga_clk(clk),
        .switch2N4(switch2N4),
        .led2N4(led2N4),
        .start_pg(start_pg),
        .rx(rx),
         .tx(tx),
         .segment_led(segment_led),
         .seg_en(seg_en),
         .red(red),
         .green(green),
         .blue(blue),
         .hsync(hsync),
         .vsync(vsync)
//         .addr(addr),
//         .instr(instr)
//         .clk1(clk1),
//         .clk2(clk2)
     );
     
     always #1 clk=~clk;
     initial begin
            reset = 1'b0;
             clk = 1'b0;
             #255 reset = 1'b1;
             #50 reset = 1'b0;
             # 1000;
         end
         
//     always @(negedge clk1) begin
//         if (!reset) reset=1'b1;
//     end

endmodule
