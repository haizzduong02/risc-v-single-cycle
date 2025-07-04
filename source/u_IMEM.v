module IMEM #(
    parameter MEM_NBYTE = 4096
) (
    output  reg [31:0]  inst,
    input       [31:0]  addr
);
    reg [7:0] memory [0:MEM_NBYTE-1];

    always @(*) begin
        inst = {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};
    end
endmodule