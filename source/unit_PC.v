module PC (
    pc_next,

    pc,
    clk,
    rst_n
);
    output      [31:0]  pc_next ;

    input       [31:0]  pc      ;
    input               clk     ;
    input               rst_n   ;

    ff_n # (
        .DLEN(32)
    ) PC_ff (
        .dout   (pc_next)   ,

        .din    (pc)        ,
        .clk    (clk)       ,
        .rst_n  (rst_n)
    );
endmodule