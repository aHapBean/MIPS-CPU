`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/10 10:01:40
// Design Name: 
// Module Name: instMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instMemory(
        input PC_Clk,
        input [31:0] address,
        output [31:0] readData//这里wire assign 和 reg有什么不同
    );
    reg [31:0] memFile[0:31];
    integer i;
    initial begin
        //$readmemb("D:/Archlab/lab05/lab05.srcs/instruction",memFile);
        for(i = 11; i <= 31; i = i + 1)
            memFile[i] = 0; 
        memFile[0] = 32'b10001100011000010000000000000000;  //lw $1, 0($3)
        memFile[1] = 32'b10001100011000100000000000000100;  //lw $2, 4($3)
        memFile[2] = 32'b00000000000000100010000001000010;
        memFile[3] = 32'b00000000000001000010100001000000;
        memFile[4] = 32'b00010000010001010000000000000001;
        memFile[5] = 32'b00000001000000010100000000100000;
        memFile[6] = 32'b00000000000000100001000001000010;
        memFile[7] = 32'b00000000000000010000100001000000;
        memFile[8] = 32'b00010000011000100000000000000001;
        memFile[9] = 32'b00001000000000000000000000000010;
        memFile[10] = 32'b10101100011010000000000000001000;
            /*
        memFile[0] = 32'b000000_00011_00010_00001_00000_100000;//寄存器加 add $1,$2,$3 b000000_00011_00010_00001_00000_100000
        memFile[1] = 32'b000000_00011_00010_00001_00000_100010;//sub b000000_00011_00010_00001_00000_100010
        memFile[2] = 32'b000000_00011_00010_00001_00000_100100;//and
        memFile[3] = 32'b000000_00011_00010_00001_00000_100101;//or
        memFile[4] = 32'b000000_00011_00010_00001_00000_100110;//xor b000000_00011_00010_00001_00000_100110
        memFile[5] = 32'b000000_00011_00010_00001_00000_101010;//slt
        memFile[6] = 32'b101011_00011_00010_00000_00000_001010;//sw $2,10($3) 
        memFile[7] = 32'b100011_00011_00001_00000_00000_001010;//lw $1,10($3)
        */
        /*
        自创测例1：
        00000000011000100000100000100000
        00000000011000100000100000100010
        00000000011000100000100000100100
        00000000011000100000100000100101
        00000000011000100000100000100110
        00000000011000100000100000101010
        10101100011000100000000000001010
        10001100011000010000000000001010
        */
        //memFile[8] = 
    end
    assign readData = memFile[(address >> 2)];//here !!!!!
endmodule
