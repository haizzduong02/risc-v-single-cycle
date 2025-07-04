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
    localparam MEM_NWORD = MEM_NBYTE / 4;
    reg [31:0] memory [0:MEM_NWORD-1];
    wire [31:2] word_addr = addr[31:2];
    wire [1:0]  byte_offset = addr[1:0];
    integer i;
    
    // Combinational read
    always @(*) begin
        case (load_sel)
            `LOAD_SEL_B: begin
                case (byte_offset)
                    2'b00: dataR = {{24{memory[word_addr][7]}},  memory[word_addr][7:0]};
                    2'b01: dataR = {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
                    2'b10: dataR = {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
                    2'b11: dataR = {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
                endcase
            end
            `LOAD_SEL_BU: begin
                case (byte_offset)
                    2'b00: dataR = {24'b0, memory[word_addr][7:0]};
                    2'b01: dataR = {24'b0, memory[word_addr][15:8]};
                    2'b10: dataR = {24'b0, memory[word_addr][23:16]};
                    2'b11: dataR = {24'b0, memory[word_addr][31:24]};
                endcase
            end
            `LOAD_SEL_H: begin
                case (byte_offset)
                    2'b00: dataR = {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
                    2'b10: dataR = {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
                    default: dataR = 32'b0;
                endcase
            end
            `LOAD_SEL_HU: begin
                case (byte_offset)
                    2'b00: dataR = {16'b0, memory[word_addr][15:0]};
                    2'b10: dataR = {16'b0, memory[word_addr][31:16]};
                    default: dataR = 32'b0;
                endcase
            end
            `LOAD_SEL_W: 
                dataR = memory[word_addr];
            default: 
                dataR = 32'b0;
        endcase
    end

    // Synchronous write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_NWORD; i = i + 1)
                memory[i] <= 32'b0;
        end else if (wr_en == `MEM_WRITE) begin
            case (store_sel)
                `STORE_SEL_B: begin
                    case (byte_offset)
                        2'b00: memory[word_addr][7:0]   <= dataW[7:0];
                        2'b01: memory[word_addr][15:8]  <= dataW[7:0];
                        2'b10: memory[word_addr][23:16] <= dataW[7:0];
                        2'b11: memory[word_addr][31:24] <= dataW[7:0];
                    endcase
                end
                `STORE_SEL_H: begin
                    case (byte_offset)
                        2'b00: memory[word_addr][15:0] <= dataW[15:0];
                        2'b10: memory[word_addr][31:16] <= dataW[15:0];
                        default: ; 
                    endcase
                end
                `STORE_SEL_W: 
                    memory[word_addr] <= dataW;
                default: ;
            endcase
        end
    end
endmodule