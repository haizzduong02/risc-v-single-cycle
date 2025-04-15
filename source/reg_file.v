module reg_file (
    dataA,
    dataB,

    addrA,
    addrB,
    addrD,
    dataD,
    wr_en,
    clk,
    rst
);
    output  reg [31:0]  dataA   ;
    output  reg [31:0]  dataB   ;

    input       [4:0]   addrA   ;
    input       [4:0]   addrB   ;
    input       [4:0]   addrD   ;
    input       [31:0]  dataD   ;
    input               wr_en   ;
    input               clk     ;
    input               rst     ;


    reg [31:0] xreg [0:31];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                xreg[i] <= 32'b0;
            end
        end else begin
            if (wr_en != 1'b0 and addrD != 5'b0) begin
                xreg[addrD] <= dataD;
            end
        end
    end

    always @* begin
        dataA = (addrA == 5'b0) ? 32'b0 : xreg[addrA];
        dataB = (addrB == 5'b0) ? 32'b0 : xreg[addrB];
    end
endmodule