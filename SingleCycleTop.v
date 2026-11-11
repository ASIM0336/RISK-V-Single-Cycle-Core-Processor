
`timescale 1ns / 1ps

module SingleCycleTop(clk,rst);

input clk,rst;

// Internal wires
wire [31:0] PC_TOP;
wire [31:0] PC_NEXT;
wire [31:0] RD_Instr;

wire [31:0] RD1_TOP;
wire [31:0] RD2_TOP;

wire [31:0] Imm_Ext_Top;
wire [31:0] ALUResult;
wire [31:0] ReadData;

wire [31:0] PCPlus4;
wire [31:0] PCTarget;

wire [31:0] SrcB;
wire [31:0] Result;

wire RegWrite;
wire MemWrite;
wire ALUSrc;
wire ResultSrc;
wire Branch;
wire ZeroFlag;
wire BranchTaken;

wire [1:0] ImmSrc;
wire [2:0] ALUControl;

// Constant value
localparam [31:0] FOUR = 32'd4;


// 1. Program Counter
P_C pc1(
    .PC_NEXT(PC_NEXT),
    .PC(PC_TOP),
    .rst(rst),
    .clk(clk)
);


// 2. PC + 4 Adder
PC_Adder pa(
    .a(PC_TOP),
    .b(FOUR),
    .c(PCPlus4)
);


// 3. Instruction Memory
Instruction_Memory Im1(
    .A(PC_TOP),
    .rst(rst),
    .RD(RD_Instr)
);


// 4. Register File
Register_Files rf1(
    .A1(RD_Instr[19:15]),
    .A2(RD_Instr[24:20]),
    .A3(RD_Instr[11:7]),
    .WD3(Result),
    .WE3(RegWrite),
    .clk(clk),
    .rst(rst),
    .RD1(RD1_TOP),
    .RD2(RD2_TOP)
);


// 5. Sign Extension
Sign_Extend se1(
    .In(RD_Instr),
    .ImmSrc(ImmSrc),
    .ImmExtend(Imm_Ext_Top)
);


// 6. Register-to-ALU MUX
MUX MUX_Register_to_ALU(
    .a(RD2_TOP),
    .b(Imm_Ext_Top),
    .s(ALUSrc),
    .c(SrcB)
);


// 7. ALU
ALU alu1(
    .A(RD1_TOP),
    .B(SrcB),
    .ALUControl(ALUControl),
    .Result(ALUResult),
    .Z(ZeroFlag),
    .N(),
    .V(),
    .C()
);


// 8. Control Unit
Control_Unit_Top cut1(
    .Op(RD_Instr[6:0]),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .funct3(RD_Instr[14:12]),
    .funct7_5(RD_Instr[30]),
    .ALUControl(ALUControl)
);


// 9. Data Memory
Data_Memory dm1(
    .A(ALUResult),
    .WD(RD2_TOP),
    .clk(clk),
    .WE(MemWrite),
    .RD(ReadData)
);


// 10. Data Memory-to-Register MUX
MUX MUX_Data_Memory_to_Register(
    .a(ALUResult),
    .b(ReadData),
    .s(ResultSrc),
    .c(Result)
);


// 11. Branch Target Adder
PC_Adder Branch_Adder(
    .a(PC_TOP),
    .b(Imm_Ext_Top),
    .c(PCTarget)
);


// 12. Branch Decision (BEQ only)
assign BranchTaken = Branch &&
                     (RD_Instr[14:12] == 3'b000) &&
                     ZeroFlag;


// 13. Next PC MUX
MUX MUX_PC(
    .a(PCPlus4),
    .b(PCTarget),
    .s(BranchTaken),
    .c(PC_NEXT)
);

endmodule
