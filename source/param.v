`define OP_R            7'b0110011
`define OP_I_ALU        7'b0010011
`define OP_I_JALR       7'b1100111
`define OP_I_LOAD       7'b0000011
`define OP_I_F          7'b0001111
`define OP_I_SYS        7'b1110011
`define OP_S            7'b0100011
`define OP_SB           7'b1100011
`define OP_U_AUIPC      7'b0010111
`define OP_U_LUI        7'b0110111
`define OP_UJ           7'b1101111

`define FUNCT3_ADD_SUB  3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL_SRA  3'b101
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111

`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
`define FUNCT3_BLTU     3'b110
`define FUNCT3_BGEU     3'b111

`define FUNCT7_ADD      7'b0000000
`define FUNCT7_SUB      7'b0100000
`define FUNCT7_SLL      7'b0000000
`define FUNCT7_SLT      7'b0000000
`define FUNCT7_SLTU     7'b0000000
`define FUNCT7_XOR      7'b0000000
`define FUNCT7_SRL      7'b0000000
`define FUNCT7_SRA      7'b0100000
`define FUNCT7_OR       7'b0000000
`define FUNCT7_AND      7'b0000000


`define ALU_ADD         4'b0000
`define ALU_SUB         4'b0001
`define ALU_AND         4'b0010
`define ALU_OR          4'b0011
`define ALU_XOR         4'b0100
`define ALU_SLT         4'b0101
`define ALU_SLTU        4'b0110
`define ALU_SLL         4'b0111
`define ALU_SRL         4'b1000
`define ALU_SRA         4'b1001
`define ALU_A           4'b0110
`define ALU_B           4'b0111

`define IMM_SEL_I       3'b001
`define IMM_SEL_S       3'b010
`define IMM_SEL_SB      3'b011
`define IMM_SEL_UJ      3'b100
`define IMM_SEL_U       3'b101

`define MEM_READ        1'b0
`define MEM_WRITE       1'b1

`define WB_DMEM         2'b00
`define WB_PC           2'b10
`define WB_ALU          2'b01

`define PC_TAKEN        1'b1
`define PC_NOTTAKEN     1'b0