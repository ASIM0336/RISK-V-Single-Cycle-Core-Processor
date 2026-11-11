
`timescale 1ns / 1ps

module main_decoder(
    op,
    RegWrite,
    MemWrite,
    ResultSrc,
    ALUSrc,
    ImmSrc,
    ALUop,
    Branch
);

// Inputs
input [6:0] op;

// Outputs
output RegWrite, MemWrite, ResultSrc, ALUSrc, Branch;
output [1:0] ImmSrc, ALUop;

// Instruction opcodes

wire R_type;
wire I_type;
wire Load;
wire Store;
wire B_type;

// Instruction decoding
assign R_type = (op == 7'b0110011);
assign I_type = (op == 7'b0010011);
assign Load   = (op == 7'b0000011);
assign Store  = (op == 7'b0100011);
assign B_type = (op == 7'b1100011);

// Control signals

// Register write enable
assign RegWrite = R_type | I_type | Load;

// ALU source selection
assign ALUSrc = Load | Store | I_type;

// Memory write enable
assign MemWrite = Store;

// Result source selection
assign ResultSrc = Load;

// Branch enable
assign Branch = B_type;

// Immediate selection
// 00 = I-type
// 01 = S-type
// 10 = B-type

assign ImmSrc = Store  ? 2'b01 :
                B_type ? 2'b10 :
                         2'b00;

// ALU operation selection
// 00 = ADD
// 01 = SUB
// 10 = R-type / I-type ALU decoding

assign ALUop = (R_type | I_type) ? 2'b10 :
               B_type           ? 2'b01 :
                                  2'b00;

endmodule
