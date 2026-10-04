`timescale 1ps/1ps

module pc (
    input clk, reset, toggle_exec_in, zero_in, cout_in, msb_lsb_in,
    input [5:0] pc_in,
    input [7:0] instruction_in, page_in,

    output logic flush_out,
    output logic [5:0] pc_out,
    output logic [7:0] page_out
);

logic brc, cond;
logic [1:0] swp;
logic [7:0] swp_tmp;

always_ff @(posedge clk) begin
    brc <= 0;
    swp <= swp >> 1;
    if (reset) begin
        pc_out <= 0;
        page_out <= 0;
        swp <= 0;
        swp_tmp <= 0;
        flush_out <= 0;
    end
    else begin
        flush_out <= 0;
        
        pc_out <= pc_out + 1;
        case (instruction_in[2:0])
            0: cond <= 1; // TRUE
            1: cond <= !zero_in; // NEQ, NZERO
            2: cond <= zero_in; // EQ, ZERO
            3: cond <= !cout_in; // LT, NCARRY
            4: cond <= !cout_in || zero_in; // LEQ
            5: cond <= cout_in && !zero_in; // GT
            6: cond <= cout_in; // GEQ, CARRY
            7: cond <= msb_lsb_in; // MSB/LSB
        endcase
        if (toggle_exec_in) begin
            case (instruction_in[7:3])
                21: brc <= 1; // BRC
                16, 17: swp <= 2; // SWP/CALL
                18: {page_out, pc_out} <= {page_in, pc_in}; // RET
            endcase
        end
        if (brc && cond) begin
            pc_out <= instruction_in[5:0];
            flush_out <= 1;
        end
        if (swp[1]) swp_tmp <= instruction_in;
        if (swp[0]) begin
            page_out <= swp_tmp;
            pc_out <= instruction_in[5:0];
            flush_out <= 1;
        end
    end
end

endmodule