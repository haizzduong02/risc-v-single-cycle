module DMEM #(
    parameter           MEM_DEPTH = 256
) (
    output  reg [31:0]  dataR,
    
    input       [31:0]  addr,
    input       [31:0]  dataW,
    input       [ 2:0]  load_sel,
    input       [ 1:0]  store_sel,
    input               clk,
    input               rst_n,
    input               wr_en
);
    `include "0_macro.v"
    
    reg [31:0] memory [0:MEM_DEPTH-1];
    reg [31:0] data;
    integer i;
    
    always @(*) begin
        data = (addr[31:2] < MEM_DEPTH) ? memory[addr[31:2]] : {32{1'b0}};
        case (load_sel)
            `LOAD_SEL_B:    dataR = {{24{data[7]}},    data[7:0]};
            `LOAD_SEL_BU:   dataR = {{24{1'b0}},       data[7:0]};
            `LOAD_SEL_H:    dataR = {{16{data[15]}},   data[15:0]};
            `LOAD_SEL_HU:   dataR = {{16{1'b0}},       data[15:0]};
            `LOAD_SEL_W:    dataR = data;
            default:        dataR = data;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                memory[i] <= {32{1'b0}};
            end
        end else if (wr_en == `MEM_WRITE) begin
            if (addr[31:2] < MEM_DEPTH) begin
                case (store_sel)
                    `STORE_SEL_B: begin
                        case (addr[1:0])
                            2'b00: memory[addr[31:2]][7:0]   <= dataW[7:0];
                            2'b01: memory[addr[31:2]][15:8]  <= dataW[7:0];
                            2'b10: memory[addr[31:2]][23:16] <= dataW[7:0];
                            2'b11: memory[addr[31:2]][31:24] <= dataW[7:0];
                        endcase
                    end
                    `STORE_SEL_H: begin
                        case (addr[1:0])
                            2'b00: memory[addr[31:2]][15:0]  <= dataW[15:0];
                            2'b10: memory[addr[31:2]][31:16] <= dataW[15:0];
                            default: ; 
                        endcase
                    end
                    `STORE_SEL_W: begin
                        memory[addr[31:2]] <= dataW;
                    end
                    default: ;
                endcase
            end
        end
    end
endmodule