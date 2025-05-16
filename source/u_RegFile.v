module RegFile (
    output  reg [31:0]  dataA,
    output  reg [31:0]  dataB,

    input       [31:0]  dataD,
    input       [4:0]   addrD,
    input       [4:0]   addrA,
    input       [4:0]   addrB,
    input               clk,
    input               wr_en,
    input               rst_n
);
    reg [31:0] xreg [0:31];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                xreg[i] <= {32{1'b0}};
            end
        end else begin
            if (wr_en && addrD != 0) begin
                xreg[addrD] <= dataD;
            end
        end
    end
    
    always @(*) begin
        dataA = (addrA) ? xreg[addrA] : {32{1'b0}};
        dataB = (addrB) ? xreg[addrB] : {32{1'b0}};
    end
endmodule