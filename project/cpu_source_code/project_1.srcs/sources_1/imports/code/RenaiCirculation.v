`timescale 1ns / 1ps

module RenaiCirculation(
    input clk,
    input enable, 
    output reg[0:0] music = 0
 );

parameter do_low = 382225;
parameter re_low = 340524;
parameter me_low = 303372;
parameter fa_low = 286345;
parameter so_low = 255105;
parameter la_low = 227272;
parameter si_low = 202476;

parameter do = 191110;
parameter re = 170259;
parameter me = 151685;
parameter fa = 143172;
parameter so = 127554;
parameter la = 113636;
parameter si = 101239;


parameter note_period = 15_000_000;
parameter rest =  3_750_000;
parameter index_period = note_period + rest;

parameter silence = 30'h3fff_ffff;

reg [1015:0] melody = 1016'b10001001100010001000101010100000100000001010000011011010000010101001100010011010101000001001000010100000110000001001101010001001101010100000100100001010000011011010000010101001100010011010101000001001000010100000110000001000100110000000100001101000100010100110100010001010101110101011110000001100101110101011101000001100101110101011101000001010011010000000100001101000100010100110100010001010101110101011110000001100101110101011101000001100101110101011101000001000100100001000101010110000010100001000010100001000000001010000100001010000100001011000000010101001100000001000010110000000101010011000000010001010000001100000100010101011000001010000100001010000100000000101000010000101000010000101100000001010100110000000100001011000000010101001100000001000000010001010100000001000100110000000100001010110000001100101100000001010010101100000011001011000000010000101011000000110010100001010011010000000100010011000000010000101011000000110010100001010000010000101011000000110010110000000100001010110000001100101100010101000;

parameter length = 254;

reg[29:0] cur_half_period =  note_period;

integer cur_half_period_count = 0;      // inverse buzzer if cur_half_period_count > note_period
integer index_count = 0;      // add index by 1 if index_count > index_period
integer index = 0;       // index control the location music playing

always @(posedge clk) begin
    
    if(enable == 0) begin
        index = 0;
        index_count = 0;
        cur_half_period_count = 0;
        music = 0;
    end
    else begin
        if(cur_half_period_count >= cur_half_period) begin
            cur_half_period_count = 0;
            music = ~music;
         end
        else 
            cur_half_period_count = cur_half_period_count + 1;
        if(index_count > index_period) begin
            index_count = 0;
            index = index + 1;
        end
        if(index >length) begin
            index = 0;
        end
    end
    index_count = index_count + 1;
end

always @ * begin
    if(index_count <= rest)
        cur_half_period = silence;
    else
        case(melody[index * 4 +3 -:4])
            4'd0 : cur_half_period = silence;
            4'd1 : cur_half_period = do_low;
            4'd2 : cur_half_period = re_low;
            4'd3 : cur_half_period = me_low;
            4'd4 : cur_half_period = fa_low;
            4'd5 : cur_half_period = so_low;
            4'd6 : cur_half_period = la_low;
            4'd7 : cur_half_period = si_low;
            4'd8 : cur_half_period = do;
            4'd9 : cur_half_period = re;
            4'd10 : cur_half_period = me;
            4'd11: cur_half_period = fa;
            4'd12 : cur_half_period = so;
            4'd13 : cur_half_period = la;
            4'd14 : cur_half_period = si;
            default : cur_half_period = silence;
        endcase
end

endmodule