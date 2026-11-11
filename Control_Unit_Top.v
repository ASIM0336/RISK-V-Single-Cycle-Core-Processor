
`timescale 1ns / 1ps
module Control_Unit_Top(
    Op,
    RegWrite,
    ImmSrc,
    ALUSrc,
    MemWrite,
    ResultSrc,
    Branch,
    funct3,
    funct7_5,
    ALUControl
);

// Inputs
input [6:0] Op;
input [2:0] funct3;
input funct7_5;

// Outputs
output RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
output [1:0] ImmSrc;
output [2:0] ALUControl;

// Internal wire
wire [1:0] ALUop;

// Main Decoder
main_decoder md1(
    .op(Op),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .ALUop(ALUop),
    .Branch(Branch)
);

// ALU Decoder
alu_decoder ad1(
    .ALUop(ALUop),
    .op5(Op[5]),
    .funct3(funct3),
    .funct7_5(funct7_5),
    .ALUControl(ALUControl)
);

endmodule
