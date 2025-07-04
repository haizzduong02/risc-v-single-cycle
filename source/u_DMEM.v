`include "0_macro.v"

module DMEM #(
    parameter MEM_NBYTE = 1024
) (
    output  reg [31:0]  dataR,
    output  reg [ 7:0]  memory  [0:MEM_NBYTE-1],
    
    input       [31:0]  addr,
    input       [31:0]  dataW,
    input       [2:0]   load_sel,
    input       [1:0]   store_sel,
    input               clk,
    input               wr_en,
    input               rst_n
);
    reg [7:0] dmem [0:MEM_NBYTE-1];
    integer i;
    
    always @(*) begin
        case (load_sel)
            `LOAD_SEL_B:    dataR = {{24{dmem[addr][7]}}, dmem[addr]};
            `LOAD_SEL_BU:   dataR = {{24{1'b0}}, dmem[addr]};
            `LOAD_SEL_H:    dataR = {{16{dmem[addr+1][7]}}, dmem[addr+1], dmem[addr]};
            `LOAD_SEL_HU:   dataR = {{16{1'b0}}, dmem[addr+1], dmem[addr]};
            `LOAD_SEL_W:    dataR = {dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
            default:        dataR = {32{1'b0}};
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_NBYTE; i = i + 1) begin
                dmem[i] <= {8{1'b0}};
            end
        end else begin
            if (wr_en == `MEM_WRITE) begin
                case (store_sel)
                    `STORE_SEL_B:   dmem[addr] <= dataW[7:0];
                    `STORE_SEL_H:   {dmem[addr+1], dmem[addr]} <= dataW[15:0];
                    `STORE_SEL_W:   {dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]} <= dataW[31:0];
                    default:        ;
                endcase
            end
        end
    end
endmodule