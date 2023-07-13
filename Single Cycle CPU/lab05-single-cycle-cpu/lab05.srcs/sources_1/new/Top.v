`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/10 09:57:46
// Design Name: 
// Module Name: Top
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

/*
命名规则：
    //PC ALU (special，当A,P大写时它们均大写
    //部件实例化名称 均小写，用横线分隔
    //模块名称 首字母小写，之后大写，如果单个单词，则首字母大写
    //模块接口变量名 首字母小写，同上
    //变量名 首字母大写
*/
module Top(
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
    reg [31:0] PC;
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
        .data({data_memory.memFile[0][3:0],4'b0 ,data_memory.memFile[1][3:0], 4'b0,data_memory.memFile[2][15:0]}),
        .dot(8'b00000000),
        .led(~Out[15:0]),
        .led_clk(led_clk),
        .led_en(led_en),
        .led_do(led_do),
        .seg_clk(seg_clk),
        .seg_en(seg_en),
        .seg_do(seg_do)
    );
    /*
    时序逻辑:
    下降沿： 写reg,写mem
    上升沿： update PC
    */
    //读取指令
    wire [31:0] Inst;
    instMemory inst_memory(
        .PC_Clk(Clk),
        .address(PC),
        .readData(Inst)
    );
    wire RegDst,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignExtFlag,JalFlag;
    wire [2:0] ALUOp;
    Ctr ctr (
        .opCode(Inst[31:26]),
        .regDst(RegDst),
        .aluSrc(ALUSrc),
        .memToReg(MemToReg),
        .regWrite(RegWrite),
        .memRead(MemRead),
        .memWrite(MemWrite),
        .branch(Branch),
        .aluOp(ALUOp),
        .jump(Jump),
        .signExtFlag(SignExtFlag),
        .jalFlag(JalFlag)
    );
    
    //访问寄存器
    wire [4:0] WriteReg;
    wire JrFlag;
    wire [31:0] RegWriteData,RegReadData1,RegReadData2;     //mux
    assign WriteReg = RegDst ? Inst[15:11] : Inst[20:16];   //mux
    Registers registers(
        .reset(Reset),
        .Clk(Clk),
        .Op1(Op1),
        .Op2(Op2),
        .readReg1(Inst[25:21]),
        .readReg2(Inst[20:16]),
        .writeReg(WriteReg),
        .writeData(RegWriteData),
        .regWrite(RegWrite ^ JrFlag),
        .jalFlag(JalFlag),
        .readData1(RegReadData1),
        .readData2(RegReadData2)
    );
    //sign extend
    wire [31:0] Ext;
    signext sign_ext(
        .inst(Inst[15:0]),
        .signExtFlag(SignExtFlag),
        .data(Ext)
    );
    
    //指令执行，ALU,ALUCtr
    wire [31:0] ALUSrc1,ALUSrc2;
    wire [3:0] ALUCtrOut;
    wire Zero;
    wire [31:0] ALURes;
    assign ALUSrc1 = RegReadData1;
    assign ALUSrc2 = ALUSrc ? Ext : RegReadData2;
    ALUCtr alu_ctr(
        .ALUOp(ALUOp),
        .Funct(Inst[5:0]),
        .jrFlag(JrFlag),
        .ALUCtrOut(ALUCtrOut)
    );
    wire [4:0] Shamt;
    assign Shamt = Inst[10:6];
    ALU alu(
        .input1(ALUSrc1),
        .input2(ALUSrc2),
        .aluCtr(ALUCtrOut),
        .shamt(Shamt),
        .zero(Zero),
        .aluRes(ALURes)
    );
    
    //内存读写
    wire [31:0] MemAddress;
    wire [31:0] MemWriteData;
    wire [31:0] MemReadData;
    assign MemAddress = ALURes;
    assign MemWriteData = RegReadData2;
    dataMemory data_memory(
        .Clk(Clk),
        .Op1(Op1),
        .Op2(Op2),
        .address(MemAddress),
        .writeData(MemWriteData),
        .memRead(MemRead),
        .memWrite(MemWrite),
        .readData(MemReadData),
        .Out(Out)
    );
    assign RegWriteData = JalFlag ? PC + 4 : (MemToReg ? MemReadData : ALURes);//mux
    wire BranchTaken;
    assign BranchTaken = (Branch & Zero);
    
    //update PC
    always @ (posedge Clk)
    begin
        if(!Reset)
        begin
            PC = 0;
        end
        else
        begin
            if(PC == 40) PC = PC;
            else PC = PC + 4;
            if (Jump == 1)//jmp , jal 
            begin
                PC = {PC[31:28],(Inst[25:0] << 2)};
            end
            else if (BranchTaken == 1)
            begin
                PC = PC + (Ext << 2);
            end
            else if (JrFlag == 1) 
            begin
                PC = ALURes;
            end
        end
    end
    initial begin
        PC = 0;
        $readmemb("E:/Archlab/lab05/lab05.srcs/instruction.txt",inst_memory.memFile);
    end
endmodule
