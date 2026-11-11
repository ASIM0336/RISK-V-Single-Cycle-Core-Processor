
`timescale 1ns / 1ps

module alu_decoder(
    ALUop,
    op5,
    funct3,
    funct7_5,
    ALUControl
);

input [1:0] ALUop;
input op5;
input [2:0] funct3;
input funct7_5;

output [2:0] ALUControl;

wire is_sub;

assign is_sub = op5 & funct7_5;

assign ALUControl =
    (ALUop == 2'b00) ? 3'b000 :  // ADD (Load/Store)
    (ALUop == 2'b01) ? 3'b001 :  // SUB (Branch)

    (ALUop == 2'b10 && funct3 == 3'b010) ? 3'b101 : // SLT

    (ALUop == 2'b10 && funct3 == 3'b110) ? 3'b011 : // OR

    (ALUop == 2'b10 && funct3 == 3'b111) ? 3'b010 : // AND

    (ALUop == 2'b10 && funct3 == 3'b000 && is_sub)
        ? 3'b001 : // SUB

    (ALUop == 2'b10 && funct3 == 3'b000 && !is_sub)
        ? 3'b000 : // ADD

    3'b000;

endmodule
