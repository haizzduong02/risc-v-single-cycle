module imm_gen (
    imm,

    inst
);
    output  reg [31:0]  imm ;
    input       [31:0]  inst;

    always @* begin
        case (inst[6:0])
            OP_I_LOAD   :   imm = {{20{inst[31]}}, inst[31:20]}; 
            OP_I_ALU    :   imm = {{20{inst[31]}}, inst[31:20]};
            OP_I_JALR   :   imm = {{20{inst[31]}}, inst[31:20]};
            OP_S        :   imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            OP_SB       :   imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            OP_UJ       :   imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            OP_U_LUI    :   imm = {inst[31:12], 12'b0};
            OP_U_AUIPC  :   imm = {inst[31:12], 12'b0};
            default     :   imm = 0;
        endcase
    end
endmodule