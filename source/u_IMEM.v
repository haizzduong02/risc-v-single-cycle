module IMEM #(
    parameter MEM_DEPTH = 256
) (
    output  reg [31:0]  inst,
    input       [31:0]  addr
);
    reg [31:0] memory [0:MEM_DEPTH-1];

    always @(*) begin
        inst = (addr[31:2] < MEM_DEPTH) ? memory[addr[31:2]] : 32'h00000013;
    end
endmodule