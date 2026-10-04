`timescale 1ps/1ps

module MNPU2_tb;
    logic clk, reset, running;
    wire out_info [0:7];
    wire [7:0] out [0:7];

    MNPU2 dut (.clk(clk), .reset(reset), .running(running), .out(out), .out_info(out_info));

    initial begin // make sure to comment this whole initial section when generating mandelbrot and to comment fixed time finish
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
        $dumpvars(0, dut.io_name.out_info[0]);
        $dumpvars(0, dut.io_name.out[1]);
        $dumpvars(0, dut.io_name.out_info[1]);
        $dumpvars(0, dut.io_name.out[2]);
        $dumpvars(0, dut.io_name.out_info[2]);
        $dumpvars(0, dut.io_name.out[3]);
        $dumpvars(0, dut.io_name.out_info[3]);
        $dumpvars(0, dut.io_name.out[4]);
        $dumpvars(0, dut.io_name.out_info[4]);
        $dumpvars(0, dut.io_name.out[5]);
        $dumpvars(0, dut.io_name.out_info[5]);
        $dumpvars(0, dut.io_name.out[6]);
        $dumpvars(0, dut.io_name.out_info[6]);
        $dumpvars(0, dut.io_name.out[7]);
        $dumpvars(0, dut.io_name.out_info[7]);

        $dumpvars(0, dut.ram_name.ram[0]);
        $dumpvars(0, dut.ram_name.ram[1]);
        $dumpvars(0, dut.ram_name.ram[2]);
        $dumpvars(0, dut.ram_name.ram[3]);
        $dumpvars(0, dut.ram_name.ram[4]);
        $dumpvars(0, dut.ram_name.ram[5]);
        $dumpvars(0, dut.ram_name.ram[6]);
        $dumpvars(0, dut.ram_name.ram[7]);
        $dumpvars(0, dut.ram_name.ram[8]);
        $dumpvars(0, dut.ram_name.ram[9]);
        $dumpvars(0, dut.ram_name.ram[10]);
        $dumpvars(0, dut.ram_name.ram[11]);
        $dumpvars(0, dut.ram_name.ram[12]);
        $dumpvars(0, dut.ram_name.ram[13]);
        $dumpvars(0, dut.ram_name.ram[14]);
        $dumpvars(0, dut.ram_name.ram[15]);
        $dumpvars(0, dut.ram_name.ram[16]);
        $dumpvars(0, dut.ram_name.ram[17]);

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
        #100000;
        $finish;
    end

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    always @(negedge running) $finish;

///////////////////////////////////// for mandelbrot

    // int file;
    // initial begin
    //     file = $fopen("display.ppm", "w");

    //     $fwrite(file, "P3\n");
    //     $fwrite(file, "64 64\n");
    //     $fwrite(file, "255\n");
    // end

    // always @(posedge out_info[6]) begin
    //     $display("TIME=%0t out[7]=%d, out[6]=%d, out[5]=%d", $time, out[7], out[6], out[5]);
    //     if (out[7] == 0)
    //         $fwrite(file, "255 255 255 ");
    //     else
    //         $fwrite(file, "0 0 0 ");
    // end
    // always @(out[6]) $fwrite(file, "\n");

endmodule