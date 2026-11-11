`timescale 1ns / 1ps
module ALU(A,B,ALUControl,Result,Z,N,V,C);

//inputs declaration
input [31:0] A,B;
input [2:0] ALUControl;

//outputs declaration
output [31:0] Result;
//flags zero, negative, overflow, carry
output Z,N,V,C;
//declaring interim wires
wire [31:0] a_and_b;

wire [31:0] a_or_b;

wire [31:0] not_b;

wire [31:0] mux1;

wire [31:0] sum;

wire [31:0] mux2;

wire cout;

//zero extension

wire [31:0]slt;

// logic design

//AND
assign a_and_b = A&B;
//OR
assign a_or_b = A|B;
//NOT
assign not_b = ~B;
//Ternatory operator
assign mux1 = (ALUControl[0]==1'b0)?B:not_b;
// Signed overflow calculation
assign overflow = (A[31] ^ sum[31]) &
                  ~(A[31] ^ B[31] ^ ALUControl[0]);
                  
//Sign extension
//assign slt = {31'b0000000000000000000000000000000,sum[31]};

assign slt = {31'b0, (sum[31] ^ overflow)};

//addition/subtraction
assign {cout,sum} = A+mux1+ALUControl[0];
//4 by 1 mux

assign mux2 = (ALUControl[2:0]==3'b000)?sum:
              (ALUControl[2:0]==3'b001)?sum:
              (ALUControl[2:0]==3'b010)?a_and_b:
              (ALUControl[2:0]==3'b011)?a_or_b:
              (ALUControl[2:0]==3'b101)?slt:
              32'h0000000;
// Result
assign Result = mux2;

// Flags
assign Z=~(|Result);
assign N= Result[31];
//assign C=cout&(~ALUControl[1]);
// Carry flag (arithmetic operations only)
assign C = (ALUControl == 3'b000 ||
            ALUControl == 3'b001) ? cout : 1'b0;
assign V = (ALUControl == 3'b000 ||
            ALUControl == 3'b001) ? overflow : 1'b0;
//assign V=(-ALUControl[1])&(A[31]^sum[31])&(A[31]^B[31]^ALUControl[0]);
endmodule
