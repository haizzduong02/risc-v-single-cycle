module single_cycle_riscv_processor (
    input       clk,
    input       rst_n
);
    wire pc_en = 1'b1;

    wire [31:0] pc_next, pc;
    wire [31:0] inst, imm;
    wire [31:0] rs1, rs2;
    wire [31:0] ALU_src_A, ALU_src_B;
    wire [31:0] ALU_result, mem_data, pc_4;
    wire [31:0] wb;

    wire PC_sel, B_sel, A_sel;
    wire [2:0] imm_sel;
    wire [3:0] ALU_sel;
    wire [1:0] wb_sel;
    wire [2:0] load_sel;
    wire [1:0] store_sel;
    wire reg_wr_en, br_un, mem_rw;
    wire br_lt, br_eq;


    PC PC_i (
        .pc         (pc),
        .pc_next    (pc_next),
        .clk        (clk),
        .en         (pc_en),
        .rst_n      (rst_n)
    );
    IMEM IMEM_inst (
        .inst       (inst),
        .addr       (pc)
    );
    ImmGen ImmGen_i (
        .imm        (imm),
        .inst       (inst),
        .imm_sel    (imm_sel)
    );
    RegFile RegFile_i (
        .dataA      (rs1),
        .dataB      (rs2),
        .dataD      (wb),
        .addrD      (inst[11:7]),
        .addrA      (inst[19:15]),
        .addrB      (inst[24:20]),
        .clk        (clk),
        .wr_en      (reg_wr_en),
        .rst_n      (rst_n)
    );
    mux_2x1 #(
        .DATA_WIDTH (32)
    ) mux_A (
        .dout       (ALU_src_A),
        .din_0      (rs1),
        .din_1      (pc),
        .sel        (A_sel)
    );
    mux_2x1 #(
        .DATA_WIDTH (32)
    ) mux_B (
        .dout       (ALU_src_B),
        .din_0      (rs2),
        .din_1      (imm),
        .sel        (B_sel)
    );
    BranchComp BranchComp_i (
        .br_eq      (br_eq),
        .br_lt      (br_lt),
        .rs1        (rs1),
        .rs2        (rs2),
        .br_un      (br_un)
    );
    ALU ALU_i (
        .result     (ALU_result),
        .srcA       (ALU_src_A),
        .srcB       (ALU_src_B),
        .ALU_sel    (ALU_sel)
    );

    DMEM DMEM_inst (
        .dataR      (mem_data),
        .memory     (dmemory),
        .addr       (ALU_result),
        .dataW      (rs2),
        .load_sel   (load_sel),
        .store_sel  (store_sel),
        .clk        (clk),
        .rst_n      (rst_n),
        .wr_en      (mem_rw)
    );
    mux_4x1 #(
        .DATA_WIDTH (32)
    ) mux_wb (
        .dout       (wb),
        .din_00     (mem_data),
        .din_01     (ALU_result),
        .din_10     (pc_4),
        .din_11     ({32{1'b0}}),
        .sel        (wb_sel)
    );
    adder #(
        .DATA_WIDTH (32)
    ) adder_pc (
        .dout       (pc_4),
        .din_a      (pc),
        .din_b      (4)
    );
    mux_2x1 #(
        .DATA_WIDTH (32)
    ) mux_pc (
        .dout       (pc_next),
        .din_0      (pc_4),
        .din_1      (ALU_result),
        .sel        (PC_sel)
    );
    ControlLogic ControlLogic_i (
        .PC_sel     (PC_sel),
        .imm_sel    (imm_sel),
        .reg_wr_en  (reg_wr_en),
        .B_sel      (B_sel),
        .A_sel      (A_sel),
        .ALU_sel    (ALU_sel),
        .mem_rw     (mem_rw),
        .load_sel   (load_sel),
        .store_sel  (store_sel),
        .wb_sel     (wb_sel),
        .br_un      (br_un),
        .br_eq      (br_eq),
        .br_lt      (br_lt),
        .inst       (inst)
    );
endmodule