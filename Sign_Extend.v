
`timescale 1ns / 1ps

module Sign_Extend(
    input [31:0] In,
    input [1:0] ImmSrc,
    output reg [31:0] ImmExtend
);

always @(*)
begin
    case(ImmSrc)

        // I-type immediate
        2'b00:
            ImmExtend = {{20{In[31]}}, In[31:20]};

        // S-type immediate
        2'b01:
            ImmExtend = {{20{In[31]}}, In[31:25], In[11:7]};

        // B-type immediate
        2'b10:
            ImmExtend = {{19{In[31]}}, In[31], In[7],
                         In[30:25], In[11:8], 1'b0};

        // Default
        default:
            ImmExtend = 32'b0;

    endcase
end

endmodule
