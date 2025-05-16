module d_ff_arstn_en #(
    parameter DATA_WIDTH = 32
) (
    output  reg [DATA_WIDTH-1:0]    dout,

    input       [DATA_WIDTH-1:0]    din,
    input                           clk,
    input                           en,
    input                           rst_n
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= {DATA_WIDTH{1'b0}};
        end else begin
            if (en) begin
                dout <= din;
            end
        end
    end
endmodule