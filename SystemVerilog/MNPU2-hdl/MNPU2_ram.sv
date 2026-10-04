`timescale 1ps/1ps

module ram (
    input clk, reset, toggle_exec_in,
    input [7:0] instruction_in, acc_in, reg_in,
    
    output logic [7:0] ram_out
);

logic [7:0] ram [0:255];
logic [7:0] poi;

assign ram_out = ram[poi];

always_ff @(posedge clk) begin
    if (reset) begin
        poi <= 0;
        for (int i = 0; i < 256; i = i + 1) begin
            ram[i] <= 0;
        end
    end
    else begin
        if (toggle_exec_in) begin
            case (instruction_in[7:3])
                24: begin // POI
                    poi <= reg_in;
                end
                25: begin // MST
                    ram[poi] <= acc_in;
                end
            endcase
        end
    end
end

endmodule