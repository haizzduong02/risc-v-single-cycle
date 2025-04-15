module inst_mem (
    inst,

    addr
);
    output  reg [31:0]  inst    ;
    input       [31:0]  addr    ;
    input               rst     ;

    reg [31:0] imem [0:1023];

    initial begin
        $readmemh("program.hex", imem);
    end

    always @* begin
        inst = imem[addr];
    end

endmodule