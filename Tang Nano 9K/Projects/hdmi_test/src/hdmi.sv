//pixel_clk = 25,2MHz
//ser_clk = 126MHz

`timescale 1ps/1ps

module hdmi (
    input pixel_clk, ser_clk, resetn,

    output [10:0] x, y,

    output tmds_clk_p, tmds_clk_n,
    output [2:0] tmds_d_p, tmds_d_n
);

logic hsync, vsync, active;
logic [7:0] red, green, blue;
logic [9:0] tmds_red, tmds_green, tmds_blue;
logic tmds_red_serial, tmds_green_serial, tmds_blue_serial;

video_timing video_timing (.pixel_clk(pixel_clk), .resetn(resetn), .x(x), .y(y), .red(red), .green(green), .blue(blue), .hsync_out(hsync), .vsync_out(vsync), .active_out(active));

tmds_encoder tmds_encoder_red (.pixel_clk(pixel_clk), .resetn(resetn), .hsync_in(hsync), .vsync_in(vsync), .active_in(active), .data_in(red), .tmds_out(tmds_red));
tmds_encoder tmds_encoder_blue (.pixel_clk(pixel_clk), .resetn(resetn), .hsync_in(hsync), .vsync_in(vsync), .active_in(active), .data_in(blue), .tmds_out(tmds_blue));
tmds_encoder tmds_encoder_green (.pixel_clk(pixel_clk), .resetn(resetn), .hsync_in(hsync), .vsync_in(vsync), .active_in(active), .data_in(green), .tmds_out(tmds_green));

OSER10 oser10_red (
    .Q    (tmds_red_serial),
    .D0   (tmds_red[0]),
    .D1   (tmds_red[1]),
    .D2   (tmds_red[2]),
    .D3   (tmds_red[3]),
    .D4   (tmds_red[4]),
    .D5   (tmds_red[5]),
    .D6   (tmds_red[6]),
    .D7   (tmds_red[7]),
    .D8   (tmds_red[8]),
    .D9   (tmds_red[9]),
    .PCLK (pixel_clk),
    .FCLK (ser_clk),
    .RESET(!resetn)
);

OSER10 oser10_green (
    .Q    (tmds_green_serial),
    .D0   (tmds_green[0]),
    .D1   (tmds_green[1]),
    .D2   (tmds_green[2]),
    .D3   (tmds_green[3]),
    .D4   (tmds_green[4]),
    .D5   (tmds_green[5]),
    .D6   (tmds_green[6]),
    .D7   (tmds_green[7]),
    .D8   (tmds_green[8]),
    .D9   (tmds_green[9]),
    .PCLK (pixel_clk),
    .FCLK (ser_clk),
    .RESET(!resetn)
);

OSER10 oser10_blue (
    .Q    (tmds_blue_serial),
    .D0   (tmds_blue[0]),
    .D1   (tmds_blue[1]),
    .D2   (tmds_blue[2]),
    .D3   (tmds_blue[3]),
    .D4   (tmds_blue[4]),
    .D5   (tmds_blue[5]),
    .D6   (tmds_blue[6]),
    .D7   (tmds_blue[7]),
    .D8   (tmds_blue[8]),
    .D9   (tmds_blue[9]),
    .PCLK (pixel_clk),
    .FCLK (ser_clk),
    .RESET(!resetn)
);

ELVDS_OBUF tmds_buf_red (
    .I  (tmds_red_serial),
    .O  (tmds_d_p[2]),
    .OB (tmds_d_n[2])
);

ELVDS_OBUF tmds_buf_green (
    .I  (tmds_green_serial),
    .O  (tmds_d_p[1]),
    .OB (tmds_d_n[1])
);

ELVDS_OBUF tmds_buf_blue (
    .I  (tmds_blue_serial),
    .O  (tmds_d_p[0]),
    .OB (tmds_d_n[0])
);

ELVDS_OBUF tmds_buf_clk (
    .I  (pixel_clk),
    .O  (tmds_clk_p),
    .OB (tmds_clk_n)
);


endmodule

module video_timing (
    input pixel_clk, resetn,

    output logic [10:0] x, y,
    output logic [7:0] red, green, blue,
    output logic hsync_out, vsync_out, active_out
);

localparam WIDTH = 11'd640;
localparam W_FPORCH = 11'd16;
localparam W_SYNC = 11'd96;
localparam W_BPORCH = 11'd48;
localparam W_TOTAL = WIDTH + W_FPORCH + W_SYNC + W_BPORCH;

localparam HEIGHT = 11'd480;
localparam H_FPORCH = 11'd10;
localparam H_SYNC = 11'd2;
localparam H_BPORCH = 11'd33;
localparam H_TOTAL = HEIGHT + H_FPORCH + H_SYNC + H_BPORCH;

always_ff @(posedge pixel_clk or negedge resetn) begin
    if (!resetn) begin
        x <= 0;
        y <= 0;
    end else begin
        if (x == W_TOTAL-1) begin
            x <= 0;
            if (y == H_TOTAL-1) y <= 0;
            else y <= y + 1'b1;
        end
        else x <= x + 1'b1;
    end
end

always_comb begin
    active_out = (x < WIDTH) && (y < HEIGHT);

    hsync_out = !((x >= WIDTH + W_FPORCH) && (x <  WIDTH + W_FPORCH + W_SYNC));

    vsync_out = !((y >= HEIGHT + H_FPORCH) && (y <  HEIGHT + H_FPORCH + H_SYNC));
end

always_comb begin //color gen
    if (!active_out) begin
        red   = 8'd0;
        green = 8'd0;
        blue  = 8'd0;
    end else if (x < 213) begin
        red   = 8'hff;
        green = 8'h00;
        blue  = 8'h00;
    end else if (x < 426) begin
        red   = 8'h00;
        green = 8'hff;
        blue  = 8'h00;
    end else begin
        red   = 8'h00;
        green = 8'h00;
        blue  = 8'hff;
    end
    // else if (x==y) begin
    //     red   = 8'hff;
    //     green = 8'hff;
    //     blue  = 8'hff;
    // end else begin
    //     red   = 8'd0;
    //     green = 8'd0;
    //     blue  = 8'd0;
    // end
end

endmodule

module tmds_encoder (
    input pixel_clk, resetn,
    input hsync_in, vsync_in, active_in,
    input [7:0] data_in,

    output logic [9:0] tmds_out
);

logic signed [4:0] disparity;

always_ff @(posedge pixel_clk or negedge resetn) begin
    if (!resetn) begin
        tmds_out <= 0;
        disparity <= 0;
    end else begin
        if (!active_in) begin
            disparity <= 0;
            case ({vsync_in, hsync_in})
                2'b00: tmds_out <= 10'b1101010100;
                2'b01: tmds_out <= 10'b0010101011;
                2'b10: tmds_out <= 10'b0101010100;
                2'b11: tmds_out <= 10'b1010101011;
            endcase
        end else begin
            if ((disparity == 0) || (ones_qm == zeros_qm)) begin
                tmds_out[9] <= ~q_m[8];
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= (q_m[8]) ? q_m[7:0] : ~q_m[7:0];
                if (q_m[8])
                    disparity <= ones_qm - zeros_qm;
                else
                    disparity <= zeros_qm - ones_qm;
            end else if (((disparity > 0) && (ones_qm > zeros_qm)) || ((disparity < 0) && (zeros_qm > ones_qm))) begin
                tmds_out[9] <= 1'b1;
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= ~q_m[7:0];
                disparity <= disparity + 5'd2 * q_m[8] + zeros_qm - ones_qm;
            end else begin
                tmds_out[9] <= 1'b0;
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= q_m[7:0];
                disparity <= disparity - 5'd2 * !q_m[8] + ones_qm - zeros_qm;
            end
        end
    end
end

logic [8:0] q_m;
logic signed [4:0] ones_data, ones_qm, zeros_qm;

always_comb begin
    ones_data = 0;
    for (int i = 0; i < 8; i++)
        ones_data = ones_data + data_in[i];

    if ((ones_data > 4) || ((ones_data == 4) && (data_in[0] == 0))) begin
        // NXOR
        q_m[0] = data_in[0];
        for (int i = 1; i < 8; i++)
            q_m[i] = ~(q_m[i-1] ^ data_in[i]);
        q_m[8] = 1'b0;
    end else begin
        // XOR
        q_m[0] = data_in[0];
        for (int i = 1; i < 8; i++)
            q_m[i] = q_m[i-1] ^ data_in[i];
        q_m[8] = 1'b1;
    end

    ones_qm = 0;
    for (int i = 0; i < 8; i++)
        ones_qm = ones_qm + q_m[i];
    zeros_qm = 5'd8 - ones_qm;

end


endmodule