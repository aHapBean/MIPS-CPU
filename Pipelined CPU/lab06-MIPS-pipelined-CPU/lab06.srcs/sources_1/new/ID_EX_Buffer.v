`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 21:18:22
// Design Name: 
// Module Name: ID_EX_Buffer
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


module ID_EX_Buffer(
        input Clk,
        input [4:0] rt,
        input [4:0] rd,
        input [31:0] ext,
        input [31:0] regReadData1,
        input [31:0] regReadData2,
        input [31:0] IF_ID_PC,
        input regDst,
        input aluSrc,
        input regWrite,//is a flag !!
        input memRead,
        input memWrite,
        input branch,
        input [2:0] aluOp,
        input jump,
        input jalFlag,
        
        output reg [4:0] ID_EX_Rt,
        output reg [4:0] ID_EX_Rd,
        output reg [31:0] ID_EX_Ext,
        output reg [31:0] ID_EX_RegReadData1,
        output reg [31:0] ID_EX_RegReadData2,
        output reg [31:0] ID_EX_PC,
        output reg ID_EX_RegDst,
        output reg ID_EX_ALUSrc,
        output reg ID_EX_RegWrite,//is a flag !!
        output reg ID_EX_MemRead,
        output reg ID_EX_MemWrite,
        output reg ID_EX_Branch,
        output reg [2:0] ID_EX_ALUOp,
        output reg ID_EX_Jump,
        output reg ID_EX_JalFlag
    );
    always @ (negedge Clk)//ÏÂ½µÑØ²Ù×÷
    begin
        ID_EX_Rt = rt;
        ID_EX_Rd = rd;
        ID_EX_Ext = ext;
        ID_EX_RegReadData1 = regReadData1;
        ID_EX_RegReadData2 = regReadData2;
        ID_EX_PC = IF_ID_PC;
        ID_EX_RegDst = regDst;
        ID_EX_ALUSrc = aluSrc;
        ID_EX_RegWrite = regWrite;
        ID_EX_MemRead = memRead;
        ID_EX_MemWrite = memWrite;
        ID_EX_Branch = branch;
        ID_EX_ALUOp = aluOp;
        ID_EX_Jump = jump;
        ID_EX_JalFlag = jalFlag;
    end
endmodule
