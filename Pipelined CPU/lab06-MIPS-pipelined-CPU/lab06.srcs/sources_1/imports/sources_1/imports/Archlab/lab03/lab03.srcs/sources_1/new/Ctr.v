`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 10:40:23
// Design Name: 
// Module Name: Ctr
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
module Ctr(
    input [5:0] opCode,
    output reg regDst,
    output reg aluSrc,
    output reg memToReg,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg branch,
    output reg [3:0] aluOp,
    output reg signExtFlag,//add !
    output reg jalFlag
    );
    always @(opCode)//no conflict between two always !
    begin
        case(opCode)
            6'b000011:
            begin
                jalFlag = 1;
            end
            default:
            begin
                jalFlag = 0;
            end
        endcase
    end
    always @(opCode)
    begin
        case(opCode)
            6'b001001://addiu
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0110;//TODO
                signExtFlag = 0;
            end
            6'b001110://xori
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0111;//TODO
                signExtFlag = 0;
            end
            6'b001111://lui
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b1000;//TODO
                signExtFlag = 0;
            end
            6'b001010://slti
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b1010;//TODO
                signExtFlag = 1;
            end
            6'b001011://sltiu
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b1011;//TODO
                signExtFlag = 0;
            end
            6'b000101://bne
            begin
                regDst = 0;//X
                aluSrc = 0;
                memToReg = 0;//X
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 1;
                aluOp = 4'b0001;
                signExtFlag = 1; 
            end
            6'b001000://addi
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm sign extend
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0011;//TODO
                signExtFlag = 1;
            end
            6'b001100://andi
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm zero extend
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0100;//TODO
                signExtFlag = 0;
            end
            6'b001101://ori
            begin
                regDst = 0;//rt
                aluSrc = 1;//imm zero extend
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0101;//TODO
                signExtFlag = 0;//zero extend
            end
            6'b000000://R type
            begin
                regDst = 1;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 1;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0010;
                signExtFlag = 0;//srl,sll !!!
                //signExtFlag = 1;no extend
            end
            6'b100011://load type
            begin
                regDst = 0;
                aluSrc = 1;
                memToReg = 1;
                regWrite = 1;
                memRead = 1;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
            
            6'b101011://Store
            begin
                regDst = 0;//X
                aluSrc = 1;
                memToReg = 0;//X
                regWrite = 0;
                memRead = 0;
                memWrite = 1;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
        
            6'b000100://beq
            begin
                regDst = 0;//X
                aluSrc = 0;
                memToReg = 0;//X
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 1;
                aluOp = 4'b0001;
                signExtFlag = 1;
            end
            
            6'b000010://Jump
            begin
                regDst = 0;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
            6'b000011://jal
            begin
                regDst = 0;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
            6'b111111://nop
            begin
                regDst = 0;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
            default:
            begin
                regDst = 0;
                aluSrc = 0;
                memToReg = 0;
                regWrite = 0;
                memRead = 0;
                memWrite = 0;
                branch = 0;
                aluOp = 4'b0000;
                signExtFlag = 1;
            end
        endcase
    end
endmodule