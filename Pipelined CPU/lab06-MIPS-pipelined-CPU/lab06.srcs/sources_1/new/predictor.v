`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 17:51:58
// Design Name: 
// Module Name: predictor
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


module predictor(
        input branch,//ID是否检测到BEQ
        input [31:0] iniPC,
        input [31:0] iniPCForUpd,
        input reset,
        input branchTaken,
        input [31:0] branchPC,
        output [31:0] predBranchPC 
    );
    //predict
    assign predBranchPC = iniPC + 4;
    //upd in ID
endmodule
/*
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/28 17:51:58
// Design Name: 
// Module Name: predictor
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


module predictor(
        input branch,//ID是否检测到BEQ
        input [31:0] iniPC,
        input [31:0] iniPCForUpd,
        input reset,
        input branchTaken,
        input [31:0] branchPC,
        output [31:0] predBranchPC 
    );
    reg [31:0] BTB[63:0];     //Branch target buffer
    reg [1:0] BHT[4095:0];    //Branch History Table
    wire [31:0] BTB_VALUE;//6bits index
    wire [1:0] BHT_VALUE;  //1024 * 2 * 2 12 bits
    reg [31:0] tmp;
    integer i;
    assign BTB_VALUE = BTB[iniPC & 6'b111111];
    assign BHT_VALUE = BHT[iniPC & 12'b111111111111];
    
    
    //predict
    assign predBranchPC = (BHT_VALUE & 2'b10) ? BTB_VALUE : iniPC + 4;
    //upd in ID
    always @ (iniPC or iniPCForUpd or branchTaken or branchPC)
    begin
        if(branch)
        begin
            tmp = branchPC;
            if (branchTaken == 1)
            begin
                if(BHT_VALUE < 2'b11) BHT[iniPCForUpd & 12'b111111111111] = BHT[iniPCForUpd & 12'b111111111111] + 1;
                BTB[iniPCForUpd & 6'b111111] = branchPC;
            end
            else
            begin
                if(BHT_VALUE > 2'b00) BHT[iniPCForUpd & 12'b111111111111] = BHT[iniPCForUpd & 12'b111111111111] - 1;
            end
        end
    end
    
    
    initial begin
        tmp = 0;
        for(i = 0; i < 64; i = i + 1)
        begin
            BTB[i] = 0;
        end
        
        for(i = 0; i < 4096; i = i + 1)
        begin
            BHT[i] = 0;
        end
    end
endmodule

*/