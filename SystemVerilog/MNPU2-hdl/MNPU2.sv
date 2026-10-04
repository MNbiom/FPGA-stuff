`timescale 1ps/1ps

module MNPU2 (
    input clk, reset,
    output logic running,

    input in_confirm,
    input [7:0] in [0:7],

    output logic out_info [0:7],
    output logic [7:0] out [0:7]
);
    logic toggle_exec, flush, zero, cout, msb_lsb;
    logic [5:0] pc, cstack_pc;
    logic [7:0] page, instruction, sum, register, acc, ram, dstack, cstack_page, io;

    pc pc_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .zero_in(zero), .cout_in(cout), .msb_lsb_in(msb_lsb), .instruction_in(instruction), .flush_out(flush), .pc_out(pc), .page_out(page), .pc_in(cstack_pc), .page_in(cstack_page));
    rom rom_name (.clk(clk), .pc_in(pc), .page_in(page), .instruction_out(instruction));
    exe_control exe_name (.clk(clk), .reset(reset), .flush_in(flush), .instruction_in(instruction[7:3]), .toggle_exec_out(toggle_exec), .running(running));
    alu alu_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .instruction_in(instruction), .reg_in(register), .sum_out(sum), .acc_out(acc), .cout_out(cout), .zero_out(zero), .msb_lsb_out(msb_lsb), .ram_in(ram), .dstack_in(dstack), .input_in(io));
    regs regs_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .instruction_in(instruction), .data_in(sum), .reg_out(register));
    io io_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .instruction_in(instruction), .acc_in(acc), .input_out(io), .in_confirm(in_confirm), .in(in), .out_info(out_info), .out(out));
    ram ram_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .instruction_in(instruction), .acc_in(acc), .reg_in(register), .ram_out(ram));
    stack stack_name (.clk(clk), .reset(reset), .toggle_exec_in(toggle_exec), .pc_in(pc), .instruction_in(instruction), .data_in(acc), .page_in(page), .data_out(dstack), .pc_out(cstack_pc), .page_out(cstack_page));

endmodule