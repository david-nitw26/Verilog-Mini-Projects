`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2024 18:44:49
// Design Name: 
// Module Name: traffic_control
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

/*
    constraints: 
        1. N->S and S->N direction will simultaneously on and off and so with E->W and W->E direction
        2. N->S and S->N rep by (NS) and E->W and W->E rep by (EW)
        3. freeLeft will only on and off (no special Red and Yellow lights)
        4. If want to take right turn, consider U-Turn as the only option.
        */

// initializing a parameterized timer
module timer #(parameter timing = 5'd10) (clk, reset, state_mode, done);
input clk, reset, state_mode;
output done;

reg [4:0] count = 5'd0;         // advancement : can make the timer size also a parameter :)

always @(posedge clk or posedge reset)
begin
  if(reset)
    count = 5'd0;
  else if(count < timing && state_mode)
    count = count + 1'b1;
  else
    count <= 5'd0;    
end

assign done = (state_mode)&&(count==timing);

endmodule


// The main controller module
module traffic_control(clk, reset, Red_NS, Yellow_NS, Green_NS, freeLeft_NE_SW,
                                   Red_EW, Yellow_EW, Green_EW, freeLeft_ES_WN);
                                   
input clk, reset;
output reg Red_NS, Red_EW, Yellow_NS, Yellow_EW, Green_NS, Green_EW, freeLeft_NE_SW, freeLeft_ES_WN;

reg [1:0] state, nextState;

localparam S0 = 2'd0;
localparam S1 = 2'd1;
localparam S2 = 2'd2;
localparam S3 = 2'd3;

always @(posedge clk or posedge reset)
begin
    if(reset)
        state <= S0;
    else
        state <= nextState;
end

wire [3:0] done;
timer #(5'd5) t1(clk, reset, state == S0, done[0]);
timer #(5'd3) t2(clk, reset, state == S1, done[1]);
timer #(5'd5) t3(clk, reset, state == S2, done[2]);
timer #(5'd3) t4(clk, reset, state == S3, done[3]);

always @(*)
case(state)
S0: begin
    Red_NS = 1'b0;
    Yellow_NS = 1'b0;
    Green_NS = 1'b1;
    freeLeft_NE_SW = 1'b1;
    Red_EW  = 1'b1;
    Yellow_EW = 1'b0;
    Green_EW = 1'b0;
    freeLeft_ES_WN = 1'b0;
    
    if(done[0])
        nextState = S1;
    else
        nextState = S0;
end

S1: begin
    Red_NS = 1'b0;
    Yellow_NS = 1'b1;
    Green_NS = 1'b0;
    freeLeft_NE_SW = 1'b0;
    Red_EW  = 1'b1;
    Yellow_EW = 1'b0;
    Green_EW = 1'b0;
    freeLeft_ES_WN = 1'b0;
    
    if(done[1])
        nextState = S2;
    else
        nextState = S1;
end

S2: begin
    Red_NS = 1'b1;
    Yellow_NS = 1'b0;
    Green_NS = 1'b0;
    freeLeft_NE_SW = 1'b0;
    Red_EW  = 1'b0;
    Yellow_EW = 1'b0;
    Green_EW = 1'b1;
    freeLeft_ES_WN = 1'b1;
    
    if(done[2])
        nextState = S3;
    else
        nextState = S2;
end

S3: begin
    Red_NS = 1'b1;
    Yellow_NS = 1'b0;
    Green_NS = 1'b0;
    freeLeft_NE_SW = 1'b0;
    Red_EW  = 1'b0;
    Yellow_EW = 1'b1;
    Green_EW = 1'b0;
    freeLeft_ES_WN = 1'b0;
    
    if(done[3])
        nextState = S0;
    else
        nextState = S3;
end
endcase

endmodule
