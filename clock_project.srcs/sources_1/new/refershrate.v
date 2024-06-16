`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2024 12:42:30
// Design Name: 
// Module Name: refershrate
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


module refresh(
  input clk,
  output [1:0] LED_activating_counter
);
  reg [13:0] refresh_counter; 
  always @(posedge clk)
begin 
  refresh_counter <= refresh_counter + 1;
end 
assign LED_activating_counter = refresh_counter[13:12];
endmodule
