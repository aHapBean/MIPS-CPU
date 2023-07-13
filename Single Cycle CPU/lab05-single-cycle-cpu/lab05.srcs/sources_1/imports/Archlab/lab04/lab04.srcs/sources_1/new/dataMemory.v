`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 22:08:46
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
        input Clk,
        input [31:0] address,
        input [31:0] writeData,
        input [31:0] Op1,
        input [31:0] Op2,
        input memRead,
        input memWrite,
        output reg [31:0] readData,//����wire assign �� reg��ʲô��ͬ
        output [31:0] Out
    );
    
    reg [31:0] memFile[0:255];//Q5 �ڲ�
    integer i;
    initial begin
        for(i = 0; i < 255; i = i + 1)
            memFile[i] = 1; 
        readData = 0;
        //$readmemh("E:/Archlab/lab05/lab05.srcs/data",memFIle); 
    end
    assign Out = memFile[2];//mem[2]������
    always @ (memWrite or memRead or address)//����ֵӦ�ò���ı�,����ֱ��assign��
        begin
            if (memRead == 1)
            begin
                readData = memFile[address >> 2];
            end
        end
    always @ (negedge Clk) // to change
        begin
            memFile[0] = Op1;//
            memFile[1] = Op2;
            if (memWrite)
                memFile[address >> 2] = writeData;
        end
endmodule
