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
    input [4:0] aluCtr, 
    input [10:6] shamt,
    output reg zero, 
    output reg [31:0] aluRes);
    always @ (input1 or input2 or aluCtr)
    begin
        case (aluCtr)
            5'b01000://sll
            begin
                aluRes = input2 << shamt;
            end
            5'b01001://srl
            begin
                aluRes = input2 >> shamt;
            end
            //4'b1010://jr
            //begin
            //    aluRes = input1;//rs !
            //end
            5'b00000://AND
            begin
                aluRes = input1 & input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            5'b00001://OR
            begin
                aluRes = input1 | input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            5'b00010://ADD
            begin
                aluRes = input1 + input2;
            end
            5'b00110://SUB
            begin
                aluRes = input1 - input2;
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            5'b00111://SLT Set on less than
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
            5'b01100://NOR 正好和我的编号一样
            begin
                aluRes = ~(input1 | input2);
                if (aluRes == 0)
                    zero = 1;
                else
                    zero = 0;
            end
            5'b01010://subu verilog默认有符号数+-
            begin
                aluRes = $unsigned(input1) - $unsigned(input2);
                if (aluRes == 0)
                    zero = 1;
                else 
                    zero = 0;
            end
            5'b01011://xor
            begin
                aluRes = input1 ^ input2;
                if (aluRes == 0) zero = 1;
                else zero = 0;
            end
            5'b01101://sltu
            begin
                if ($unsigned(input1) < $unsigned(input2))
                    aluRes = 1;
                else
                    aluRes = 0;
            end
            5'b01110://sra
            begin
                aluRes = input2 >>> shamt;
            end
            5'b01111://sllv
            begin
                aluRes = input2 << input1;//rt << rs
            end
            5'b10000://srlv
            begin
                aluRes = input2 >> input1;
            end
            5'b10001://srav
            begin
                aluRes = input2 >>> input1;
            end
            5'b10010://addu
            begin
                aluRes = $unsigned(input1) + $unsigned(input2);
                if (aluRes == 0) zero = 0;
                else zero = 0;
            end
            5'b10011://lu
            begin
                aluRes = (input2 << 16);    //*65536
            end
            
        endcase
    end
endmodule
