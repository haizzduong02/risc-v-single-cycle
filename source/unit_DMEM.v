`include "param.v"
module DMEM (
    dataR,

    addr,
    dataW,
    mem_rw,
    clk,
    rst_n
);
    output  reg [31:0]  dataR   ;
    input       [31:0]  addr    ;
    input       [31:0]  dataW   ;
    input               mem_rw  ;
    input               clk     ;
    input               rst_n   ;

    reg [31:0] dmem [0:1023];

    wire [9:0] mem_addr = addr[11:2];

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dmem[0] = 32'ha;
            for (i = 1; i < 1024; i = i + 1) begin
                dmem[i] <= 32'h0;
            end
        end else if (mem_rw == `MEM_WRITE) begin 
            dmem[mem_addr] <= dataW;
        end
    end

    always @(*) begin
        dataR = dmem[mem_addr];
    end
endmodule