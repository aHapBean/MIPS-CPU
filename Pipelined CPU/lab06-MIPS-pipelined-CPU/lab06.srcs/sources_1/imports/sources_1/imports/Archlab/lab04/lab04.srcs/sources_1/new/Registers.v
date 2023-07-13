`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 16:23:57
// Design Name: 
// Module Name: Registers
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


module Registers(
    input reset,
    input Clk,
    input [25:21] readReg1,//rs
    input [20:16] readReg2,//rt  Q3 ²»Ó°Ïì
    input [4:0] writeReg,//rd
    input [31:0] writeData,
    input regWrite,
    input jalFlag,
    output [31:0] readData1,
    output [31:0] readData2//Q4
    );
    reg [31:0] regFile[31:0];
    integer i;
    initial begin//remember to initialize
        for(i = 0; i < 32; i = i + 1)
            regFile[i] = 0;
        regFile[1] = 1;
        //regFile[2] = 1;
        //regFile[3] = 2;
    end
    assign readData1 = regFile[readReg1];
    assign readData2 = regFile[readReg2];
    always @ (negedge Clk)//???
        begin
            if(reset == 1)
            begin
                for(i = 0; i < 32; i = i + 1)
                    regFile[i] = 0;
                regFile[1] = 1;
            end
            if (regWrite)
                regFile[writeReg] = writeData;
            if (jalFlag)
                regFile[31] = writeData;
        end
endmodule
