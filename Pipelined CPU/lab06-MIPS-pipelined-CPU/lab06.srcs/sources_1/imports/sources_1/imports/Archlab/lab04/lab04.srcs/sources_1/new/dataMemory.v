`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 22:08:46
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
        input reset,
        input Clk,
        input [31:0] address,
        input [31:0] writeData,
        input memRead,
        input memWrite,
        input [31:0] Op1,
        input [31:0] Op2,
        input [31:0] Out,
        output reg [31:0] readData
    );
    reg [31:0] memFile[0:255];
    
    integer i;
    initial begin
        for(i = 0; i < 255; i = i + 1)
            memFile[i] = 4; 
        memFile[0] = Op1;
        memFile[1] = Op2;
        readData = 0;
        //$readmemh("E:/Archlab/lab05/lab05.srcs/data",memFIle); 
    end
    assign Out = memFile[2];
    always @ (memFile[address >> 2] or reset or memWrite or memRead or address)
        begin
            if (memRead == 1)
            begin
                readData = memFile[address >> 2];
            end
        end
    always @ (negedge Clk) // to change
        begin
            memFile[0] = Op1;
            memFile[1] = Op2;
            if (memWrite)
            begin
                memFile[address >> 2] = writeData;
            end
        end
    
endmodule
//cache version
/*
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 22:08:46
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
        input reset,
        input Clk,
        input [31:0] address,
        input [31:0] writeData,
        input memRead,
        input memWrite,
        input [31:0] Op1,
        input [31:0] Op2,
        input [31:0] Out,
        output reg [31:0] readData//这里wire assign 和 reg有什么不同
    );
    //block offset 2bit ()此处只能为0
    //s 5 bit
    //E = 2
    reg [63:0] curTime;
    
    reg [31:0] memFile[0:255];
    reg [24:0] tag[0:31][0:1];     //cache
    reg [31:0] cache[0:31][0:1];
    reg [63:0] timeStamp[0:31][0:1];
    reg valid[0:31][0:1];
    reg [4:0] setNumber;    //read Set Number
    reg [4:0] writeSetNumber;
    reg dirtyBit[0:31][0:1];
    
    integer i;
    initial begin
        for(i = 0; i < 32; i = i + 1)
        begin
            cache[i][0] = 0;
            cache[i][1] = 0;
            tag[i][0] = 0;
            tag[i][1] = 0;
            valid[i][0] = 0;
            valid[i][1] = 0;
            dirtyBit[i][0] = 0;
            dirtyBit[i][1] = 0;
        end
        setNumber = 0;
        curTime = 0;
        for(i = 0; i < 255; i = i + 1)
            memFile[i] = 4; 
        memFile[0] = 13;
        memFile[1] = 9;
        readData = 0;
        //$readmemh("E:/Archlab/lab05/lab05.srcs/data",memFIle); 
    end
    always @ (reset or memWrite or memRead or address)//赋初值应该不算改变,可以直接assign！
        begin
            if (reset)
            begin
                for(i = 0; i < 32; i = i + 1)
                begin
                    cache[i][0] = 0;
                    cache[i][1] = 0;
                    tag[i][0] = 0;
                    tag[i][1] = 0;
                    valid[i][0] = 0;
                    valid[i][1] = 0;
                    dirtyBit[i][0] = 0;
                    dirtyBit[i][1] = 0;
                end
                setNumber = 0;
                curTime = 0;
                readData = 0;
            end
            else if (memRead == 1)
            begin
                //access cache
                setNumber = ((address >> 2) & 5'b11111);   //get set index
                if (valid[setNumber][0] && tag[setNumber][0] == (address >> 7))
                begin
                    //hit
                    if(dirtyBit[setNumber][0] == 1)
                    begin
                        dirtyBit[setNumber][0] = 0; //同时赋值？？
                        cache[setNumber][0] = memFile[address >> 2];
                    end
                    readData = cache[setNumber][0];
                end
                else if (valid[setNumber][1] && tag[setNumber][1] == (address >> 7))
                begin
                    if(dirtyBit[setNumber][1] == 1)
                    begin
                        dirtyBit[setNumber][1] = 0;
                        cache[setNumber][1] = memFile[address >> 2];
                    end
                    readData = cache[setNumber][1];
                end
                else 
                begin
                    //miss
                    if (valid[setNumber][0] == 0)
                    begin
                        dirtyBit[setNumber][0] = 0;
                        valid[setNumber][0] = 1;
                        tag[setNumber][0] = address >> 7;
                        cache[setNumber][0] = memFile[address >> 2];
                        timeStamp[setNumber][0] = curTime;
                        readData = cache[setNumber][0];
                    end
                    else if(valid[setNumber][1] == 0)
                    begin
                        dirtyBit[setNumber][1] = 0;
                        valid[setNumber][1] = 1;
                        tag[setNumber][1] = address >> 7;
                        cache[setNumber][1] = memFile[address >> 2];
                        timeStamp[setNumber][1] = curTime;
                        readData = cache[setNumber][1];
                    end
                    else //find a evict
                    begin
                        if (timeStamp[setNumber][0] < timeStamp[setNumber][1])
                        begin //evict 0
                            dirtyBit[setNumber][0] = 0;
                            valid[setNumber][0] = 1;
                            tag[setNumber][0] = address >> 7;
                            cache[setNumber][0] = memFile[address >> 2];
                            timeStamp[setNumber][0] = curTime;
                            readData = cache[setNumber][0];
                        end
                        else
                        begin
                            dirtyBit[setNumber][1] = 0;
                            valid[setNumber][1] = 1;
                            tag[setNumber][1] = address >> 7;
                            cache[setNumber][1] = memFile[address >> 2];
                            timeStamp[setNumber][1] = curTime;
                            readData = cache[setNumber][1];
                        end
                    end
                end
            end
        end
    always @ (negedge Clk) // to change
        begin
            curTime = curTime + 1;
            if (memWrite)//memFile可以写
            begin
                writeSetNumber = (address >> 2) & 5'b11111;
                if(!reset && valid[writeSetNumber][0] && tag[writeSetNumber][0] == (address >> 7))
                begin
                    dirtyBit[writeSetNumber][0] = 1;
                end
               if(!reset && valid[writeSetNumber][1] && tag[writeSetNumber][1] == (address >> 7))
                begin
                    dirtyBit[writeSetNumber][1] = 1;
                end
                memFile[address >> 2] = writeData;
            end
        end
    
endmodule

*/