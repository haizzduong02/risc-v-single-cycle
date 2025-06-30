module RISCV_Sigle_Cycle (
    input       clk,
    input       rst_n
)
    single_cycle_riscv_processor dut(
      clk,
      rst_n
    );
endmodule
