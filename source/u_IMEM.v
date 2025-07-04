module IMEM #(
    parameter MEM_NBYTE = 4096
) (
    output  reg [31:0]  inst,
    input       [31:0]  addr
);
    // Byte-addressed memory
    reg [7:0] memory_raw [0:MEM_NBYTE-1];

    // Word-accessible view for testbench
    wire [31:0] memory [0:(MEM_NBYTE/4)-1];

    // Tạo word từ 4 byte (little endian)
    genvar i;
    generate
        for (i = 0; i < MEM_NBYTE/4; i = i + 1) begin : gen_word
            assign memory[i] = {
                memory_raw[i*4 + 3],
                memory_raw[i*4 + 2],
                memory_raw[i*4 + 1],
                memory_raw[i*4 + 0]
            };
        end
    endgenerate

    // Đọc instruction
    always @(*) begin
        inst = {memory_raw[addr+3], memory_raw[addr+2], memory_raw[addr+1], memory_raw[addr]};
    end
endmodule
