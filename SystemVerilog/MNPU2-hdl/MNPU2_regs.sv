`timescale 1ps/1ps

module regs (
    input clk, reset, toggle_exec_in,
    input [7:0] instruction_in, data_in,
    
    output logic [7:0] reg_out
);
    logic imm, writeback;

    logic [2:0] address, address_buffer;
    assign address = instruction_in[2:0];

    logic [7:0] register [1:7];

    always_comb begin
        if ((address == address_buffer) && writeback) reg_out = data_in;
        else if (address == 0) reg_out = 0;
        else reg_out = register[address];
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 1; i < 8; i = i + 1) register[i] <= 0;
            address_buffer <= 0;
            imm <= 0;
            writeback <= 0;
        end
        else begin
            writeback <= 0;
            imm <= 0;
            address_buffer <= address;
            if (toggle_exec_in) begin
                if ((address_buffer != 0) && writeback) register[address_buffer] <= data_in;
                case (instruction_in[7:3])
                    0, 6, 7, 8, 9, 13, 29: begin //reg writeback
                        writeback <= 1;
                    end
                endcase
                if (instruction_in[7:3] == 14) imm <= 1;
            end
            if (imm) begin
                if (address_buffer != 0) register[address_buffer] <= data_in;
            end
        end
    end

endmodule