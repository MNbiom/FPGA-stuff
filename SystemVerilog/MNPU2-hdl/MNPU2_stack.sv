`timescale 1ps/1ps

module stack (
    input clk, reset, toggle_exec_in,
    input [5:0] pc_in,
    input [7:0] instruction_in, data_in, page_in, 
    
    output logic [5:0] pc_out,
    output logic [7:0] page_out, data_out
);

localparam DSTACK_SIZE = 8;
localparam CSTACK_SIZE = 8;

logic [3:0] dsp, csp;
logic [7:0] dstack [DSTACK_SIZE];
logic [13:0] cstack [CSTACK_SIZE];

assign data_out = (dsp > 0) ? dstack[dsp - 1] : 0;
assign {page_out, pc_out} = (csp > 0) ? cstack[csp - 1] : 0;

always_ff @(posedge clk) begin
    if (reset) begin
        dsp <= 0;
        csp <= 0;
        for (int i = 0; i < DSTACK_SIZE; i = i + 1) begin
            dstack[i] <= 0;
            cstack[i] <= 0;
        end
    end
    else begin
        if (toggle_exec_in) begin
            case (instruction_in[7:3])
                17: begin // CALL
                    if (csp < CSTACK_SIZE) begin
                        cstack[csp] <= {page_in, pc_in+2'd2};
                        csp <= csp + 1;
                    end
                end
                18: begin // RET
                    if (csp > 0) begin
                        csp <= csp - 1;
                        cstack[csp - 1] <= 0;
                    end 
                end
                22: begin // PUSH
                    if (dsp < DSTACK_SIZE) begin
                        dstack[dsp] <= data_in;
                        dsp <= dsp + 1;
                    end
                end
                23: begin // POP
                    if (dsp > 0) begin
                        dsp <= dsp - 1;
                        dstack[dsp - 1] <= 0;
                    end 
                end
            endcase
        end
    end
end

endmodule