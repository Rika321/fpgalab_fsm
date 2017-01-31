`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 05:34:30 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clkin,
    output clkout
    );
    parameter frequency = 500;
    
    reg
    [31 : 0]  counter = 0;
    reg
    temp_clk = 0;
    always
    @ (
    posedge
    ( clkin ))
    begin
    if
    ( counter == 5000000 / frequency / 2 - 1  )
    begin
    counter <= 0;
    temp_clk <= ~temp_clk ;
    end
    else
    counter <= counter +1;
    end
    assign
    clkout = temp_clk ;
endmodule
