`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/31 08:29:03
// Design Name: 
// Module Name: TopBoard
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


module TopBoard(
        input clk_p,
        input clk_n,
        input [3:0] a,
        input [3:0] b,
        input Reset,
        
        output led_clk,
        output led_do,
        output led_en,
        output seg_clk,
        output seg_en,
        output seg_do
    );
    wire Clk_i;
    wire Clk_25M;
    IBUFGDS IBUFGDS_inst(
        .O(Clk_i),
        .I(clk_p),
        .IB(clk_n)
    );
    
    wire [31:0] Op1;
    assign Op1 = {28'b0,a};
    wire [31:0] Op2;
    assign Op2 = {28'b0,b};
    wire [31:0] Out;
    
    
    
    reg [1:0] clkdiv;
    always@(posedge Clk_i)
    begin
        clkdiv <= clkdiv + 1;
    end
    assign Clk_25M = clkdiv[1];

    wire Clk;
    assign Clk = Clk_25M;
    
    display DISPLAY(
        .clk(Clk_25M),
        .rst(1'b0),
        .en(8'b11111111),
        .data({Op1[3:0],4'b0 ,Op2[3:0], 4'b0,Out[15:0]}),
        .dot(8'b00000000),
        .led(~Out[15:0]),
        .led_clk(led_clk),
        .led_en(led_en),
        .led_do(led_do),
        .seg_clk(seg_clk),
        .seg_en(seg_en),
        .seg_do(seg_do)
    );
    
    Top cpu(
        .Op1(Op1),
        .Op2(Op2),
        .Out(Out),
        .Clk(Clk),
        .Reset(!Reset)
    );
    
endmodule
