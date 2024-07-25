`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2024 22:15:48
// Design Name: 
// Module Name: vending_mach
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

// drink_1 = Rs_15 and drink_2 = Rs_25

module vending_mach(clk, reset, Rs_5, Rs_10, Rs_20, select_drink, cancel, drink_1, drink_2, change);
input clk, reset, Rs_5, Rs_10, Rs_20, select_drink, cancel;
output reg drink_1, drink_2;
output reg [4:0] change;

reg [5:0] total_money;

// to compute the total amount put in by the user
always @(posedge clk or posedge reset)
begin
    if(reset|cancel|drink_1|drink_2)
        total_money <= 6'd0;
    else if(Rs_5)
        total_money <= total_money + 6'd5;
    else if(Rs_10)
        total_money <= total_money + 6'd10;
    else if(Rs_20)
        total_money <= total_money + 6'd20;      
end

reg [3:0] state, nextState;

localparam S0 = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
localparam S5 = 4'd5;
localparam S6 = 4'd6;
localparam S7 = 4'd7;
localparam S8 = 4'd8;


// present State logic
always @(posedge clk or posedge reset)
begin
    if(reset)
        state <= S0;
    else
        state <= nextState;
end

// Designing the State Machine
always @(*)
case(state)
S0: begin
    drink_1 = 1'b0;
    drink_2 = 1'b0;
    change = 5'd0;
    if(select_drink)
        nextState = S1;
    else if(!select_drink)
        nextState = S6;
    else
        nextState = S0;
end

S1: begin
    if(total_money == 6'd5)
        nextState = S2;
    else if(total_money == 6'd10)
        nextState = S3;
    else if(total_money == 6'd20)
        nextState = S5;
    else if(cancel)
        nextState = S0;
    else
        nextState = S1;
end

// I already have 5Rs in S2, 10Rs in S3, 15Rs in S4, 20Rs in S5. So as the user gives more money,
// it just gets added up 
S2: begin
    if(total_money == 6'd10)
        nextState = S3;
    else if(total_money == 6'd15)
        nextState = S4;
    else if(total_money == 6'd25)
    begin
        drink_2 = 1'b1;
        nextState = S0;
    end
    
    else if(cancel)
    begin
        change = 5'd5;
        nextState = S0;
    end 
    
    else 
        nextState = S2;
end

S3: begin
    if(total_money == 6'd15)
        nextState = S4;
    else if(total_money == 6'd20)
        nextState = S5;
    else if(total_money == 6'd30)
    begin
        drink_2 = 1'b1;
        change = 5'd5;
        nextState = S0;
    end
    
    else if(cancel)
    begin
        change = 5'd10;
        nextState = S0;
    end
    
    else
        nextState = S3;  
end

S4: begin
    if(total_money == 6'd20)
        nextState = S5;
    else if(total_money == 6'd25)
    begin
        drink_2 = 1'b1;
        nextState = S0;
    end
    
    else if(total_money == 6'd35)
    begin
        drink_2 = 1'b1;
        change = 5'd10;
        nextState = S0;
    end
    
    else if(cancel)
    begin
        change = 5'd15;
        nextState = S0;
    end
    
    else
        nextState = S4;
end

S5: begin
    if(total_money == 6'd25)
    begin
        drink_2 = 1'b1;
        nextState = S0;
    end
    
    else if(total_money == 6'd30)
    begin
        drink_2 = 1'b1;
        change = 5'd5;
        nextState = S0;
    end
    
    else if(total_money == 6'd40)
    begin
        drink_2 = 1'b1;
        change = 5'd15;
        nextState = S0;
    end
    
    else if(cancel)
    begin
        change = 5'd20;
        nextState = S0;
    end
    
    else
        nextState = S5;   
end

// lets do for drink_1 (costs 15Rs/-)
S6: begin
    if(total_money == 6'd5)
        nextState = S7;
    else if(total_money == 6'd10)
        nextState = S8;
    else if(total_money == 6'd20)
    begin
        drink_1 = 1'b1;
        change = 5'd5;
        nextState = S0;
    end
    
    else if(cancel)
        nextState = S0;
    else
        nextState = S6; 
end

S7: begin
    if(total_money == 6'd10)
        nextState = S8;
    else if(total_money == 6'd15)
    begin
        drink_1 = 1'b1;
        nextState = S0;
    end
    
    // who would do this thing :(
    else if(total_money == 6'd25)
    begin
        drink_1 = 1'b1;
        change = 5'd10;
        nextState = S0;
    end
    
    else 
        nextState = S7;   
end

S8: begin
    if(total_money == 6'd15)
    begin
        drink_1 = 1'b1;
        nextState = S0;
    end
    
    else if(total_money == 6'd20)
    begin
        drink_1 = 1'b1;
        change = 5'd5;
        nextState = S0;
    end
    
    else if(total_money == 6'd30)
    begin
        drink_1 = 1'b1;
        change = 5'd15;
        nextState = S0;
    end
    
    else if(cancel)
    begin
        change = 5'd10;
        nextState = S0;
    end
    
    else
        nextState = S8;   
end
endcase
endmodule
