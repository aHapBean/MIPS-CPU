`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 22:48:00
// Design Name: 
// Module Name: signext
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


module signext(
        input  [15:0] inst,
        input  signExtFlag,
        output [31:0] data
    );
    
    assign data = signExtFlag ? {{16{inst[15]}}, inst} : {{16{1'b0}}, inst};
endmodule
