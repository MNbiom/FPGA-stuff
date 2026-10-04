
module top(
	input clk, // 27M
	input resetn,

	output lcd_resetn,
	output lcd_clk,
	output lcd_cs,
	output lcd_rs,
	output lcd_data
);

logic lcd_ready, draw_pixel, drawing, finished;
logic [15:0] pixel;

lcd lcd (.clk(clk), .resetn(resetn), .pixel_in(pixel), .draw_pixel_in(draw_pixel), .drawing_out(drawing), .finished_out(finished),
    .lcd_resetn(lcd_resetn), .lcd_clk(lcd_clk), .lcd_cs(lcd_cs), .lcd_rs(lcd_rs), .lcd_data(lcd_data));

logic start, running;
logic [4:0] color;
logic [7:0] x, y;

mandelbrot mandelbrot (.clk(clk), .resetn(resetn), .start_in(start), .x_in(x), .y_in(y), .color_out(color), .running_out(running));

logic done, prev_running, prev_drawing, finished_pixel;

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        x <= 0;
        y <= 134;
        start <= 0;
        lcd_ready <= 0;
        draw_pixel <= 0;
        done <= 0;
        finished_pixel <= 1;
    end else if (lcd_ready) begin
        if (!done && !running && !start && finished_pixel) begin //give x,y to mandelbrot
            if (x == 8'd239) begin
                x <= 0;
                if (y == 8'd0) begin
                    y <= 134;
                    done <= 1;
                end
                else y <= y - 1'b1;
            end
            else x <= x + 1'b1;

            start <= 1;
            finished_pixel <= 0;
        end else if (start) begin //set start back to 0
            start <= 0;
        end

        if (prev_running && !running && !draw_pixel) begin //if finished calculation start drawing
            pixel <= {color, color, 1'b0, color};
            draw_pixel <= 1;
        end else begin //set draw_pixel back to 0
            draw_pixel <= 0;
        end

        if (prev_drawing && !drawing) begin //check if pixel finished drawing
            finished_pixel <= 1;
        end

    end else begin
        lcd_ready <= finished;
    end
end

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        prev_running <= 0;
        prev_drawing <= 0;
    end else begin
        prev_running <= running;
        prev_drawing <= drawing;
    end
end

endmodule