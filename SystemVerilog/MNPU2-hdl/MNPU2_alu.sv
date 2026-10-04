`timescale 1ps/1ps

module alu(
    input clk, reset, toggle_exec_in,
    input [7:0] instruction_in, reg_in, ram_in, dstack_in, input_in,
    
    output logic [7:0] sum_out, acc_out,
    output logic cout_out, zero_out, msb_lsb_out
);
    wire [4:0] instr;
    assign instr = instruction_in[7:3];

    logic imm, ima, cout, zero, msb_lsb;
    logic [7:0] sum, sum_buffer;

    assign zero = ~|sum;
    assign msb_lsb = sum&8'b0000_0001; // LSB

    always_comb begin
        sum = 0;
        cout = 0;
        if (toggle_exec_in) begin
            case (instr)
                0: begin //RST
                    sum = acc_out;
                end
                1: begin //RST
                    sum = reg_in;
                end
                2: begin // ADD
                    {cout, sum} = acc_out + reg_in;
                end
                3: begin // BSUB
                    {cout, sum} = {1'b0, ~acc_out} + {1'b0, reg_in} + 1'b1;
                end
                4: begin // SUB
                    {cout, sum} = {1'b0, acc_out} + {1'b0, ~reg_in} + 1'b1;
                end
                5: begin // CMP
                    {cout, sum} = {1'b0, acc_out} + {1'b0, ~reg_in} + 1'b1;
                end
                6: begin // INC
                    {cout, sum} = reg_in + 1'b1;
                end
                7: begin // DEC
                    {cout, sum} = reg_in + 8'hff;
                end
                8: begin // RSH
                    {sum, cout} = {1'b0, reg_in};
                end
                9: begin // LSH
                    {cout, sum} = {reg_in, 1'b0};
                end
                10: begin // XOR
                    {cout, sum} = {1'b1, acc_out ^ reg_in}; //cout from bitwise operations might be wrong, but its useless anyway
                end
                11: begin // OR
                    {cout, sum} = {1'b0, acc_out | reg_in};
                end
                12: begin // AND
                    {cout, sum} = {1'b1, acc_out & reg_in};
                end
                13: begin // NOT
                    {cout, sum} = {1'b0, ~reg_in};
                end
                19: begin // IN
                    {cout, sum} = {1'b0, input_in};
                end
                20: begin // OUT
                    sum = acc_out;
                end
                23: begin // POP
                    {cout, sum} = {1'b0, dstack_in};
                end
                26: begin // MLD
                    {cout, sum} = {1'b0, ram_in};
                end
                27: begin // ADDC
                    {cout, sum} = acc_out + reg_in + cout_out;
                end
                28: begin //SUBC
                    {cout, sum} = {1'b0, acc_out} + {1'b0, ~reg_in} + cout_out;
                end
                29: begin // NEG
                    {cout, sum} = {1'b0, ~reg_in} + 1'b1;
                end
                30: begin // NEGA
                    {cout, sum} = {1'b0, ~acc_out} + 1'b1;
                end
            endcase
        end
        if (imm || ima) sum_out = instruction_in;
        else sum_out = sum_buffer;
    end
     
    always_ff @(posedge clk) begin
        imm <= 0;
        ima <= 0;
        if (reset) begin
            acc_out <= 0;
            sum_buffer <= 0;
            cout_out <= 0;
            zero_out <= 0;
            msb_lsb_out <= 0;
        end
        else begin
            sum_buffer <= sum;
            if (toggle_exec_in) begin
                case (instr)
                    1, 2, 3, 4, 10, 11, 12, 19, 23, 26, 27, 28, 30: // acc writeback
                        acc_out <= sum;
                endcase
                case (instr)
                    2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 19, 23, 26, 27, 28, 29, 30: begin // flag update
                        cout_out <= cout;
                        zero_out <= zero;
                        msb_lsb_out <= msb_lsb;
                    end
                endcase

                if (instr == 14) imm <= 1;
                if (instr == 15) ima <= 1;
            end
            if (ima) acc_out <= sum_out;
        end
    end

endmodule