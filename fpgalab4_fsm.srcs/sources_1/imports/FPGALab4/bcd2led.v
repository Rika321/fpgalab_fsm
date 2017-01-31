`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2016 11:16:44 AM
// Design Name: 
// Module Name: bcd2led
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


module bcd2led(
    input [3:0] x,
    output [6:0] seg
    );    
    assign seg[6] = (!x[3]&&!x[2]&&!x[1]) || (x[2]&&x[1]&&x[0]);
    assign seg[5] = (x[1]&&x[0]) || (!x[2]&&x[1]) || (!x[3]&&!x[2]&&x[0]);
    assign seg[4] = (x[0]) || (x[2]&&!x[1]&&!x[0]);
    assign seg[3] = (x[2]&&!x[1]&&!x[0]) || (!x[3]&&!x[2]&&!x[1]&&x[0]) || (x[2]&&x[1]&&x[0]);
    assign seg[2] = (!x[2]&&x[1]&&!x[0]);
    assign seg[1] = (x[2]&&x[1]&&!x[0]) || (x[2]&&!x[1]&&x[0]); 
    assign seg[0] = (x[2]&&!x[1]&&!x[0]) || (!x[3]&&!x[2]&&!x[1]&&x[0]);     
endmodule
