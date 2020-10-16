`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Justin Calma
// CECS 341 - 01
//
// Create Date: 10/10/2020 11:36:19 AM
// Design Name: 
// Module Name: alu_32
// Project Name: Lab 1 - Arithmetic Logic Unit
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

// Module Definition and I/O Ports
module alu_32(A_in, B_in, ALU_Sel, ALU_Out, Carry_Out, Zero, Overflow);
    
    input   [31:0]  A_in; // 32 - bit input A
    input   [31:0]  B_in; // 32 - bit input B
    input   [3:0]   ALU_Sel; // 4 - bit Control Line
    output  [31:0]  ALU_Out; // 32 - bit result output
    output  [0:0]   Carry_Out; // 1 - bit carry out result
    output  [0:0]   Zero; // 1 - bit zero output
    output  [0:0]   Overflow; // 1 - bit overflow output
    
    // Define ALU_Output Register
    reg [31:0] Result;
    assign ALU_Out = Result;
    
    // Define Carry_Out, Zero, and Overflow output Registers
    reg [0:0] CarryOutResult, ZeroResult, OverflowResult;
    assign Carry_Out = CarryOutResult;
    assign Zero = ZeroResult;
    assign Overflow = OverflowResult;
    
    // Create a temp Register for Carry_Out and Overflow
    reg [31:0] temp;
    
    // Describe ALU Behavior
    always @ (A_in, B_in, ALU_Sel)
        begin
            case(ALU_Sel)

 //-------------------------------------------AND Operation-------------------------------------------// 
            
                // AND Operation
                4'b0000: begin 
                            
                            // Perform AND operation and store the result into Result Register
                            Result = A_in & B_in; 
                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000) 
                                ZeroResult = 1'b1;
                            else
                                ZeroResult = 1'b0;
                            
                            // Set the Carry_Out and Overflow flags to 0
                            CarryOutResult = 1'b0;
                            OverflowResult = 1'b0;
                                                            
                         end
 
 //-------------------------------------------OR Operation-------------------------------------------//   
                         
                // OR Operation
                4'b0001: begin 
                
                            // Perform the OR operation and store the result into Result Register
                            Result = A_in | B_in; 
                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                                ZeroResult = 1'b1;
                            else
                                ZeroResult = 1'b0;
                         
                            // Set the Carry_Out and Overflow flags to 0
                            CarryOutResult = 1'b0;
                            OverflowResult = 1'b0;                         
                            
                         end                           
  
 //-------------------------------------------ADD Operation-------------------------------------------//     
                
                // ADD Operation
                4'b0010: begin 
                            
                            // Perform signed ADD and store the result into the Result Register
                            Result = $signed(A_in) + $signed(B_in); 
                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                                ZeroResult = 1'b1;
                            else
                                ZeroResult = 1'b0;
                            
                            // Perform unsigned ADD to determine carry out
                            temp = A_in + B_in;                            
                            
                            // Check if there is a Carry Out in the unsigned ADD operation
                            if (A_in[31] == 1 & B_in[31] == 1)
                                CarryOutResult = 1'b1;
                            else if (temp[32] == 1)
                                CarryOutResult = 1'b1;
                            else 
                                CarryOutResult = 1'b0;
                            
                            // Check if there is a Overflow in the signed ADD operation
                            if (A_in[31] == 0 & B_in[31] == 0 & Result[31] == 1)
                                OverflowResult = 1'b1;
                            else if (A_in[31] == 1 & B_in[31] == 1 & Result[31] == 0)
                                OverflowResult = 1'b1;
                            else 
                                OverflowResult = 1'b0;
                            
                         end                
                
 //-------------------------------------------SUB Operation-------------------------------------------// 
                 
                // SUB Operation
                4'b0110: begin 
                
                            // Peform signed SUB and store the result into the Result register
                            Result = $signed(A_in) - $signed(B_in); 
                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                                ZeroResult = 1'b1;
                            else
                                ZeroResult = 1'b0;
                            
                            // Set Carry Out flag to be 0
                            CarryOutResult = 1'b0;    
                                                    
                            // Check if there is a Overflow in the signed ADD operation
                            if (A_in[31] == 0 & B_in[31] == 0 & Result[31] == 1)
                                OverflowResult = 1'b1;
                            else if (A_in[31] == 1 & B_in[31] == 1 & Result[31] == 0)
                                OverflowResult = 1'b1;
                            else if (A_in[31] == 1 & B_in[31] == 0 & Result[31] == 0)
                                OverflowResult = 1'b1;    
                            else 
                                OverflowResult = 1'b0;
                            
                         end                
 
 //-------------------------------------------SLT Operation-------------------------------------------//    
                
                // SLT Operation
                4'b0111: begin 
                
                            // Check if input A is less than B; Result is 1 if true, 1 if false
                            if ($signed(A_in) < $signed(B_in)) 
                                Result = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
                            else 
                                Result = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
                                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                                ZeroResult = 1'b1;
                            else
                                ZeroResult = 1'b0;
                                
                            // Set the Carry_Out and Overflow flags to 0
                            CarryOutResult = 1'b0;
                            OverflowResult = 1'b0;                                
                                
                         end                                                  
  
 //-------------------------------------------NOR Operation-------------------------------------------//     
                         
                // NOR Operation
                4'b1100: begin 
                            
                            // Perform the logical NOR operation and store the result into the Result register
                            Result = ~(A_in | B_in); 
                
                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000) 
                                ZeroResult = 1'b1;
                            else 
                                ZeroResult = 1'b0;
                                
                            // Set the Carry_Out and Overflow flags to 0
                            CarryOutResult = 1'b0;
                            OverflowResult = 1'b0;                                
                                
                         end                        

 //-------------------------------------------Equal Comparison Operation-------------------------------------------//   
                
                // Equal Comparison Operation
                4'b1111: begin 
                
                            // Check if input A and B are equal; Result is 1 if true, 1 if false
                            if (A_in == B_in)
                                Result = 32'b0000_0000_0000_0000_0000_0000_0000_0001;  
                            else 
                                Result = 32'b0000_0000_0000_0000_0000_0000_0000_0000; 

                            // Check if Result is 0 and set Zero flag
                            if (Result == 32'b0000_0000_0000_0000_0000_0000_0000_0000) 
                                ZeroResult = 1'b1;
                            else 
                                ZeroResult = 1'b0;
                                
                            // Set the Carry_Out and Overflow flags to 0
                            CarryOutResult = 1'b0;
                            OverflowResult = 1'b0;                                
                                
                         end
                        
            endcase
        end  
endmodule
