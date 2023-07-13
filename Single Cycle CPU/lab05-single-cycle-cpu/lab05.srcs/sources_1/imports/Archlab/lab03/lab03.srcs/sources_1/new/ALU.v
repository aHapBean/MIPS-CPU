`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 10:23:50
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [31:0] input1,
    input [31:0] input2, 
    input [3:0] aluCtr, 
    input [10:6] shamt,
    output reg zero, 
    output reg [31:0] aluRes);
    always @ (input1 or input2 or aluCtr)
    begin
        case (aluCtr)
            4'b1000://sll
            begin
                aluRes = input2 << shamt;
            end
            4'b1001://srl
            begin
                aluRes = input2 >> shamt;
            end
            //4'b1010://jr
            //begin
            //    aluRes = input1;//rs !
            //end
            4'b0000://AND
            begin
                aluRes = input1 & input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            4'b0001://OR
            begin
                aluRes = input1 | input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            4'b0010://ADD
            begin
                aluRes = input1 + input2;
            end
            4'b0110://SUB
            begin
                aluRes = input1 - input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            4'b0111://SLT Set on less than
            begin
                aluRes = input1 - input2;
                if (aluRes[31] == 1) // input1 < input2
                    aluRes = 1;
                else
                    aluRes = 0;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;    
                
            end
            4'b1100://NOR
            begin
                aluRes = ~(input1 | input2);
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
        endcase
    end
endmodule
