module IMEM (
    output reg [31:0] inst,
    input [31:0] addr
);
    // Define instruction memory: 1024 entries of 32-bit words (4KB total)
    reg [31:0] imem [0:1023];

    // Word-aligned address: addr / 4
    wire [9:0] mem_addr = addr[11:2];

    // Read instruction (combinational)
    always @(*) begin
        inst = imem[mem_addr];
    end

    // Initialize memory with program
    integer i;
    initial begin
        imem[0]  = 32'h00000000; // NOP
        imem[1]  = 32'h019986B3; // add x13, x16, x25
        imem[2]  = 32'h407402B3; // sub x5, x8, x7
        imem[3]  = 32'h002180F3; // and x1, x2, x3
        imem[4]  = 32'h00518233; // or x4, x3, x5
        imem[5]  = 32'h003A8B13; // addi x22, x21, 3
        imem[6]  = 32'h00140493; // ori x9, x8, 1
        imem[7]  = 32'h00F2A423; // lw x8, 15(x5)
        imem[8]  = 32'h00319483; // lw x9, 3(x3)
        imem[9]  = 32'h00F2A623; // sw x15, 12(x5)
        imem[10] = 32'h00E32723; // sw x14, 10(x6)
        imem[11] = 32'h00948663; // beq x9, x9, 12

        // Fill remaining memory with NOPs
        
        for (i = 12; i < 1024; i = i + 1) begin
            imem[i] = 32'h00000000; // NOP
        end
    end
endmodule