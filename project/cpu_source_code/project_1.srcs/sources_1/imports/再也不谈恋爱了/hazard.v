module hazard (
  input  [4:0]  rs,                 // ��һ���Ĵ������
  input  [4:0]  rt,                 // �ڶ����Ĵ������
  input         id_ex_jr,           // jump and link ָ��
  input         id_ex_Branch,       // �Ƿ��Ƿ�ָ֧???, beq
  input         id_ex_nBranch,      // �Ƿ��Ƿ�ָ֧???, bne
  input         ex_Zero,         // �����Ƚ�, ����Ƿ�???0
  input         id_ex_memRead,      // �Ƿ���ڴ��ȡ���ݣ�decode���MemToReg
  input         id_ex_memWrite,     // �Ƿ����ڴ�д����???
  input  [4:0]  id_ex_rd,           // Ҫд��ļĴ�����???
  input         ex_mem_memWrite,    // �Ƿ����ڴ�д����???

  output    pcFromTaken,  //��ָ֧��ִ�н�����ж��Ƿ���Ԥ�ⷽ��??????
  output    pcStall,    //���������ֹͣ��???
  output    IF_ID_stall,  //��ˮ��IF_ID��ֹͣ��???
  output    ID_EX_stall,  //��ˮ��ID_EX��ֹͣ��???
  output    ID_EX_flush,  //��ˮ��ID_EX��������???
  output    EX_MEM_flush,   //��ˮ��EX_MEM��������???
  output    IF_ID_flush    //��ˮ��IF_ID��������???
);

    reg reg_pcFromTaken;
    reg reg_pcStall;
    reg reg_IF_ID_stall;
    reg reg_ID_EX_stall;
    reg reg_ID_EX_flush;
    reg reg_EX_MEM_flush;
    reg reg_IF_ID_flush;

  // ������ָ֧��������ȽϽ����beqʱ???�����???0��bneʱ???�����0����֧Ԥ��ʧ???
  wire branch_do = ((id_ex_Branch == 1) && (ex_Zero == 0)) || ((id_ex_nBranch == 1) && (ex_Zero == 1));   // �����ָ֧���Ƿ����
  // ȷ�Ϸ�ָ֧����ת����???,����������·�֧Ԥ��ʧ��
  wire ex_mem_taken = id_ex_jr || branch_do;   // �ж��Ƿ�???Ҫ��???

  // �洢����ѡ???�źţ����Դ洢����"��"����???д"�����ź���Чʱ����
  wire id_ex_memAccess = id_ex_memRead | id_ex_memWrite;   // �ж��Ƿ�???Ҫ������???

  // ��ʾ��ˮ����Ҫͣ�٣���ִ??? sw ָ��ʱ�ͻ�������������
  wire ex_mem_need_stall = ex_mem_memWrite;   // �ж��Ƿ�???Ҫͣ???
  
  assign pcFromTaken = reg_pcFromTaken;
  assign pcStall = reg_pcStall;
  assign IF_ID_stall = reg_IF_ID_stall;
  assign ID_EX_stall = reg_ID_EX_stall;
  assign ID_EX_flush = reg_ID_EX_flush;
  assign EX_MEM_flush =  reg_EX_MEM_flush;
  assign IF_ID_flush = reg_IF_ID_flush;

 always @(*) begin
    /* 
    ��֧Ԥ��ʧ�ܵ���???
    ����ָ֧��ִ��֮��������ַ�֧��ת�ķ�����Ԥ�ⷽ��һ��???
    ��ʱ����Ҫ��ˢ��ˮ�ߣ��������ȡָ???����׶ε�ָ�����ݣ���??? PC ֵ???
    */
    // branch prediction fail or jr appears
    if(ex_mem_taken) begin      // ���???Ҫ��???
      reg_pcFromTaken  = 1;            // ��ת
      reg_pcStall      = 0;            // ��ͣ???
      reg_IF_ID_flush  = 1;            // ��� IF/ID
      reg_ID_EX_flush  = 1;            // ��� ID/EX
      reg_EX_MEM_flush = 0;            // ����??? EX/MEM
    end
    /* 
    ����ð������???
    ��ǰ???��ָ���� Load����???��ָ���Դ�Ĵ��� rs ??? rt ������ǰ???���Ӵ洢���ж�������ֵ��
    ???Ҫ�� Load ָ��֮���ָ��ͣ��һ��ʱ�����ڣ����һ�Ҫ��ˢ ID _EX �׶ε�ָ������???
    */
    else if(id_ex_memRead & (id_ex_rd == rs || id_ex_rd == rt)) begin   // ���???Ҫ�����ڴ���???Ҫͣ???
      reg_pcFromTaken = 0;             // ����???
      reg_pcStall     = 1;             // ͣ��
      reg_IF_ID_stall = 1;             // IF/ID ͣ��
      reg_ID_EX_flush = 1;             // ��� ID/EX
    end
    /* 
    ���һ������???Respect???
    */
    else begin                      // �������Ҫͣ��Ҳ����Ҫ��???
      reg_pcFromTaken    = 0;          // ����???
      reg_pcStall        = 0;          // ��ͣ???
      reg_IF_ID_stall    = 0;          // ��ͣ??? IF/ID
      reg_ID_EX_stall    = 0;          // ��ͣ??? ID/EX
      reg_ID_EX_flush    = 0;          // ����??? ID/EX
      reg_EX_MEM_flush   = 0;          // ����??? EX/MEM 
      reg_IF_ID_flush    = 0;          // ����??? IF/ID
    end
  end

  
endmodule