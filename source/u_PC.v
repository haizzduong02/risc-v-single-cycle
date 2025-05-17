module PC (
    output      [31:0]  pc,

    input       [31:0]  pc_next,
    input               clk,
    input               en,
    input               rst_n
);
    d_ff_arstn_en # (
        .DATA_WIDTH (32)
    ) PC (
        .dout       (pc),
        
        .din        (pc_next),
        .clk        (clk),
        .en         (en),
        .rst_n      (rst_n)
    );
endmodule
