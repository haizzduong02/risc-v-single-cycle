module DMEM #(
    parameter           MEM_DEPTH = 256
) (
    output  reg [31:0]  data_r,
    
    input       [31:0]  addr,
    input       [31:0]  data_w,
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
            `LOAD_SEL_B:    data_r = {{24{data[7]}},    data[7:0]};
            `LOAD_SEL_BU:   data_r = {{24{1'b0}},       data[7:0]};
            `LOAD_SEL_H:    data_r = {{16{data[15]}},   data[15:0]};
            `LOAD_SEL_HU:   data_r = {{16{1'b0}},       data[15:0]};
            `LOAD_SEL_W:    data_r = data;
            default:        data_r = data;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                memory[i] <= {32{1'b0}};
            end
        end else begin
            if (wr_en == `MEM_WRITE) begin
                case (store_sel)
                    `STORE_SEL_B:   memory[addr[31:2]][7:0]     <= data_w[7:0];
                    `STORE_SEL_H:   memory[addr[31:2]][15:0]    <= data_w[15:0];
                    `STORE_SEL_W:   memory[addr[31:2]]          <= data_w;
                    default:        ;
                endcase
            end
        end
    end
endmodule