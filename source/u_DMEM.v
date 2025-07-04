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
    logic [7:0] memory [0:MEM_NBYTE-1];
    integer i;
    
    always @(*) begin
        case (load_sel)
            `LOAD_SEL_B:    dataR = {{24{memory[addr][7]}}, memory[addr]};
            `LOAD_SEL_BU:   dataR = {{24{1'b0}}, memory[addr]};
            `LOAD_SEL_H:    dataR = {{16{memory[addr+1][7]}}, memory[addr+1], memory[addr]};
            `LOAD_SEL_HU:   dataR = {{16{1'b0}}, memory[addr+1], memory[addr]};
            `LOAD_SEL_W:    dataR = {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};
            default:        dataR = {32{1'b0}};
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_NBYTE; i = i + 1) begin
                memory[i] <= {8{1'b0}};
            end
        end else begin
            if (wr_en == `MEM_WRITE) begin
                case (store_sel)
                    `STORE_SEL_B:   memory[addr] <= dataW[7:0];
                    `STORE_SEL_H:   {memory[addr+1], memory[addr]} <= dataW[15:0];
                    `STORE_SEL_W:   {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]} <= dataW[31:0];
                    default:        ;
                endcase
            end
        end
    end
endmodule