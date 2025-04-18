`include "param.v"
module ALU (
    result,

    srcA,
    srcB,
    ALU_sel
);
    output  reg [31:0]  result      ;


    input       [31:0]  srcA        ;
    input       [31:0]  srcB        ;
    input       [3:0]   ALU_sel     ;

    always @* begin
        case (ALU_sel)
            `ALU_ADD :   result = srcA + srcB;
            `ALU_SUB :   result = srcA - srcB;

            `ALU_AND :   result = srcA & srcB;
            `ALU_OR  :   result = srcA | srcB;
            `ALU_XOR :   result = srcA ^ srcB;

            `ALU_SLT :   result = (srcA[31] == srcB[31]) ? (srcA < srcB) : srcA[31];
            `ALU_SLTU:   result = (srcA < srcB);
            `ALU_SLL :   result = srcA << srcB[4:0];
            `ALU_SRL :   result = srcA >> srcB[4:0];
            `ALU_SRA :   result = srcA >>> srcB[4:0];

            `ALU_A   :   result = srcA;
            `ALU_B   :   result = srcB;

            default :   result = 0;
        endcase
    end
endmodule