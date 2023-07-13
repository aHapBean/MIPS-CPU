`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 16:36:00
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [3:0] ALUOp,
    input [5:0] Funct,
    output reg jrFlag,
    output reg [4:0] ALUCtrOut
    );
    always @ (ALUOp or Funct)
    begin
        casex ({ALUOp,Funct})
            10'b0110xxxxxx://addiu
            begin
                ALUCtrOut = 5'b10010;
                jrFlag = 0;
            end
            10'b0111xxxxxx://xori 
            begin
                ALUCtrOut = 5'b01011;
                jrFlag = 0;
            end
            10'b1000xxxxxx://lui
            begin
                ALUCtrOut = 5'b10011;
                jrFlag = 0;
            end
            10'b1010xxxxxx:
            begin
                ALUCtrOut = 5'b00111;
                jrFlag = 0;
            end
            10'b1011xxxxxx:
            begin
                ALUCtrOut = 5'b01101;
                jrFlag = 0;
            end
            10'b0011xxxxxx : 
            begin
                ALUCtrOut = 5'b00010;//addi
                jrFlag = 0;//no reg write !
            end
            10'b0100xxxxxx : 
            begin
                ALUCtrOut = 5'b00000;//andi
                jrFlag = 0;
            end
            10'b0101xxxxxx : 
            begin
                ALUCtrOut = 5'b00001;//ori
                jrFlag = 0;
            end
            10'b0000xxxxxx : 
            begin
                ALUCtrOut = 5'b00010;
                jrFlag = 0;
            end
            10'b0001xxxxxx : 
            begin
                ALUCtrOut = 5'b00110;
                jrFlag = 0;
            end
            10'b0010_100011://subu R type
            begin
                ALUCtrOut = 5'b01010;
                jrFlag = 0;
            end
            10'b0010_100110://xor R type
            begin
                ALUCtrOut = 5'b01011;
                jrFlag = 0;
            end
            10'b0010_100111://nor
            begin
                ALUCtrOut = 5'b01100;
                jrFlag = 0;
            end
            10'b0010_101011://sltu
            begin
                ALUCtrOut = 5'b01101;
                jrFlag = 0;
            end
            10'b0010_000011://sra
            begin
                ALUCtrOut = 5'b01110;
                jrFlag = 0;
            end
            10'b0010_000100://sllv
            begin
                ALUCtrOut = 5'b01111; 
                jrFlag = 0;
            end
            10'b0010_000110://srlv
            begin
                ALUCtrOut = 5'b10000; 
                jrFlag = 0;
            end
            10'b0010_000111://srav
            begin
                ALUCtrOut = 5'b10001; 
                jrFlag = 0;
            end
            10'b0010_000000 :
            begin
                ALUCtrOut = 5'b01000;//sll
                jrFlag = 0;
            end
            10'b0010_000010 : 
            begin
                ALUCtrOut = 5'b01001;//srl
                jrFlag = 0;
            end
            10'b0010_001000 : 
            begin
                ALUCtrOut = 5'b00010;//jr add º¥ø…£¨”Î0add £°£°£°
                jrFlag = 1;
            end
            10'b0010_100000 : 
            begin
                ALUCtrOut = 5'b00010;//R type
                jrFlag = 0;
            end
            10'b0010_100010 : 
            begin
                ALUCtrOut = 5'b00110;//sub
                jrFlag = 0;
            end
            10'b0010_100001://addu
            begin
                ALUCtrOut = 5'b10010;
                jrFlag = 0;
            end
            10'b0010xx0100 : 
            begin
                ALUCtrOut = 5'b00000;
                jrFlag = 0;
            end
            10'b0010xx0101 : 
            begin
                ALUCtrOut = 5'b00001;
                jrFlag = 0;
            end
            10'b0010xx1010 : 
            begin
                ALUCtrOut = 5'b00111;
                jrFlag = 0;
            end
        endcase
    end
endmodule
