`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 11:01:42
// Design Name: 
// Module Name: forwardingUnit
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

module forwardingUnit(
        input ID_OR_EX,
        input [31:0] ID_EX_RegReadData1,
        input [31:0] ID_EX_RegReadData2,
        input [31:0] ID_EX_Ext,
        input ID_EX_ALUSrc,
        //for forwarding
        input [4:0] ID_EX_ReadReg1,
        input [4:0] ID_EX_ReadReg2,
        input [4:0] EX_MEM_WriteReg,
        input EX_MEM_RegWrite,
        input [31:0] EX_MEM_RegWriteData,
        input [4:0] MEM_WB_WriteReg,
        input MEM_WB_RegWrite,
        input [31:0] MEM_WB_RegWriteData,
        input [4:0] WB_XX_WriteReg,
        input WB_XX_RegWrite,
        input [31:0] WB_XX_RegWriteData,
        output [31:0] ALUSrc1,
        output [31:0] ALUSrc2
    );
    assign ALUSrc1 = EX_MEM_RegWrite && (EX_MEM_WriteReg == ID_EX_ReadReg1) ? EX_MEM_RegWriteData
                 : MEM_WB_RegWrite && MEM_WB_WriteReg == ID_EX_ReadReg1 ? MEM_WB_RegWriteData
                 : WB_XX_RegWrite && WB_XX_WriteReg == ID_EX_ReadReg1 ? WB_XX_RegWriteData  
                 : ID_EX_RegReadData1;
    assign ALUSrc2 = EX_MEM_RegWrite && (EX_MEM_WriteReg == ID_EX_ReadReg2) ? EX_MEM_RegWriteData
                     : MEM_WB_RegWrite && MEM_WB_WriteReg == ID_EX_ReadReg2 ? MEM_WB_RegWriteData
                     : WB_XX_RegWrite && WB_XX_WriteReg == ID_EX_ReadReg2 ? WB_XX_RegWriteData  
                     : (ID_EX_ALUSrc && ID_OR_EX) ? ID_EX_Ext : ID_EX_RegReadData2;
endmodule
//assign ALUSrc1 = ID_EX_RegReadData1;//优先要EXstage 的forwarding
//assign ALUSrc2 = ID_EX_ALUSrc ? ID_EX_Ext : ID_EX_RegReadData2;
//EX优先,MEM_WB次之，WB_XX最后
//assign ALUSrc1 = (EX_MEM_RegWrite && (EX_MEM_WriteReg == ID_EX_ReadReg1)) ? EX_MEM_RegWriteData : ((MEM_WB_RegWrite && MEM_WB_WriteReg == ID_EX_ReadReg1) ? MEM_WB_RegWriteData : ID_EX_RegReadData1);
//assign ALUSrc2 = (EX_MEM_RegWrite && (EX_MEM_WriteReg == ID_EX_ReadReg2)) ? EX_MEM_RegWriteData : ((MEM_WB_RegWrite && MEM_WB_WriteReg == ID_EX_ReadReg2) ? MEM_WB_RegWriteData : ((ID_EX_ALUSrc) ? ID_EX_Ext : ID_EX_RegReadData2) ); 
