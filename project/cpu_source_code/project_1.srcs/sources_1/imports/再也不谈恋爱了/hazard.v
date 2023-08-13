module hazard (
  input  [4:0]  rs,                 // 第一个寄存器编号
  input  [4:0]  rt,                 // 第二个寄存器编号
  input         id_ex_jr,           // jump and link 指令
  input         id_ex_Branch,       // 是否是分支指???, beq
  input         id_ex_nBranch,      // 是否是分支指???, bne
  input         ex_Zero,         // 两数比较, 结果是否???0
  input         id_ex_memRead,      // 是否从内存读取数据，decode里的MemToReg
  input         id_ex_memWrite,     // 是否向内存写入数???
  input  [4:0]  id_ex_rd,           // 要写入的寄存器编???
  input         ex_mem_memWrite,    // 是否向内存写入数???

  output    pcFromTaken,  //分支指令执行结果，判断是否与预测方向??????
  output    pcStall,    //程序计数器停止信???
  output    IF_ID_stall,  //流水线IF_ID段停止信???
  output    ID_EX_stall,  //流水线ID_EX段停止信???
  output    ID_EX_flush,  //流水线ID_EX段清零信???
  output    EX_MEM_flush,   //流水线EX_MEM段清零信???
  output    IF_ID_flush    //流水线IF_ID段清零信???
);

    reg reg_pcFromTaken;
    reg reg_pcStall;
    reg reg_IF_ID_stall;
    reg reg_ID_EX_stall;
    reg reg_ID_EX_flush;
    reg reg_EX_MEM_flush;
    reg reg_IF_ID_flush;

  // 条件分支指令的条件比较结果，beq时???结果不???0，bne时???结果是0，分支预测失???
  wire branch_do = ((id_ex_Branch == 1) && (ex_Zero == 0)) || ((id_ex_nBranch == 1) && (ex_Zero == 1));   // 计算分支指令是否成立
  // 确认分支指令跳转的信???,这两种情况下分支预测失败
  wire ex_mem_taken = id_ex_jr || branch_do;   // 判断是否???要跳???

  // 存储器的选???信号，当对存储器的"读"或者???写"控制信号有效时产生
  wire id_ex_memAccess = id_ex_memRead | id_ex_memWrite;   // 判断是否???要访问内???

  // 表示流水线需要停顿，当执??? sw 指令时就会出现这样的情况
  wire ex_mem_need_stall = ex_mem_memWrite;   // 判断是否???要停???
  
  assign pcFromTaken = reg_pcFromTaken;
  assign pcStall = reg_pcStall;
  assign IF_ID_stall = reg_IF_ID_stall;
  assign ID_EX_stall = reg_ID_EX_stall;
  assign ID_EX_flush = reg_ID_EX_flush;
  assign EX_MEM_flush =  reg_EX_MEM_flush;
  assign IF_ID_flush = reg_IF_ID_flush;

 always @(*) begin
    /* 
    分支预测失败的问???
    当分支指令执行之后，如果发现分支跳转的方向与预测方向不一致???
    这时就需要冲刷流水线，清除处于取指???译码阶段的指令数据，更??? PC 值???
    */
    // branch prediction fail or jr appears
    if(ex_mem_taken) begin      // 如果???要跳???
      reg_pcFromTaken  = 1;            // 跳转
      reg_pcStall      = 0;            // 不停???
      reg_IF_ID_flush  = 1;            // 清空 IF/ID
      reg_ID_EX_flush  = 1;            // 清空 ID/EX
      reg_EX_MEM_flush = 0;            // 不清??? EX/MEM
    end
    /* 
    数据冒险问题???
    当前???条指令是 Load，后???条指令的源寄存器 rs ??? rt 依赖于前???条从存储器中读出来的值，
    ???要把 Load 指令之后的指令停顿一个时钟周期，而且还要冲刷 ID _EX 阶段的指令数据???
    */
    else if(id_ex_memRead & (id_ex_rd == rs || id_ex_rd == rt)) begin   // 如果???要访问内存且???要停???
      reg_pcFromTaken = 0;             // 不跳???
      reg_pcStall     = 1;             // 停顿
      reg_IF_ID_stall = 1;             // IF/ID 停顿
      reg_ID_EX_flush = 1;             // 清空 ID/EX
    end
    /* 
    吼吼，一切正常???Respect???
    */
    else begin                      // 如果不需要停顿也不需要跳???
      reg_pcFromTaken    = 0;          // 不跳???
      reg_pcStall        = 0;          // 不停???
      reg_IF_ID_stall    = 0;          // 不停??? IF/ID
      reg_ID_EX_stall    = 0;          // 不停??? ID/EX
      reg_ID_EX_flush    = 0;          // 不清??? ID/EX
      reg_EX_MEM_flush   = 0;          // 不清??? EX/MEM 
      reg_IF_ID_flush    = 0;          // 不清??? IF/ID
    end
  end

  
endmodule