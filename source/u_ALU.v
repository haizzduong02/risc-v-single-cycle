`include "0_macro.v"

module ALU (
    output  reg [31:0]  result,

    input       [31:0]  srcA,
    input       [31:0]  srcB,
    input       [3:0]   ALU_sel
);
    always @(*) begin
        case (ALU_sel)
            `ALU_SEL_ADD:   result = srcA + srcB;
            `ALU_SEL_SUB:   result = srcA - srcB;

            `ALU_SEL_AND:   result = srcA & srcB;
            `ALU_SEL_OR:    result = srcA | srcB;
            `ALU_SEL_XOR:   result = srcA ^ srcB;
            
            `ALU_SEL_SLL:   result = srcA << srcB[4:0];
            `ALU_SEL_SRL:   result = srcA >> srcB[4:0];
            `ALU_SEL_SRA:   result = $signed(srcA) >>> srcB[4:0];

            `ALU_SEL_SLT:   result = ($signed(srcA) < $signed(srcB));
            `ALU_SEL_SLTU:  result = (srcA < srcB);

            `ALU_SEL_A:     result = srcA;
            `ALU_SEL_B:     result = srcB;

            default:        result = {32{1'b0}};
        endcase
    end
endmodule