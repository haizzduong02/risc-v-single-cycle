module branch_comp (
    br_eq,
    br_lt,
    
    br_un,
    A,
    B
);
    output  reg         br_eq   ;
    output  reg         br_lt   ;

    input       br_un           ;
    input       [31:0]  A       ;
    input       [31:0]  B       ;

    always @* begin
        br_eq = (A == B);
        br_lt = br_un ? (A < B) : ($signed(A) < $signed(B));
    end


endmodule