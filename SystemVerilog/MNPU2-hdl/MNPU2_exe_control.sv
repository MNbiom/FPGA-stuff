`timescale 1ps/1ps

module exe_control (
    input clk, reset, flush_in,
    input [4:0] instruction_in,
    
    output logic toggle_exec_out, running
);
    logic [1:0] immediate_count;

    assign toggle_exec_out = ~|immediate_count & !flush_in;

    always_ff @(posedge clk) begin
        if (reset) begin
            immediate_count <= 0;
            running <= 1;
        end
        else begin
            immediate_count <= immediate_count >> 1;
            if (toggle_exec_out) begin
                case (instruction_in)
                    14, 15, 21: immediate_count <= 1;
                    16, 17: immediate_count <= 2;
                    31: running <= 0;
                endcase
            end
        end
    end

endmodule