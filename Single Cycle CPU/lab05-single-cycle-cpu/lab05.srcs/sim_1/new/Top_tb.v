`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 20:45:03
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
    reg reset;
    reg [4:0] a;
    reg [4:0] b;
    Top SingleCycleCPU(
        .Clk(Clk),
        .a(a),
        .b(b),
        .Reset(!reset)
    );
    always #50 Clk = ~Clk;
    initial begin
        Clk = 1;
        reset = 1;
        
        # 25;
        reset = 0;
        # 200;
        reset = 1;
        # 300
        reset = 0;
    end
endmodule
