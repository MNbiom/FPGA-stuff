`timescale 1ps/1ps

module mandelbrot_tb;
    logic clk, reset, start;
    logic [5:0] x, y;
    logic color, running;

    mandelbrot dut (.clk(clk), .reset(reset), .start(start), .x(x), .y(y), .color(color), .running(running));

    initial begin
        $dumpfile("mandelbrot.vcd");
        $dumpvars(0, mandelbrot_tb);
    end
    
    int file;
    initial begin
        file = $fopen("mandelbrot.ppm", "w");

        $fwrite(file, "P3\n");
        $fwrite(file, "64 64\n");
        $fwrite(file, "255\n");
    end

    initial begin
        start = 1; #10;
        start = 0; #10;
    end

    always @(x) begin
        if (color)
            $fwrite(file, "255 255 255 ");
        else
            $fwrite(file, "0 0 0 ");
    end
    always @(y) $fwrite(file, "\n");

    always @(negedge running) $finish;

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

endmodule