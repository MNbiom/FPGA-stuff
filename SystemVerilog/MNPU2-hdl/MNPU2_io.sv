`timescale 1ps/1ps

module io (
    input clk, reset, toggle_exec_in,
    input [7:0] acc_in, instruction_in,

    input in_confirm,
    input [7:0] in [0:7],

    output [7:0] input_out,
    output logic out_info [0:7],
    output logic [7:0] out [0:7]
);

assign input_out = in[instruction_in[2:0]]; // there is no halt on input (todo), also there is no halt in general for now

always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < 8; i = i + 1) begin
            out[i] <= 0;
            out_info[i] <= 0;
        end
    end
    else begin
        for (int i = 0; i < 8; i = i + 1) begin
            out_info[i] <= 0;
        end
        if (toggle_exec_in) begin
            if (instruction_in[7:3] == 20) begin // OUT
                out[instruction_in[2:0]] <= acc_in;
                out_info[instruction_in[2:0]] <= 1;
            end
        end
    end
end

endmodule