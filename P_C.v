`timescale 1ns / 1ps

module P_C(PC_NEXT,PC,rst,clk);
input [31:0] PC_NEXT;
input clk,rst;
output reg [31:0] PC;
always @(posedge clk) 
begin

if(rst==0)
begin
PC<=32'h00000000;
end//if end
else
begin
PC<=PC_NEXT;
end//else end

end//always end

endmodule
