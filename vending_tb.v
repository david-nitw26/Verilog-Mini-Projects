`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2024 18:58:03
// Design Name: 
// Module Name: vending_tb
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


module vending_tb();
reg clk, reset, Rs_5, Rs_10, Rs_20, select, cancel;
wire [4:0] change;
wire drink_1, drink_2;

vending_mach uut (clk, reset, Rs_5, Rs_10, Rs_20, select, cancel, drink_1, drink_2, change);
initial begin
    clk = 1'b0;
    forever 
        #50 clk = ~clk;
end

initial begin
    reset = 1'b1; select = 1'b1; Rs_5 = 1'b0; Rs_10 = 1'b0; Rs_20 = 1'b0; cancel = 1'b0; #50
    reset = 1'b0; Rs_20 = 1'b1; #100
    reset = 1'b0; Rs_20 = 1'b0; Rs_10 = 1'b1; #200
    
    reset = 1'b1; select = 1'b0; Rs_5 = 1'b0; Rs_10 = 1'b0; Rs_20 = 1'b0; cancel = 1'b0; #100
    reset = 1'b0; Rs_5 = 1'b1; #100
    reset = 1'b0; Rs_5 = 1'b0; Rs_20 = 1'b1; #100;
    $finish;  
    
end
endmodule
