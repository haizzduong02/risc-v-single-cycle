module BranchComp (
    output  reg         br_lt,
    output  reg         br_eq,

    input       [31:0]  rs1,
    input       [31:0]  rs2,
    input               br_un
);
    always @(*) begin
        br_eq = (rs1 == rs2);
        br_lt = (br_un) ? (rs1 < rs2) : ($signed(rs1) < $signed(rs2));
    end
endmodule