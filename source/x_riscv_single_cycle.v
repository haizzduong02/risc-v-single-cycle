module riscv_single_cycle (
    clk,
    rst_n
);
    input   clk     ;
    input   rst_n   ;

    wire [31:0] pc, pc_next, pc_plus4;
    wire [31:0] inst;
    wire [31:0] dataA, dataB, dataD;
    wire [31:0] imm;
    wire [31:0] ALU_srcA, ALU_srcB, ALU_rs;
    wire [31:0] dataR;
    wire br_eq, br_lt;
    wire [3:0] ALU_sel;
    wire reg_wr_en;
    wire [2:0] imm_sel;
    wire selB;
    wire mem_rw;
    wire [1:0] selWB;
    wire selA;
    wire selPC;
    wire br_un;

    mux21_n # (
        .DLEN(32)
    ) muxPC (
        .dout   (pc),
        .din0   (pc_plus4),
        .din1   (ALU_rs),
        .sel    (selPC)
    );

    PC PC (
        .pc_next    (pc_next),

        .pc         (pc),
        .clk        (clk),
        .rst_n      (rst_n)
    );

    adder # (
        .DLEN(32)
    ) adderPC (
        .result (pc_plus4),
        .a      (pc_next),
        .b      ('d4)
    );

    IMEM IMEM (
        .inst   (inst),
        .addr   (pc_next)
    );

    RF RF (
        .dataA  (dataA),
        .dataB  (dataB),
        .dataD  (dataD),
        .addrD  (inst[11:7]),
        .addrA  (inst[19:15]),
        .addrB  (inst[24:20]),
        .wr_en  (reg_wr_en),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    branch_comp BC (
        .br_eq  (br_eq),
        .br_lt  (br_lt),

        .br_un  (br_un),
        .A      (dataA),
        .B      (dataB)
    );

    mux21_n # (
        .DLEN(32)
    ) muxA (
        .dout   (ALU_srcA),
        .din0   (dataA),
        .din1   (pc_next),
        .sel    (selA)
    );

    imm_gen IG (
        .imm    (imm),

        .inst   (inst),
        .imm_sel(imm_sel)
    );

    mux21_n # (
        .DLEN(32)
    ) muxB (
        .dout   (ALU_srcB),
        .din0   (dataB),
        .din1   (imm),
        .sel    (selB)
    );

    ALU ALU (
        .result     (ALU_rs),
        .srcA       (ALU_srcA),
        .srcB       (ALU_srcB),
        .ALU_sel    (ALU_sel)
    );

    DMEM DMEM (
        .dataR  (dataR),

        .addr   (ALU_rs),
        .dataW  (dataB),
        .mem_rw (mem_rw),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    mux41_n # (
        .DLEN(32)
    ) muxWB (
        .dout       (dataD),
        .din00      (dataR),
        .din01      (ALU_rs),
        .din10      (pc_plus4),
        .din11      (0),
        .sel        (selWB)
    );

    control_logic CL (
        .ALU_sel    (ALU_sel),
        .reg_wr_en  (reg_wr_en),
        .imm_sel    (imm_sel),
        .selB       (selB),
        .mem_rw     (mem_rw),
        .selWB      (selWB),
        .selA       (selA),
        .selPC      (selPC),
        .br_un      (br_un),

        .inst       (inst),
        .br_eq      (br_eq),
        .br_lt      (br_lt)
    );
endmodule