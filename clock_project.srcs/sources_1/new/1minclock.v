`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2024 11:28:24
// Design Name: 
// Module Name: 1minclock
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


module minclock(
input clk,
output reg clkmin
    );
reg [25:0] count,countmin;
    always @(posedge clk)
        begin
        count <=count + 1;
            if (count == 100000000)
            begin
            countmin <= countmin + 1;
            count <= 0;
            end
            if (countmin==30)
            begin
            clkmin <=!clkmin;
            countmin <= 0;
            end
        end
endmodule
