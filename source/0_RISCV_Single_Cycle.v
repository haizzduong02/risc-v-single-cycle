module RISCV_Single_Cycle (
    input       clk,
    input       rst_n
);
    single_cycle_riscv_processor single_cycle_riscv_processor_i (
        .clk    (clk),
        .rst_n  (rst_n)
    );
endmodule