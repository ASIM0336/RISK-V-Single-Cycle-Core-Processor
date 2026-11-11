
`timescale 1ns / 1ps

module Register_Files(
    A1,A2,A3,WD3,WE3,clk,rst,RD1,RD2
);

// Inputs
input [4:0] A1,A2,A3;
input [31:0] WD3;
input WE3, rst, clk;

// Outputs
output [31:0] RD1,RD2;

// Register memory
reg [31:0] Registers [31:0];

// Asynchronous read functionality
// x0 always returns zero

assign RD1 = (!rst || A1 == 5'd0) ?
             32'b0 : Registers[A1];

assign RD2 = (!rst || A2 == 5'd0) ?
             32'b0 : Registers[A2];

// Synchronous write functionality
always @(posedge clk)
begin
    if (WE3 && A3 != 5'd0)
    begin
        Registers[A3] <= WD3;
    end
end

endmodule
