
`timescale 1ns / 1ps

module Data_Memory(
    input [31:0] A,
    input [31:0] WD,
    input clk,
    input WE,
    output [31:0] RD
);

// 1024 words, 32 bits each
reg [31:0] DataMem [0:1023];

// Asynchronous read
assign RD = (A[1:0] == 2'b00) ?
            DataMem[A[11:2]] : 32'b0;

// Synchronous write
always @(posedge clk)
begin
    if (WE && A[1:0] == 2'b00)
    begin
        DataMem[A[11:2]] <= WD;
    end
end

endmodule
