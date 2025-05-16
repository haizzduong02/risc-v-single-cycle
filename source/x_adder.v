module adder #(
    parameter DATA_WIDTH = 32
) (
    output  reg [DATA_WIDTH-1:0]    dout,

    input       [DATA_WIDTH-1:0]    din_a,
    input       [DATA_WIDTH-1:0]    din_b
);
    always @(*) begin
        dout = din_a + din_b;
    end
endmodule