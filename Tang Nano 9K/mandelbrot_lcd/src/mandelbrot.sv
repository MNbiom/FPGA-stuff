`timescale 1ps/1ps

module mandelbrot (
    input clk, resetn, start_in,
    input logic [7:0] x_in, y_in,
    output logic [4:0] color_out,
    output logic running_out

);

localparam N_MAX = 5'd31;

logic [7:0] x, y, x_buffer, y_buffer;
logic [4:0] n;
logic signed [15:0] cr, ci, zr, zi;
logic signed [15:0] zr_zr, zi_zi, zr_zi;
wire signed [31:0] zr_zr_mult, zi_zi_mult, zr_zi_mult, zr_zi_abs;
wire [15:0] zr_zi_shift;

assign cr = -16'sb0000_0011_0000_0000 + (x<<2) + (x>>2);
assign ci = -16'sb0000_0001_0010_0000 + (y<<2) + (y>>2);

assign zr_zr_mult = zr*zr;
assign zi_zi_mult = zi*zi;
assign zr_zi_mult = zr*zi;
assign zr_zi_abs = zr_zi_mult[31] ? -zr_zi_mult : zr_zi_mult;
assign zr_zi_shift = zr_zi_abs >> 8;

assign zr_zr = zr_zr_mult >> 8;
assign zi_zi = zi_zi_mult >> 8;
assign zr_zi = (zr[15]^zi[15]) ? -zr_zi_shift : zr_zi_shift;

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        n <= N_MAX;
        running_out <= 0;
        color_out <= 0;
    end
    else if (start_in) begin
        running_out <= 1;
        n <= N_MAX;
        x <= x_buffer;
        y <= y_buffer;
        zr <= 0;
        zi <= 0;
    end
    else if (running_out) begin ///
        if ((zr_zr + zi_zi) < 16'b0000_0100_0000_0000 && n != 0) begin
            zr <= (zr_zr - zi_zi) + cr;
            zi <= (zr_zi << 1) + ci;
            n <= n - 1;
        end
        else begin
            running_out <= 0;
            color_out <= n;
        end
    end ///
end

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        x_buffer <= 0;
        y_buffer <= 0;
    end else begin
        x_buffer <= x_in;
        y_buffer <= y_in;
    end
end

endmodule