`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/22 20:57:02
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

module Top(
        input [31:0] Op1,
        input [31:0] Op2,
        output [31:0] Out,
        input Clk,
        input Reset
    );
    reg [31:0] TotalClk;
    
    //IF_ID buffer
    reg [31:0] IF_ID_PC,IF_ID_Inst,IF_ID_iniPC;
    
    //ID_EX buffer
    //data
    reg [4:0] ID_EX_Rt,ID_EX_Rd,ID_EX_ReadReg1,ID_EX_ReadReg2;
    reg [31:0] ID_EX_Ext,ID_EX_RegReadData1,ID_EX_RegReadData2,ID_EX_PC,ID_EX_Inst;
    //ctr
    reg ID_EX_RegDst,ID_EX_ALUSrc,ID_EX_RegWrite,ID_EX_MemRead,ID_EX_MemWrite,ID_EX_Branch,ID_EX_JalFlag,ID_EX_MemToReg;
    reg [3:0] ID_EX_ALUOp;
    
    //EX_MEM buffer
    reg [4:0] EX_MEM_WriteReg;
    reg [31:0] EX_MEM_RegReadData2,EX_MEM_ALURes;
    reg EX_MEM_Zero;
    reg [31:0] EX_MEM_BranchPC;
    reg EX_MEM_RegWrite,EX_MEM_MemWrite,EX_MEM_MemRead,EX_MEM_Branch,EX_MEM_JalFlag,EX_MEM_MemToReg,EX_MEM_JrFlag;
    
    //MEM_WB buffer
    reg [31:0] MEM_WB_MemReadData,MEM_WB_ALURes;
    reg [4:0] MEM_WB_WriteReg;
    //ctr
    reg MEM_WB_MemToReg,MEM_WB_RegWrite,MEM_WB_JrFlag,MEM_WB_JalFlag;
    
    //WB_XX buffer
    reg [31:0] WB_XX_MemReadData,WB_XX_ALURes;
    reg [4:0] WB_XX_WriteReg;
    reg WB_XX_MemToReg,WB_XX_RegWrite;
    
    //IF stage
    reg [31:0] PC;
    wire [31:0] Inst;
    wire Jump;
    wire [31:0] JumpAddress;
    wire Beq;
    wire [31:0] PredBranchPC;
    
    wire [31:0] BranchPC;//for predictor
    wire PCSrc;
    wire Branch;
    
    instMemory inst_memory(
        .PC_Clk(Clk),
        .address(PC),
        .readData(Inst)
    );
    
    assign Jump = (Inst[31:26] == 6'b000010) ?  1'b1 : 1'b0;
    assign JumpAddress = {PC[31:28],(Inst[25:0] << 2)};
    assign Beq = (Inst[31:26] == 6'b000100 || Inst[31:26] == 6'b000101) ? 1'b1 : 1'b0;//BNE & Beq
    predictor predictor(
        .branch(Branch),
        .iniPC(PC),
        .iniPCForUpd(IF_ID_iniPC),
        .reset(Reset),
        .branchTaken(PCSrc),//PCSrc == 1 is symbolize of the ..
        .branchPC(BranchPC),
        .predBranchPC(PredBranchPC)
    );
    
    //ID stage 
    //main control
    wire RegDst,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,SignExtFlag,JalFlag;
    wire [3:0] ALUOp;
    Ctr ctr (
        .opCode(IF_ID_Inst[31:26]),
        .regDst(RegDst),
        .aluSrc(ALUSrc),
        .memToReg(MemToReg),
        .regWrite(RegWrite),
        .memRead(MemRead),  
        .memWrite(MemWrite),
        .branch(Branch),
        .aluOp(ALUOp),
        .signExtFlag(SignExtFlag),
        .jalFlag(JalFlag)
    );
    
    wire [4:0] ReadReg1,ReadReg2,WriteReg;
    wire [31:0] RegWriteData;//for WB
    wire [31:0] RegReadData1,RegReadData2;
    assign ReadReg1 = IF_ID_Inst[25:21];
    assign ReadReg2 = IF_ID_Inst[20:16];
    Registers registers(
        .reset(Reset),
        .Clk(Clk),
        .readReg1(ReadReg1),
        .readReg2(ReadReg2),
        .writeReg(MEM_WB_WriteReg),
        .writeData(RegWriteData), 
        .regWrite(MEM_WB_RegWrite ^ MEM_WB_JrFlag),
        .jalFlag(MEM_WB_JalFlag),
        .readData1(RegReadData1),
        .readData2(RegReadData2)
    );
    wire [31:0] Ext;
    signext sign_ext(
        .inst(IF_ID_Inst[15:0]),
        .signExtFlag(SignExtFlag),
        .data(Ext)
    );
    
    wire [4:0] Rt,Rd;
    assign Rt = IF_ID_Inst[20:16];
    assign Rd = IF_ID_Inst[15:11];
    //add branch in ID
    wire ID_Zero;
    wire [31:0] BeqSrc1,BeqSrc2;
    
    //add bne in ID
    wire BneFlag;
    wire ID_JrFlag; 
    assign ID_JrFlag = (IF_ID_Inst[31:26] == 6'b000000 && IF_ID_Inst[5:0] == 6'b001000) ? 1 : 0;
    assign BneFlag = (IF_ID_Inst[31:26] == 6'b000101) ? 1 : 0;
    assign BranchPC = ID_JrFlag ? BeqSrc1 : IF_ID_iniPC + 4 + (Ext << 2);
    //assign BeqSrc1 = EX_MEM_RegWrite && (EX_MEM_WriteReg == ReadReg1) ? EX_MEM_ALURes : RegReadData1;
    //assign BeqSrc2 = EX_MEM_RegWrite && (EX_MEM_WriteReg == ReadReg2) ? EX_MEM_ALURes : RegReadData2;//added
    wire [31:0] MEM_WB_RegWriteData;
    wire [31:0] WB_XX_RegWriteData;
    
    assign WB_XX_RegWriteData = WB_XX_MemToReg ? WB_XX_MemReadData : WB_XX_ALURes;
    assign MEM_WB_RegWriteData = MEM_WB_MemToReg ? MEM_WB_MemReadData : MEM_WB_ALURes;
    forwardingUnit forwarding_unit_in_ID(//in EX
        .ID_OR_EX(0),
        .ID_EX_RegReadData1(RegReadData1),
        .ID_EX_RegReadData2(RegReadData2),
        .ID_EX_Ext(Ext),
        .ID_EX_ALUSrc(ALUSrc),
        .ID_EX_ReadReg1(ReadReg1),
        .ID_EX_ReadReg2(ReadReg2),
        .EX_MEM_WriteReg(EX_MEM_WriteReg),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),//signal
        .EX_MEM_RegWriteData(EX_MEM_ALURes),
        .MEM_WB_WriteReg(MEM_WB_WriteReg),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_RegWriteData(MEM_WB_RegWriteData),
        .WB_XX_WriteReg(WB_XX_WriteReg),
        .WB_XX_RegWrite(WB_XX_RegWrite),
        .WB_XX_RegWriteData(WB_XX_RegWriteData),
        .ALUSrc1(BeqSrc1),
        .ALUSrc2(BeqSrc2)
    );
    
    
    assign ID_Zero = (BeqSrc1 == BeqSrc2) ? 1 : 0;
    assign PCSrc = ID_JrFlag ? 1 : BneFlag ? ~(Branch & ID_Zero) : (Branch & ID_Zero);//beq and bne and Jr

    
    //EX stage
    wire [31:0] ALUSrc1,ALUSrc2;
    wire [4:0] ALUCtrOut;
    wire Zero;
    wire JrFlag;
    wire [31:0] ALURes;
    assign WriteReg = ID_EX_RegDst ? ID_EX_Rd : ID_EX_Rt;

    forwardingUnit forwarding_unit_in_EX(//in EX
        .ID_OR_EX(1),
        .ID_EX_RegReadData1(ID_EX_RegReadData1),
        .ID_EX_RegReadData2(ID_EX_RegReadData2),
        .ID_EX_Ext(ID_EX_Ext),
        .ID_EX_ALUSrc(ID_EX_ALUSrc),
        .ID_EX_ReadReg1(ID_EX_ReadReg1),
        .ID_EX_ReadReg2(ID_EX_ReadReg2),
        .EX_MEM_WriteReg(EX_MEM_WriteReg),
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_RegWriteData(EX_MEM_ALURes),
        .MEM_WB_WriteReg(MEM_WB_WriteReg),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_RegWriteData(MEM_WB_RegWriteData),
        .WB_XX_WriteReg(WB_XX_WriteReg),
        .WB_XX_RegWrite(WB_XX_RegWrite),
        .WB_XX_RegWriteData(WB_XX_RegWriteData),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2)
    );
    
    ALUCtr alu_ctr(
        .ALUOp(ID_EX_ALUOp),
        .Funct(ID_EX_Ext[5:0]),
        .jrFlag(JrFlag),
        .ALUCtrOut(ALUCtrOut)
    );
    wire [4:0] Shamt;//5-bit
    assign Shamt = ID_EX_Ext[10:6];
    
    ALU alu(
        .input1(ALUSrc1),
        .input2(ALUSrc2),
        .aluCtr(ALUCtrOut),
        .shamt(Shamt),
        .zero(Zero),
        .aluRes(ALURes)
    );
    
    //MEM stage
    wire [31:0] MemAddress;
    wire [31:0] MemWriteData;
    wire [31:0] MemReadData;
    assign MemAddress = EX_MEM_ALURes;
    assign MemWriteData = EX_MEM_RegReadData2;
    dataMemory data_memory(
        .reset(Reset),
        .Clk(Clk),
        .address(MemAddress),
        .writeData(MemWriteData),
        .memRead(EX_MEM_MemRead),
        .memWrite(EX_MEM_MemWrite),
        .Op1(Op1),
        .Op2(Op2),
        .Out(Out),
        .readData(MemReadData)
    );
    
    
    //WB stage 
    assign RegWriteData = MEM_WB_MemToReg ? MEM_WB_MemReadData : MEM_WB_ALURes;
    reg NOP;
    reg STALL;
    reg BranchSTALL;
    reg NOP_run;
    reg [1:0] Restart;
    reg [31:0] Tmp;
    always @ (posedge Clk)
    begin
        if(BranchSTALL)
        begin
            BranchSTALL = 0;
        end
        if (ID_EX_MemToReg == 1 && ID_EX_RegWrite == 1 && (WriteReg == ReadReg1 || WriteReg == ReadReg2))
        begin       
            STALL <= 1;
        end
        if (Branch == 1 && ID_EX_RegWrite == 1 && (WriteReg == ReadReg1 || WriteReg == ReadReg2))
        begin
            BranchSTALL = 1;
        end
        if (Branch == 1 && EX_MEM_MemToReg == 1 && EX_MEM_RegWrite == 1 && (EX_MEM_WriteReg == ReadReg1 || EX_MEM_WriteReg == ReadReg2))
        begin
            BranchSTALL = 1;
        end 
        
        
        if (Reset == 1) 
        begin
            TotalClk = 0;
            PC = 0;
            STALL = 0;
            NOP = 0;
            NOP_run = 0;
            BranchSTALL = 0;
            ID_EX_ALUSrc = 0;
            //for forwarding
            ID_EX_ReadReg1 = 0;
            ID_EX_ReadReg2 = 0;
            EX_MEM_WriteReg = 0;
            MEM_WB_WriteReg = 0;
            IF_ID_Inst = 0;
            ID_EX_RegDst = 0;
            ID_EX_ALUSrc = 0;
            ID_EX_RegWrite = 0;
            ID_EX_MemRead = 0;
            ID_EX_MemWrite = 0;
            ID_EX_Branch = 0;
            ID_EX_JalFlag = 0;
            ID_EX_MemToReg = 0;
            ID_EX_ALUOp = 0;
        
            EX_MEM_RegWrite = 0;
            EX_MEM_MemWrite = 0;
            EX_MEM_MemRead = 0;
            EX_MEM_Branch = 0;
            EX_MEM_JalFlag = 0;
            EX_MEM_MemToReg = 0;
            EX_MEM_JrFlag = 0;
            
            MEM_WB_MemToReg = 0;
            MEM_WB_RegWrite = 0;
            MEM_WB_JrFlag = 0;
            MEM_WB_JalFlag = 0;
            
            
            WB_XX_WriteReg = 0;
            WB_XX_MemToReg = 0;
            WB_XX_RegWrite = 0;
        end
        else if (PCSrc == 1 && PC != BranchPC)
        begin
            if(!STALL && !BranchSTALL)
            begin
                PC = BranchPC;
                NOP = 1;
            end
        end
        else if (Branch == 1 && PCSrc == 0 && PC != IF_ID_iniPC + 4)
        begin 
            if(!STALL && !BranchSTALL)
            begin
                Tmp = IF_ID_iniPC;
                PC = IF_ID_iniPC + 4;
                NOP = 1;
            end
        end
        else 
        begin
            if(!STALL && !BranchSTALL)
                IF_ID_iniPC <= PC;  
            if(!STALL && !BranchSTALL)
            begin
                if (Beq == 1)    
                    PC = PredBranchPC;
                else if (Jump == 1)
                    PC = JumpAddress;
                else 
                    PC = PC + 4;
            end
        end
        //update buffer
        //upd IF_ID
        if (!Reset && !BranchSTALL && !STALL && NOP == 1) //NOP for branch
            begin
                IF_ID_PC <= PC;//PC has been updated before
                IF_ID_Inst <= 32'b111111_00000_00000_00000_00000_000000;
                NOP <= 0;
            end
        else if(!Reset && !BranchSTALL && !STALL)
            begin
                IF_ID_PC <= PC;
                IF_ID_Inst <= Inst;
            end
        
        //upd ID_EX
        if(!Reset && !STALL)
        begin
            if (!BranchSTALL)
            begin
                ID_EX_Rt <= Rt;
                ID_EX_Rd <= Rd;
                ID_EX_Ext <= Ext;
                ID_EX_ReadReg1 <= ReadReg1;
                ID_EX_ReadReg2 <= ReadReg2;
                ID_EX_RegReadData1 <= RegReadData1;
                ID_EX_RegReadData2 <= RegReadData2;
                ID_EX_PC <= PC;
                ID_EX_Inst <= IF_ID_Inst;
                //control sig
                ID_EX_MemToReg <= MemToReg;
                ID_EX_RegDst <= RegDst;
                ID_EX_ALUSrc <= ALUSrc;
                ID_EX_RegWrite <= RegWrite;
                ID_EX_MemRead <= MemRead;
                ID_EX_MemWrite <= MemWrite;
                ID_EX_Branch <= Branch;
                ID_EX_JalFlag <= JalFlag;
                ID_EX_ALUOp <= ALUOp;
            end
            else
            begin
                //nop
                ID_EX_MemToReg <= 0;
                ID_EX_RegWrite <= 0;
                ID_EX_MemRead <= 0;
                ID_EX_MemWrite <= 0;
                ID_EX_Branch <= 0;
                ID_EX_JalFlag <= 0;
            end
        end
        
        //upd EX_MEM
        if(!Reset && !STALL)
        begin
            EX_MEM_WriteReg <= WriteReg;
            EX_MEM_RegReadData2 <= ID_EX_RegReadData2;
            EX_MEM_ALURes <= ALURes;
            EX_MEM_Zero <= Zero;
            EX_MEM_BranchPC <= BranchPC;
            //control
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_MemRead <= ID_EX_MemRead;
            EX_MEM_Branch <= ID_EX_Branch;
            EX_MEM_JalFlag <= ID_EX_JalFlag;
            EX_MEM_MemToReg <= ID_EX_MemToReg;
            EX_MEM_JrFlag <= JrFlag;
        end
        else
        begin
            EX_MEM_RegWrite <= 0;
            EX_MEM_MemWrite <= 0;
            EX_MEM_Branch <= 0;
            EX_MEM_JalFlag <= 0;
            EX_MEM_JrFlag <= 0;
        end

        //upd MEM_WB
        if(!Reset)
        begin
            MEM_WB_WriteReg <= EX_MEM_WriteReg;
            MEM_WB_MemReadData <= MemReadData;
            MEM_WB_ALURes <= EX_MEM_ALURes;
            //control
            MEM_WB_MemToReg <= EX_MEM_MemToReg;
            MEM_WB_RegWrite <= EX_MEM_RegWrite; 
            MEM_WB_JalFlag <= EX_MEM_JalFlag;
            MEM_WB_JrFlag <= EX_MEM_JrFlag;
        
            WB_XX_MemReadData <= MEM_WB_MemReadData;
            WB_XX_ALURes <= MEM_WB_ALURes;
            WB_XX_WriteReg <= MEM_WB_WriteReg;
            WB_XX_MemToReg <= MEM_WB_MemToReg;
            WB_XX_RegWrite <= MEM_WB_RegWrite;
        end
        
        TotalClk <= TotalClk + 1;
        if(STALL == 1)
        begin
            STALL <= 0;
        end
        
        if (PC > 40)//for FPGA
        begin
            PC <= 40;
        end
        if (ID_EX_PC > 40)
        begin
            ID_EX_PC <= 40;
        end
        if (ID_EX_PC > 40)
        begin
            ID_EX_PC <= 40;
        end
    end
    initial begin
        TotalClk = 0;
        PC = 0;
        STALL = 0;
        NOP = 0;
        NOP_run = 0;
        BranchSTALL = 0;
        ID_EX_ALUSrc = 0;
        //for forwarding
        ID_EX_ReadReg1 = 0;
        ID_EX_ReadReg2 = 0;
        EX_MEM_WriteReg = 0;
        MEM_WB_WriteReg = 0;
        
        IF_ID_Inst = 0;
        ID_EX_RegDst = 0;
        ID_EX_ALUSrc = 0;
        ID_EX_RegWrite = 0;
        ID_EX_MemRead = 0;
        ID_EX_MemWrite = 0;
        ID_EX_Branch = 0;
        ID_EX_JalFlag = 0;
        ID_EX_MemToReg = 0;
        ID_EX_ALUOp = 0;
    
        EX_MEM_RegWrite = 0;
        EX_MEM_MemWrite = 0;
        EX_MEM_MemRead = 0;
        EX_MEM_Branch = 0;
        EX_MEM_JalFlag = 0;
        EX_MEM_MemToReg = 0;
        EX_MEM_JrFlag = 0;
        
        MEM_WB_MemToReg = 0;
        MEM_WB_RegWrite = 0;
        MEM_WB_JrFlag = 0;
        MEM_WB_JalFlag = 0;
        
        WB_XX_WriteReg = 0;
        WB_XX_MemToReg = 0;
        WB_XX_RegWrite = 0;
    end
endmodule