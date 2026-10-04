`timescale 1ps/1ps

module rom (
    input clk,
    input [5:0] pc_in,
    input [7:0] page_in,
    output logic [7:0] instruction_out
);

    logic [7:0] rom [0:16383];

    initial begin
        $readmemb("program.bin", rom);
    end

    always_ff @(posedge clk) begin
        instruction_out <= rom[{page_in, pc_in}];
    end

endmodule