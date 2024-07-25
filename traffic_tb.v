`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2024 22:17:14
// Design Name: 
// Module Name: traffic_tb
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


module traffic_tb();
reg clk, reset;
wire Red_NS, Yellow_NS, Green_NS, freeLeft_NS, Red_EW, Yellow_EW, Green_EW, freeLeft_EW;

traffic_control uut (clk, reset, Red_NS, Yellow_NS, Green_NS, freeLeft_NS, Red_EW, Yellow_EW, Green_EW, freeLeft_EW);
initial begin
    clk = 1'b0;
    forever 
        #50 clk = ~clk;
end

initial begin
    reset = 1'b1; #100
    reset = 1'b0;
end


endmodule
