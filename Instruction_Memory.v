
`timescale 1ns / 1ps

module Instruction_Memory(
    input [31:0] A,
    input rst,
    output [31:0] RD
);

// 1024 words, 32 bits each
reg [31:0] Mem [0:1023];

// Load program instructions from memory file
initial
begin
    $readmemh("program.mem", Mem);
end

// Instruction read
assign RD = (!rst || (|A[31:12]) || (|A[1:0]))
            ? 32'h00000000
            : Mem[A[11:2]];

endmodule
