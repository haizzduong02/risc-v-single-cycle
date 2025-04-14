module ALU (
    result,
    zero_flag,

    src1,
    src2,
    ALU_sel
);
    output  reg [ALU_DATA_LEN-1:0]  result      ;
    output  reg                     zero_flag   ;

    input       [ALU_DATA_LEN-1:0]  src1        ;
    input       [ALU_DATA_LEN-1:0]  src2        ;
    input       [ALU_SEL_LEN-1:0]   ALU_sel     ;

    always @* begin
        case (ALU_sel)
            ALU_ADD :   result = src1 + src2;
            ALU_SUB :   result = src1 - src2;

            ALU_AND :   result = src1 & src2;
            ALU_OR  :   result = src1 | src2;
            ALU_XOR :   result = src1 ^ src2;

            ALU_SLT :   result = (src1[ALU_DATA_LEN-1] == src2[ALU_DATA_LEN-1]) ? (src1 < src2) : src1[ALU_DATA_LEN-1];
            ALU_SLTU:   result = (src1 < src2);
            ALU_SLL :   result = src1 << src2[SHAMT_LEN-1:0];
            ALU_SRL :   result = src1 >> src2[SHAMT_LEN-1:0];
            ALU_SRA :   result = src1 >>> src2[SHAMT_LEN-1:0];

            default :   result = 0;
        endcase

        zero_flag = (result == 0);

    end
endmodule