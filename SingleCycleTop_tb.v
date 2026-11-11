
`timescale 1ns / 1ps

module SingleCycleTop_tb;

    reg clk;
    reg rst;

    integer errors;

    // Instantiate processor
    SingleCycleTop uut (
        .clk(clk),
        .rst(rst)
    );

    // 100 MHz clock: 10 ns period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        rst = 1'b0;
        errors = 0;

        $display("--------------------------------------");
        $display("   RISC-V Single Cycle Processor Test");
        $display("--------------------------------------");

        // Hold reset for two clock cycles
        repeat (2) @(posedge clk);

        // Release active-low reset
        @(negedge clk);
        rst = 1'b1;

        // Monitor processor execution
        repeat (10) begin
            @(posedge clk);
            #1;
            $display("Time=%0t | PC=%h | Instruction=%h",
                     $time, uut.PC_TOP, uut.RD_Instr);
        end

        // Allow final updates to settle
        #1;

        $display("--------------------------------------");
        $display("         REGISTER CHECKS");
        $display("--------------------------------------");

        // Check x1 = 5
        if (uut.rf1.Registers[1] === 32'd5)
            $display("PASS: x1 = 5");
        else begin
            $display("FAIL: x1 = %d", uut.rf1.Registers[1]);
            errors = errors + 1;
        end

        // Check x2 = 3
        if (uut.rf1.Registers[2] === 32'd3)
            $display("PASS: x2 = 3");
        else begin
            $display("FAIL: x2 = %d", uut.rf1.Registers[2]);
            errors = errors + 1;
        end

        // Check ADD: x3 = x1 + x2 = 8
        if (uut.rf1.Registers[3] === 32'd8)
            $display("PASS: ADD: x3 = 8");
        else begin
            $display("FAIL: ADD: x3 = %d", uut.rf1.Registers[3]);
            errors = errors + 1;
        end

        // Check SUB: x4 = x1 - x2 = 2
        if (uut.rf1.Registers[4] === 32'd2)
            $display("PASS: SUB: x4 = 2");
        else begin
            $display("FAIL: SUB: x4 = %d", uut.rf1.Registers[4]);
            errors = errors + 1;
        end

        // Check LW: x5 = 8
        if (uut.rf1.Registers[5] === 32'd8)
            $display("PASS: LW: x5 = 8");
        else begin
            $display("FAIL: LW: x5 = %d", uut.rf1.Registers[5]);
            errors = errors + 1;
        end

        // Check BEQ: x6 should be 7, not 99
        if (uut.rf1.Registers[6] === 32'd7)
            $display("PASS: BEQ branch taken correctly");
        else begin
            $display("FAIL: BEQ: x6 = %d", uut.rf1.Registers[6]);
            errors = errors + 1;
        end

        $display("--------------------------------------");
        $display("         DATA MEMORY CHECK");
        $display("--------------------------------------");

        // Check SW: Memory[0] = 8
        if (uut.dm1.DataMem[0] === 32'd8)
            $display("PASS: SW: Memory[0] = 8");
        else begin
            $display("FAIL: Memory[0] = %d", uut.dm1.DataMem[0]);
            errors = errors + 1;
        end

        $display("--------------------------------------");

        if (errors == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("TEST FAILED: %0d error(s)", errors);

        $display("--------------------------------------");

        $finish;
    end

endmodule
