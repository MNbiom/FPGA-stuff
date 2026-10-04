`timescale 1ps/1ps

module mandelbrot (
    input clk, reset, start,
    output logic [5:0] x, y,
    output logic color, running
);
    logic [31:0] test;
    assign test = $abs((16'sd53 * -16'sd38));

    logic loop;
    logic [4:0] n = 5'd20;
    logic signed [15:0] cr, ci, zr, zi;
    logic signed [15:0] zr_zr, zi_zi, zr_zi;
    wire signed [31:0] zr_zr_mult, zi_zi_mult, zr_zi_mult, zr_zi_abs;
    wire [15:0] zr_zi_shift;

    assign cr = 16'b1111_1110_1000_0000 + (x<<3); // cr = -1.5 + (x/32)
    assign ci = 16'b1111_1111_0000_0000 + (y<<3); // ci = -1 + (y/32)

    assign zr_zr_mult = zr*zr;
    assign zi_zi_mult = zi*zi;
    assign zr_zi_mult = zr*zi;
    assign zr_zi_abs = zr_zi_mult[31] ? -zr_zi_mult : zr_zi_mult;
    assign zr_zi_shift = zr_zi_abs >> 8;

    assign zr_zr = zr_zr_mult >> 8;
    assign zi_zi = zi_zi_mult >> 8;
    assign zr_zi = (zr[15]^zi[15]) ? -zr_zi_shift : zr_zi_shift;

    always_ff @(posedge clk) begin
        if (reset) begin
            x <= 0;
            y <= 63;
            running <= 0;
        end
        else if (start) begin
            x <= 0;
            y <= 63;
            running <= 1;
            loop <= 1;
            n <= 20;
            zr <= 0;
            zi <= 0;
        end
        else if (running) begin ///
            if (!loop) begin
                if (x == 6'd63) begin
                    x <= 0;
                    if (y == 0) running <= 0;
                    else y <= y - 1;
                end
                else x <= x + 1;

                loop <= 1;
                n <= 5'd20;
                zr <= 0;
                zi <= 0;
            end
            else begin
                if ((zr_zr + zi_zi) < 16'b0000_0100_0000_0000 && n != 0) begin
                    zr <= (zr_zr - zi_zi) + cr;
                    zi <= (zr_zi << 1) + ci;
                    n <= n - 1;
                end
                else begin
                    loop <= 0;
                    if (n == 0) color <= 1;
                    else color <= 0;
                end
            end
        end ///
    end

endmodule