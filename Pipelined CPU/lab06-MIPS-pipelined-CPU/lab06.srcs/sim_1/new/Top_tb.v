`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 17:04:37
// Design Name: 
// Module Name: Top_tb
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


module Top_tb(

    );
    reg Clk;
    reg Reset;
    reg [3:0] a;
    reg [3:0] b;
    
    wire [31:0] Op1;
    assign Op1 = {28'b0,a};
    wire [31:0] Op2;
    assign Op2 = {28'b0,b};
    wire [31:0] Out;
    always #1 Clk = ~Clk;
    Top cpu(
        .Op1(Op1),
        .Op2(Op2),
        .Out(Out),
        .Clk(Clk),
        .Reset(Reset)
    );
    
    initial begin
        a = 9;
        b = 13;
        Clk = 0;
        Reset = 1;
        # 5
        a = 11;
        b = 13;//ȷʵûë��
        # 25;
        Reset = 0;
    end
endmodule
