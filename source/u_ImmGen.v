`include "0_macro.v"

module ImmGen (
    output  reg [31:0]  imm,

    input       [31:0]  inst,
    input       [ 2:0]  imm_sel
);
    always @(*) begin
        case (imm_sel)
            `IMM_SEL_I: imm = {{20{inst[31]}}, inst[31:20]};
            `IMM_SEL_S: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            `IMM_SEL_B: imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            `IMM_SEL_J: imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            `IMM_SEL_U: imm = {inst[31:12], 12'b0};
            default:    imm = {32{1'b0}};
        endcase
    end
endmodule