`include "param.v"
module control_logic (
    ALU_sel,
    reg_wr_en,
    imm_sel,
    selB,
    mem_rw,
    selWB,
    selA,
    selPC,
    br_un,

    inst,
    br_eq,
    br_lt
);
    output  reg [3:0]   ALU_sel     ;
    output  reg         reg_wr_en   ;
    output  reg [2:0]   imm_sel     ;
    output  reg         selB        ;
    output  reg         mem_rw      ;
    output  reg [1:0]   selWB       ;
    output  reg         selA        ;
    output  reg         selPC       ;
    output  reg         br_un       ;

    input       [31:0]  inst        ;
    input               br_eq       ;
    input               br_lt       ;

    always @* begin
        reg_wr_en = 1'b0;
        imm_sel = 7'b0000000;
        selB = 1'b0;
        mem_rw = `MEM_READ;
        selWB = `WB_ALU;
        selA = 1'b0;
        selPC = `PC_NOTTAKEN;
        case (inst[6:0])
            `OP_R: begin
                reg_wr_en = 1'b1;
                    case ({inst[31:25], inst[14:12]})
                        {`FUNCT7_ADD, `FUNCT3_ADD_SUB}: ALU_sel = `ALU_ADD;
                        {`FUNCT7_SUB, `FUNCT3_ADD_SUB}: ALU_sel = `ALU_SUB;
                        {`FUNCT7_SLL, `FUNCT3_SLL}    : ALU_sel = `ALU_SLL;
                        {`FUNCT7_SLT, `FUNCT3_SLT}    : ALU_sel = `ALU_SLT;
                        {`FUNCT7_SLTU, `FUNCT3_SLTU}  : ALU_sel = `ALU_SLTU;
                        {`FUNCT7_XOR, `FUNCT3_XOR}    : ALU_sel = `ALU_XOR;
                        {`FUNCT7_SRL, `FUNCT3_SRL_SRA}: ALU_sel = `ALU_SRL;
                        {`FUNCT7_SRA, `FUNCT3_SRL_SRA}: ALU_sel = `ALU_SRA;
                        {`FUNCT7_OR, `FUNCT3_OR}      : ALU_sel = `ALU_OR;
                        {`FUNCT7_AND, `FUNCT3_AND}    : ALU_sel = `ALU_AND;
                        default                     : ALU_sel = `ALU_ADD;
                    endcase
            end
            `OP_I_ALU: begin
                reg_wr_en = 1'b1;
                selB = 1'b1;
                imm_sel = `IMM_SEL_I;
                    case (inst[14:12])
                        `FUNCT3_ADD_SUB: ALU_sel = `ALU_ADD;
                        `FUNCT3_SLL    : ALU_sel = `ALU_SLL;
                        `FUNCT3_SLT    : ALU_sel = `ALU_SLT;
                        `FUNCT3_SLTU   : ALU_sel = `ALU_SLTU;
                        `FUNCT3_XOR    : ALU_sel = `ALU_XOR;
                        `FUNCT3_SRL_SRA: begin
                            case (inst[31:25])
                                `FUNCT7_SRL: ALU_sel = `ALU_SRL;
                                `FUNCT7_SRA: ALU_sel = `ALU_SRA;
                            endcase
                        end
                        `FUNCT3_OR     : ALU_sel = `ALU_OR;
                        `FUNCT3_AND    : ALU_sel = `ALU_AND;
                        default       : ALU_sel = `ALU_ADD;
                    endcase
            end
            `OP_I_LOAD: begin
                ALU_sel = `ALU_ADD;
                reg_wr_en = 1'b1;
                selB = 1'b1;
                imm_sel = `IMM_SEL_I;
                mem_rw = `MEM_READ;
                selWB = `WB_DMEM;
            end
            `OP_S: begin
                imm_sel = `IMM_SEL_S;
                reg_wr_en = 1'b0;
                selB = 1'b1;
                ALU_sel = `ALU_ADD;
                mem_rw = `MEM_WRITE;
            end
            `OP_SB: begin
                selA = 1'b1;
                imm_sel = `IMM_SEL_SB;
                reg_wr_en = 1'b0;
                selA = 1'b1;
                selB = 1'b1;
                ALU_sel = `ALU_ADD;
                mem_rw = `MEM_READ;
                case (inst[14:12])
                    `FUNCT3_BEQ: begin
                        br_un = 1'b0;
                        if (br_eq) begin
                            selPC = `PC_TAKEN;
                        end else begin
                            selPC = `PC_NOTTAKEN;
                        end
                    end 
                    `FUNCT3_BGE: begin
                        br_un = 1'b0;
                        if (br_lt) begin
                            selPC = `PC_NOTTAKEN;
                        end else begin
                            selPC = `PC_TAKEN;
                        end
                    end
                    `FUNCT3_BLT: begin
                        br_un = 1'b0;
                        if (br_lt) begin
                            selPC = `PC_TAKEN;
                        end else begin
                            selPC = `PC_NOTTAKEN;
                        end
                    end
                    `FUNCT3_BNE: begin
                        br_un = 1'b0;
                        if (br_eq) begin
                            selPC = `PC_NOTTAKEN;
                        end else begin
                            selPC = `PC_TAKEN;
                        end
                    end
                    `FUNCT3_BGEU: begin
                        br_un = 1'b1;
                        if (br_lt) begin
                            selPC = `PC_NOTTAKEN;
                        end else begin
                            selPC = `PC_TAKEN;
                        end
                    end
                    `FUNCT3_BLTU: begin
                        br_un = 1'b1;
                        if (br_lt) begin
                            selPC = `PC_TAKEN;
                        end else begin
                            selPC = `PC_NOTTAKEN;
                        end
                    end

                endcase
            end
            `OP_I_JALR: begin
                selPC = `PC_TAKEN;
                imm_sel =  `IMM_SEL_I;
                reg_wr_en = 1'b1;
                selB = 1'b1;
                selA = 1'b0;
                ALU_sel = `ALU_ADD;
                mem_rw = `MEM_READ;
                selWB = `WB_PC;
            end
            `OP_UJ: begin
                selPC = `PC_TAKEN;
                imm_sel = `IMM_SEL_UJ;
                reg_wr_en = 1'b1;
                selB = 1'b1;
                selA = 1'b1;
                ALU_sel = `ALU_ADD;
                mem_rw = `MEM_READ;
                selWB = `WB_PC;
            end
            `OP_U_LUI: begin
                selPC = `PC_NOTTAKEN;
                imm_sel = `IMM_SEL_U;
                reg_wr_en = 1'b1;
                selB = 1'b1;
                ALU_sel = `ALU_B;
                mem_rw = `MEM_READ;
                selWB = `WB_ALU;
            end
            `OP_U_AUIPC:begin
                selPC = `PC_NOTTAKEN;
                imm_sel = `IMM_SEL_U;
                reg_wr_en = 1'b1;
                selB = 1'b1;
                ALU_sel = `ALU_ADD;
                mem_rw = `MEM_READ;
                selWB = `WB_ALU;
            end

        endcase
    end

    
endmodule