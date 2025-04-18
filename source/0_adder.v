module adder #(
    parameter DLEN = 32
) (
    result,

    a,
    b
);
    output  reg [DLEN-1:0]  result;

    input       [DLEN-1:0]  a;
    input       [DLEN-1:0]  b;

    always @* begin
        result = a + b;
    end
endmodule