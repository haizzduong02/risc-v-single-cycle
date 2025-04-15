module mux41_n #(
    parameter DLEN = 32;
) (
    dout,

    din00,
    din01,
    din10,
    din11,
    sel
);
    output  reg [DLEN-1:0]  dout    ;
    
    input       [DLEN-1:0]  din00   ;
    input       [DLEN-1:0]  din01   ;
    input       [DLEN-1:0]  din10   ;
    input       [DLEN-1:0]  din11   ;
    input       [1:0]       sel     ;

    always @* begin
        case (sel)
            2'b00:  dout = din00;
            2'b01:  dout = din01;
            2'b10:  dout = din10;
            2'b11:  dout = din11; 
            default: dout = 2'b00;
        endcase
    end
endmodule