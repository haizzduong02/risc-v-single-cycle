module mux_4x1 #(
    parameter DATA_WIDTH = 32
) (
    output  reg [DATA_WIDTH-1:0]    dout,

    input       [DATA_WIDTH-1:0]    din_00,
    input       [DATA_WIDTH-1:0]    din_01,
    input       [DATA_WIDTH-1:0]    din_10,
    input       [DATA_WIDTH-1:0]    din_11,
    input       [1:0]               sel
);
    always @(*) begin
        case (sel)
            2'b00:      dout = din_00;
            2'b01:      dout = din_01;
            2'b10:      dout = din_10;
            2'b11:      dout = din_11; 
            default:    dout = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule