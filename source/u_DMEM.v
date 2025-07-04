`include "0_macro.v"

module DMEM #(
    parameter MEM_NBYTE = 1024
) (
    output  reg [31:0]  dataR,

    input       [31:0]  addr,
    input       [31:0]  dataW,
    input       [2:0]   load_sel,
    input       [1:0]   store_sel,
    input               clk,
    input               wr_en,
    input               rst_n
);
    // Byte-addressed memory
    reg [7:0] memory_raw [0:MEM_NBYTE-1];

    // Word-view memory (to support testbench access like memory[addr >> 2])
    wire [31:0] memory [0:(MEM_NBYTE/4)-1];

    // Reconstruct 32-bit word view for read
    genvar i;
    generate
        for (i = 0; i < MEM_NBYTE/4; i = i + 1) begin : gen_word_view
            assign memory[i] = {
                memory_raw[i*4 + 3],
                memory_raw[i*4 + 2],
                memory_raw[i*4 + 1],
                memory_raw[i*4 + 0]
            };
        end
    endgenerate

    // Read path (byte-based)
    always @(*) begin
        case (load_sel)
            `LOAD_SEL_B:  dataR = {{24{memory_raw[addr][7]}}, memory_raw[addr]};
            `LOAD_SEL_BU: dataR = {{24{1'b0}}, memory_raw[addr]};
            `LOAD_SEL_H:  dataR = {{16{memory_raw[addr+1][7]}}, memory_raw[addr+1], memory_raw[addr]};
            `LOAD_SEL_HU: dataR = {{16{1'b0}}, memory_raw[addr+1], memory_raw[addr]};
            `LOAD_SEL_W:  dataR = {memory_raw[addr+3], memory_raw[addr+2], memory_raw[addr+1], memory_raw[addr]};
            default:      dataR = 32'b0;
        endcase
    end

    // Write path
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < MEM_NBYTE; j = j + 1) begin
                memory_raw[j] <= 8'b0;
            end
        end else if (wr_en == `MEM_WRITE) begin
            case (store_sel)
                `STORE_SEL_B: memory_raw[addr] <= dataW[7:0];
                `STORE_SEL_H: begin
                    memory_raw[addr]     <= dataW[7:0];
                    memory_raw[addr+1]   <= dataW[15:8];
                end
                `STORE_SEL_W: begin
                    memory_raw[addr]     <= dataW[7:0];
                    memory_raw[addr+1]   <= dataW[15:8];
                    memory_raw[addr+2]   <= dataW[23:16];
                    memory_raw[addr+3]   <= dataW[31:24];
                end
                default: ;
            endcase
        end
    end
endmodule
