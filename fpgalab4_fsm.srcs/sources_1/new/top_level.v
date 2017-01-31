`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2016 07:26:30 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
    input clk,
    input reset,
    input [3:0] pause,
    input [3:0] dir,
    output [3:0] an,
    output [6:0] seg
    );
    wire clk_wiz_out, clk_halfHz, clk_1Hz, clk_500Hz, clk_250Hz;
    wire [3:0] cn_out, ce_out, co_out, ct_out;
    wire [6:0] seg_cn, seg_ce, seg_co, seg_ct,
                seg_cn_out, seg_ce_out,seg_co_out, seg_ct_out,
                pause_display;
    
    clk_wiz clkwizard(clk, clk_wiz_out);
    clock_divider #(1) clkdivider_one(clk_wiz_out, clk_1Hz);
    clock_divider #(1) clkdivider_half(clk_wiz_out, clk_halfHz);
    clock_divider #(250) clkdivider_250(clk_wiz_out, clk_250Hz);
    clock_divider #(500) clkdivider_500(clk_wiz_out, clk_500Hz);
    counter_natural cn(cn_out, dir[0], pause[0], clk_1Hz, reset);
    counter_even ce(ce_out, dir[1], pause[1], clk_1Hz, reset);
    counter_odd co(co_out, dir[2], pause[2], clk_1Hz, reset);
    counter_three ct(ct_out, dir[3], pause[3], clk_1Hz, reset);
    
    bcd2led b2l_cn(cn_out, seg_cn);
    bcd2led b2l_ce(ce_out, seg_ce);
    bcd2led b2l_co(co_out, seg_co);
    bcd2led b2l_ct(ct_out, seg_ct);
    
    mux2v #(7) mux_pause_display(pause_display, 7'b1111111, 7'b1110111, clk_halfHz);
    
    mux2v #(7) mux_pause_cn(seg_cn_out, seg_cn, pause_display, pause[0]);
    mux2v #(7) mux_pause_ce(seg_ce_out, seg_ce, pause_display, pause[1]);
    mux2v #(7) mux_pause_co(seg_co_out, seg_co, pause_display, pause[2]);
    mux2v #(7) mux_pause_ct(seg_ct_out, seg_ct, pause_display, pause[3]);
    mux4v #(7) mux_seg(seg, seg_cn_out, seg_ce_out,seg_co_out , seg_ct_out, {clk_250Hz,clk_500Hz});
    
    assign an[3] = ~(~clk_250Hz & ~clk_500Hz);
    assign an[2] = ~(~clk_250Hz & clk_500Hz);
    assign an[1] = ~(clk_250Hz & ~clk_500Hz);
    assign an[0] = ~(clk_250Hz & clk_500Hz); 
endmodule
