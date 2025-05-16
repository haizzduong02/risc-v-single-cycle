module mux_2x1 #(
    parameter DATA_WIDTH = 32
) (
    output  reg [DATA_WIDTH-1:0]    dout,

    input       [DATA_WIDTH-1:0]    din_0,
    input       [DATA_WIDTH-1:0]    din_1,
    input                           sel
);
    always @(*) begin
        dout = (sel) ? din_1 : din_0;
    end
endmodule