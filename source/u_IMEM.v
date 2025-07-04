module IMEM #(
    parameter MEM_NBYTE = 4096
) (
    output  reg [31:0]  inst,

    input       [31:0]  addr
);
    reg [7:0] memory [0:MEM_NBYTE-1];

    always @(*) begin
        inst = {imem[addr+3], imem[addr+2], imem[addr+1], imem[addr]};
    end

    // initial begin
    //     {imem[3], imem[2], imem[1], imem[0]} =      32'b000000000000_00000_000_00001_0010011;  // addi x1, x0, 0
    //     {imem[7], imem[6], imem[5], imem[4]} =      32'b000000000101_00000_000_00010_0010011;  // addi x2, x0, 5
    //     {imem[11], imem[10], imem[9], imem[8]} =    32'b000000000001_00001_000_00001_0010011;  // addi x1, x1, 1
    //     {imem[15], imem[14], imem[13], imem[12]} =  32'b1111111_00010_00001_100_11101_1100011; // blt x1, x2, -4   1111111111100
    //     {imem[19], imem[18], imem[17], imem[16]} =  32'b000000000000_00000_000_00000_1101111;  // j 16
    // end
endmodule