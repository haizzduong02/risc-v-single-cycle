module IMEM #(
    parameter MEM_NBYTE = 4096
) (
    output  reg [31:0]  inst,

    input       [31:0]  addr
);
    logic [7:0] memory [0:MEM_NBYTE-1];

    always @(*) begin
        inst = {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};
    end

    // initial begin
    //     {memory[3], memory[2], memory[1], memory[0]} =      32'b000000000000_00000_000_00001_0010011;  // addi x1, x0, 0
    //     {memory[7], memory[6], memory[5], memory[4]} =      32'b000000000101_00000_000_00010_0010011;  // addi x2, x0, 5
    //     {memory[11], memory[10], memory[9], memory[8]} =    32'b000000000001_00001_000_00001_0010011;  // addi x1, x1, 1
    //     {memory[15], memory[14], memory[13], memory[12]} =  32'b1111111_00010_00001_100_11101_1100011; // blt x1, x2, -4   1111111111100
    //     {memory[19], memory[18], memory[17], memory[16]} =  32'b000000000000_00000_000_00000_1101111;  // j 16
    // end
endmodule