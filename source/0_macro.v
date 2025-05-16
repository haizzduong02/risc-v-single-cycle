
//===== Control logic encode signal =====

`define PC_SEL_TAKEN        1'b1
`define PC_SEL_NOTTAKEN     1'b0

`define IMM_SEL_I           3'b000
`define IMM_SEL_S           3'b001
`define IMM_SEL_B           3'b010
`define IMM_SEL_J           3'b011
`define IMM_SEL_U           3'b100

`define ALU_SEL_ADD         4'b0000
`define ALU_SEL_SUB         4'b0001
`define ALU_SEL_AND         4'b0010
`define ALU_SEL_OR          4'b0011
`define ALU_SEL_XOR         4'b0100
`define ALU_SEL_SLL         4'b0101
`define ALU_SEL_SRL         4'b0110
`define ALU_SEL_SRA         4'b0111
`define ALU_SEL_SLT         4'b1000
`define ALU_SEL_SLTU        4'b1001
`define ALU_SEL_A           4'b1010
`define ALU_SEL_B           4'b1011

`define MEM_READ            1'b0
`define MEM_WRITE           1'b1

`define LOAD_SEL_B          3'b000
`define LOAD_SEL_BU         3'b001
`define LOAD_SEL_H          3'b010
`define LOAD_SEL_HU         3'b011
`define LOAD_SEL_W          3'b100

`define STORE_SEL_B         2'b00
`define STORE_SEL_H         2'b01
`define STORE_SEL_W         2'b10

`define WB_SEL_MEM          2'b00
`define WB_SEL_ALU          2'b01
`define WB_SEL_PC4          2'b10

//===== Instruction fields =====

`define OP_R                7'b011_0011
`define OP_I_ALU            7'b001_0011
`define OP_I_JALR           7'b110_0111
`define OP_I_LOAD           7'b000_0011
`define OP_I_FENCE          7'b000_1111
`define OP_I_SYSTEM         7'b111_0011
`define OP_S                7'b010_0011
`define OP_B                7'b110_0011
`define OP_U_AUIPC          7'b001_0111
`define OP_U_LUI            7'b011_0111
`define OP_J                7'b110_1111

`define FUNCT3_ADD          3'b000          // add, addi
`define FUNCT3_SUB          3'b000          // sub
`define FUNCT3_AND          3'b111          // and, andi
`define FUNCT3_OR           3'b110          // or, ori
`define FUNCT3_XOR          3'b100          // xor, xori
`define FUNCT3_SLL          3'b001          // sll, slli
`define FUNCT3_SRL          3'b101          // srl, srli
`define FUNCT3_SRA          3'b101          // sra, srai
`define FUNCT3_SLT          3'b010          // slt, slti
`define FUNCT3_SLTU         3'b011          // sltu, sltui

`define FUNCT7_ADD          7'b000_0000     // add
`define FUNCT7_SUB          7'b010_0000     // sub
`define FUNCT7_AND          7'b000_0000     // and
`define FUNCT7_OR           7'b000_0000     // or
`define FUNCT7_XOR          7'b000_0000     // xor
`define FUNCT7_SLL          7'b000_0000     // sll, slli
`define FUNCT7_SRL          7'b000_0000     // srl, srli
`define FUNCT7_SRA          7'b010_0000     // sra, srai
`define FUNCT7_SLT          7'b000_0000     // slt
`define FUNCT7_SLTU         7'b000_0000     // sltu

`define FUNCT3_LB           3'b000
`define FUNCT3_LBU          3'b100
`define FUNCT3_LH           3'b001
`define FUNCT3_LHU          3'b101
`define FUNCT3_LW           3'b010

`define FUNCT3_SB           3'b000
`define FUNCT3_SH           3'b001
`define FUNCT3_SW           3'b010

`define FUNCT3_BEQ          3'b000
`define FUNCT3_BNE          3'b001
`define FUNCT3_BLT          3'b100
`define FUNCT3_BGE          3'b101
`define FUNCT3_BLTU         3'b110
`define FUNCT3_BGEU         3'b111
