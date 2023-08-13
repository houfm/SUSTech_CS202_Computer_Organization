//  IF_ID
// 通路模块 if_id 主要负责指令�? PC 的传递，以及流水线冲刷标志位的传递�??
module if_id(           
  input         clk,
  input         reset,
  input  [31:0] in_instr,
  input  [31:0] in_pc,
  input         flush,
  input         valid,
  output [31:0] out_instr,
  output [31:0] out_pc,
  output        out_noflush
);

  reg [31:0] reg_instr; 
  reg [31:0] reg_pc; 
  reg [31:0] reg_pc_next; 
  reg        reg_noflush; 

  assign out_instr = reg_instr; 
  assign out_pc = reg_pc; 
  assign out_noflush = reg_noflush; 

  //指令传�??
  always @(posedge clk) begin
    if (reset) begin 
      reg_instr <= 32'h0; 
    end else if (flush) begin 
      reg_instr <= 32'h0; 
    end else if (valid) begin 
      reg_instr <= in_instr; 
    end
  end

  //PC值转�?
  always @(posedge clk) begin
    if (reset) begin 
      reg_pc <= 32'h0; 
    end else if (flush) begin 
      reg_pc <= 32'h0; 
    end else if (valid) begin 
      reg_pc <= in_pc; 
    end
  end

  //流水线冲刷标志位
  always @(posedge clk) begin  
    if (reset) begin 
      reg_noflush <= 1'h0; 
    end else if (flush) begin 
      reg_noflush <= 1'h0; 
    end else if (valid) begin 
      reg_noflush <= 1'h1; 
    end
  end
endmodule