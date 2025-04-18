`include "param.v"
module imm_gen (
    imm,

    inst,
    imm_sel
);
    output  reg [31:0]  imm     ;
    input       [31:0]  inst    ;
    input       [2:0]   imm_sel ;

    always @* begin
        case (imm_sel)
            `IMM_SEL_I   :   imm = {{20{inst[31]}}, inst[31:20]};
            `IMM_SEL_S        :   imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            `IMM_SEL_SB       :   imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            `IMM_SEL_UJ       :   imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            `IMM_SEL_U    :   imm = {inst[31:12], 12'b0};
            default     :   imm = 0;
        endcase
    end
endmodule