module ALU (
    result,
    zero_flag,

    srcA,
    srcB,
    ALU_sel
);
    output  reg [31:0]  result      ;
    output  reg         zero_flag   ;

    input       [31:0]  srcA        ;
    input       [31:0]  srcB        ;
    input       [3:0]   ALU_sel     ;

    always @* begin
        case (ALU_sel)
            ALU_ADD :   result = srcA + srcB;
            ALU_SUB :   result = srcA - srcB;

            ALU_AND :   result = srcA & srcB;
            ALU_OR  :   result = srcA | srcB;
            ALU_XOR :   result = srcA ^ srcB;

            ALU_SLT :   result = (srcA[31] == srcB[31]) ? (srcA < srcB) : srcA[31];
            ALU_SLTU:   result = (srcA < srcB);
            ALU_SLL :   result = srcA << srcB[4:0];
            ALU_SRL :   result = srcA >> srcB[4:0];
            ALU_SRA :   result = srcA >>> srcB[4:0];

            default :   result = 0;
        endcase

        zero_flag = (result == 0);

    end
endmodule