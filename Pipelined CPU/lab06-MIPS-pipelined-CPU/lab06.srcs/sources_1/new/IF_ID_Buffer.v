`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 21:03:30
// Design Name: 
// Module Name: IF_ID_Buffer
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


module IF_ID_Buffer(
        input Clk,
        input [31:0] PC,
        input [31:0] inst,
        output reg [31:0] IF_ID_PC,
        output reg [31:0] IF_ID_Inst
    );
    always @ (negedge Clk)
    begin
        IF_ID_PC = PC;
        IF_ID_Inst = inst;
    end
    
endmodule
