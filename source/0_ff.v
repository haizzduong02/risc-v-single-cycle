module ff_n #(
    parameter DLEN = 32
) (
    dout,

    din,
    clk,
    rst_n
);
    output  reg [DLEN-1:0]  dout    ;
    input       [DLEN-1:0]  din     ;
    input                   clk     ;
    input                   rst_n   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 0;
        end else begin
            dout <= din;
        end
    end
endmodule