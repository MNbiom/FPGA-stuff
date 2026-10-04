module top (
    input clk, resetn,

    output tmds_clk_p, tmds_clk_n,
    output [2:0] tmds_d_p, tmds_d_n
);

logic pixel_clk, ser_clk, pll_lock;

Gowin_rPLL your_instance_name(
    .clkout(ser_clk), //output clkout
    .lock(pll_lock), //output lock
    .clkin(clk) //input clkin
);

Gowin_CLKDIV clkdiv(
    .clkout(pixel_clk), //output clkout
    .hclkin(ser_clk), //input hclkin
    .resetn(pll_lock) //input resetn
);

hdmi hdmi_name (.pixel_clk(pixel_clk), .ser_clk(ser_clk), .resetn(resetn&pll_lock), .x(), .y(), .tmds_clk_p(tmds_clk_p), .tmds_clk_n(tmds_clk_n), .tmds_d_p(tmds_d_p), .tmds_d_n(tmds_d_n));

endmodule