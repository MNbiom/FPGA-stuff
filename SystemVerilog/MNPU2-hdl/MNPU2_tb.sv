`timescale 1ps/1ps

module MNPU2_tb;
    logic clk, reset, running;

    MNPU2 dut (.clk(clk), .reset(reset), .running(running));

    initial begin
        $dumpfile("MNPU2.vcd");
        $dumpvars(0, MNPU2_tb);
        // for (int i = 0; i < 16; i = i + 1) $dumpvars(0, dut.rom_name.mem[i]);
        $dumpvars(0, dut.regs_name.register[1]);
        $dumpvars(0, dut.regs_name.register[2]);
        $dumpvars(0, dut.regs_name.register[3]);
        $dumpvars(0, dut.regs_name.register[4]);
        $dumpvars(0, dut.regs_name.register[5]);
        $dumpvars(0, dut.regs_name.register[6]);
        $dumpvars(0, dut.regs_name.register[7]);

        $dumpvars(0, dut.io_name.out[0]);

        $dumpvars(0, dut.ram_name.ram[0]);
        $dumpvars(0, dut.ram_name.ram[1]);
        $dumpvars(0, dut.ram_name.ram[2]);
        $dumpvars(0, dut.ram_name.ram[3]);
        $dumpvars(0, dut.ram_name.ram[4]);
        $dumpvars(0, dut.ram_name.ram[5]);
        $dumpvars(0, dut.ram_name.ram[6]);
        $dumpvars(0, dut.ram_name.ram[7]);

        $dumpvars(0, dut.stack_name.dstack[0]);
        $dumpvars(0, dut.stack_name.dstack[1]);
        $dumpvars(0, dut.stack_name.dstack[2]);
        $dumpvars(0, dut.stack_name.dstack[3]);
        $dumpvars(0, dut.stack_name.dstack[4]);
        $dumpvars(0, dut.stack_name.dstack[5]);
        $dumpvars(0, dut.stack_name.dstack[6]);
        $dumpvars(0, dut.stack_name.dstack[7]);

        $dumpvars(0, dut.stack_name.cstack[0]);
        $dumpvars(0, dut.stack_name.cstack[1]);
        $dumpvars(0, dut.stack_name.cstack[2]);
        $dumpvars(0, dut.stack_name.cstack[3]);
        $dumpvars(0, dut.stack_name.cstack[4]);
        $dumpvars(0, dut.stack_name.cstack[5]);
        $dumpvars(0, dut.stack_name.cstack[6]);
        $dumpvars(0, dut.stack_name.cstack[7]);
    end

    initial begin
        reset = 1; #5;
        reset = 0; #5;
        #20000;
        $finish;
    end

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    always @(negedge running) $finish;

endmodule