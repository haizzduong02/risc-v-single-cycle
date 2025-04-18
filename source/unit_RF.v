module RF (
    dataA,
    dataB,

    dataD,
    addrD,
    addrA,
    addrB,
    wr_en,
    clk,
    rst_n
);
    output  reg [31:0]  dataA   ;
    output  reg [31:0]  dataB   ;

    input       [4:0]   addrA   ;
    input       [4:0]   addrB   ;
    input       [4:0]   addrD   ;
    input       [31:0]  dataD   ;
    input               wr_en   ;
    input               clk     ;
    input               rst_n   ;


    reg [31:0] xreg [0:31];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            for (i = 0; i < 32; i = i + 1) begin
                xreg[i] <= 32'b0;
            end
        end else begin
            if (wr_en != 1'b0 && addrD != 5'b0) begin
                xreg[addrD] <= dataD;
            end
        end
    end

    always @* begin
        dataA = (addrA == 5'b0) ? 32'b0 : xreg[addrA];
        dataB = (addrB == 5'b0) ? 32'b0 : xreg[addrB];
    end
endmodule