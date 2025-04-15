module ff_n #(
    parameter DLEN = 32;
) (
    dout,

    din,
    clk,
    rst
);
    output  reg [DLEN-1:0]  dout    ;
    input       [DLEN-1:0]  din     ;
    input                   clk     ;
    input                   rst     ;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            dout <= 0;
        end else begin
            dout <= din;
        end
    end
endmodule