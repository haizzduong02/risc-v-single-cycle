`include "0_macro.v"

module ControlLogic (
    output  reg         PC_sel,
    output  reg [ 2:0]  imm_sel,
    output  reg         reg_wr_en,
    output  reg         br_un,
    output  reg         B_sel,
    output  reg         A_sel,
    output  reg [ 3:0]  ALU_sel,
    output  reg         mem_rw,
    output  reg [ 2:0]  load_sel,
    output  reg [ 1:0]  store_sel,
    output  reg [ 1:0]  wb_sel,

    input       [31:0]  inst,
    input               br_eq,
    input               br_lt
);
    always @(*) begin
        PC_sel = `PC_SEL_NOTTAKEN;
        imm_sel = `IMM_SEL_I;
        reg_wr_en = 1'b0;
        br_un = 1'b1;
        B_sel = 1'b0;
        A_sel = 1'b0;
        ALU_sel = `ALU_SEL_ADD;
        mem_rw = `MEM_READ;
        load_sel = `LOAD_SEL_W;
        store_sel = `STORE_SEL_W;
        wb_sel = `WB_SEL_MEM;

        case (inst[6:0])
            `OP_R: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                reg_wr_en = 1'b1;
                B_sel = 1'b0;
                A_sel = 1'b0;
                case ({inst[14:12], inst[31:25]})
                    {`FUNCT3_ADD, `FUNCT7_ADD}:     ALU_sel = `ALU_SEL_ADD;
                    {`FUNCT3_SUB, `FUNCT7_SUB}:     ALU_sel = `ALU_SEL_SUB;
                    {`FUNCT3_AND, `FUNCT7_AND}:     ALU_sel = `ALU_SEL_AND;
                    {`FUNCT3_OR, `FUNCT7_OR}:       ALU_sel = `ALU_SEL_OR;
                    {`FUNCT3_XOR, `FUNCT7_XOR}:     ALU_sel = `ALU_SEL_XOR;
                    {`FUNCT3_SLL, `FUNCT7_SLL}:     ALU_sel = `ALU_SEL_SLL;
                    {`FUNCT3_SRL, `FUNCT7_SRL}:     ALU_sel = `ALU_SEL_SRL;
                    {`FUNCT3_SRA, `FUNCT7_SRA}:     ALU_sel = `ALU_SEL_SRA;
                    {`FUNCT3_SLT, `FUNCT7_SLT}:     ALU_sel = `ALU_SEL_SLT;
                    {`FUNCT3_SLTU, `FUNCT7_SLTU}:   ALU_sel = `ALU_SEL_SLTU;
                    default:                        ALU_sel = `ALU_SEL_ADD;
                endcase
                wb_sel = `WB_SEL_ALU;
            end
            `OP_I_ALU: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_I;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                A_sel = 1'b0;
                case ({inst[14:12]})
                    `FUNCT3_ADD:    ALU_sel = `ALU_SEL_ADD;
                    `FUNCT3_AND:    ALU_sel = `ALU_SEL_AND;
                    `FUNCT3_OR:     ALU_sel = `ALU_SEL_OR;
                    `FUNCT3_XOR:    ALU_sel = `ALU_SEL_XOR;
                    `FUNCT3_SLL:    ALU_sel = (inst[31:25] == `FUNCT7_SLL) ? `ALU_SEL_SLL : `ALU_SEL_ADD;
                    `FUNCT3_SRL, `FUNCT3_SRA: begin
                        case (inst[31:25])
                            `FUNCT7_SRL:    ALU_sel = `ALU_SEL_SRL;
                            `FUNCT7_SRA:    ALU_sel = `ALU_SEL_SRA; 
                            default:        ALU_sel = `ALU_SEL_ADD;
                        endcase
                    end
                    `FUNCT3_SLT:    ALU_sel = `ALU_SEL_SLT;
                    `FUNCT3_SLTU:   ALU_sel = `ALU_SEL_SLTU;
                    default:        ALU_sel = `ALU_SEL_ADD;
                endcase
                wb_sel = `WB_SEL_ALU;
            end
            `OP_I_LOAD: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_I;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                A_sel = 1'b0;
                ALU_sel = `ALU_SEL_ADD;
                mem_rw = `MEM_READ;
                case (inst[14:12])
                    `FUNCT3_LB:     load_sel = `LOAD_SEL_B;
                    `FUNCT3_LBU:    load_sel = `LOAD_SEL_BU;
                    `FUNCT3_LH:     load_sel = `LOAD_SEL_H;
                    `FUNCT3_LHU:    load_sel = `LOAD_SEL_HU;
                    `FUNCT3_LW:     load_sel = `LOAD_SEL_W;
                    default:        load_sel = `LOAD_SEL_W;
                endcase
                wb_sel = `WB_SEL_MEM;
            end
            `OP_S: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_S;
                reg_wr_en = 1'b0;
                B_sel = 1'b1;
                ALU_sel = `ALU_SEL_ADD;
                mem_rw = `MEM_WRITE;
                case (inst[14:12])
                    `FUNCT3_SB: store_sel = `STORE_SEL_B;
                    `FUNCT3_SH: store_sel = `STORE_SEL_H;
                    `FUNCT3_SW: store_sel = `STORE_SEL_W;
                    default:    store_sel = `STORE_SEL_W;
                endcase
            end
            `OP_B: begin
                case (inst[14:12])
                    `FUNCT3_BEQ: begin
                        br_un = 1'b0;
                        PC_sel = (br_eq == 1'b1) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end 
                    `FUNCT3_BNE: begin
                        br_un = 1'b0;
                        PC_sel = (br_eq == 1'b0) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end
                    `FUNCT3_BLT: begin
                        br_un = 1'b0;
                        PC_sel = (br_lt == 1'b1) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end
                    `FUNCT3_BGE: begin
                        br_un = 1'b0;
                        PC_sel = (br_lt == 1'b0) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end
                    `FUNCT3_BLTU: begin
                        br_un = 1'b1;
                        PC_sel = (br_lt == 1'b1) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end
                    `FUNCT3_BGEU: begin
                        br_un = 1'b1;
                        PC_sel = (br_lt == 1'b0) ? `PC_SEL_TAKEN : `PC_SEL_NOTTAKEN;
                    end
                    default: begin
                        br_un = 1'b0;
                        PC_sel = `PC_SEL_NOTTAKEN;
                    end
                endcase
                imm_sel = `IMM_SEL_B;
                reg_wr_en = 1'b0;
                B_sel = 1'b1;
                A_sel = 1'b1;
                ALU_sel = `ALU_SEL_ADD;
                //mem_rw = `MEM_READ;
            end
            `OP_I_JALR: begin
                PC_sel = `PC_SEL_TAKEN;
                imm_sel = `IMM_SEL_I;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                A_sel = 1'b0;
                ALU_sel = `ALU_SEL_ADD;
                //mem_rw = `MEM_READ;
                wb_sel = `WB_SEL_PC4;
            end
            `OP_J: begin
                PC_sel = `PC_SEL_TAKEN;
                imm_sel = `IMM_SEL_J;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                A_sel = 1'b1;
                ALU_sel = `ALU_SEL_ADD;
                //mem_rw = `MEM_READ;
                wb_sel = `WB_SEL_PC4;
            end
            `OP_U_LUI: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_U;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                ALU_sel = `ALU_SEL_B;
                //mem_rw = `MEM_READ;
                wb_sel = `WB_SEL_ALU;
            end
            `OP_U_AUIPC: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_U;
                reg_wr_en = 1'b1;
                B_sel = 1'b1;
                A_sel = 1'b1;
                ALU_sel = `ALU_SEL_ADD;
                //mem_rw = `MEM_READ;
                wb_sel = `WB_SEL_ALU;
            end
            default: begin
                PC_sel = `PC_SEL_NOTTAKEN;
                imm_sel = `IMM_SEL_I;
                reg_wr_en = 1'b0;
                br_un = 1'b1;
                B_sel = 1'b0;
                A_sel = 1'b0;
                ALU_sel = `ALU_SEL_ADD;
                //mem_rw = `MEM_READ;
                load_sel = `LOAD_SEL_W;
                store_sel = `STORE_SEL_W;
                wb_sel = `WB_SEL_MEM;
            end
        endcase
    end
endmodule