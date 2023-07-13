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
    input [2:0] ALUOp,
    input [5:0] Funct,
    output reg jrFlag,
    output reg [3:0] ALUCtrOut
    );
    always @ (ALUOp or Funct)
    begin
        casex ({ALUOp,Funct})
            9'b011xxxxxx : 
            begin
                ALUCtrOut = 4'b0010;//addi
                jrFlag = 0;
            end
            9'b100xxxxxx : 
            begin
                ALUCtrOut = 4'b0000;//andi
                jrFlag = 0;
            end
            9'b101xxxxxx : 
            begin
                ALUCtrOut = 4'b0001;//ori
                jrFlag = 0;
            end
            9'b000xxxxxx : 
            begin
                ALUCtrOut = 4'b0010;
                jrFlag = 0;
            end
            9'b001xxxxxx : 
            begin
                ALUCtrOut = 4'b0110;
                jrFlag = 0;
            end
            9'b010_000000 : 
            begin
                ALUCtrOut = 4'b1000;//sll
                jrFlag = 0;
            end
            9'b010_000010 : 
            begin
                ALUCtrOut = 4'b1001;//srl
                jrFlag = 0;
            end
            9'b010_001000 : 
            begin
                ALUCtrOut = 4'b0010;//jr
                jrFlag = 1;
            end
            9'b010_100000 : 
            begin
                ALUCtrOut = 4'b0010;//R type
                jrFlag = 0;
            end
            9'b010_100010 : 
            begin
                ALUCtrOut = 4'b0110;//sub
                jrFlag = 0;
            end
            9'b010xx0100 : 
            begin
                ALUCtrOut = 4'b0000;
                jrFlag = 0;
            end
            9'b010xx0101 : 
            begin
                ALUCtrOut = 4'b0001;
                jrFlag = 0;
            end
            9'b010xx1010 : 
            begin
                ALUCtrOut = 4'b0111;
                jrFlag = 0;
            end
        endcase
    end
endmodule
