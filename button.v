module button(clk, inp, op_long, op_short);

    input clk;
    input inp;
    output wire op_long, op_short;
    
    reg[20:0] n;
    
    reg delay1 = 0, delay2 = 0, delay3 = 0, dinp = 0, f, long, short;

    always @(posedge clk)
    begin
        if (inp)
            f <= 1;
        else 
            f <=0;
        delay1 <= inp;
        delay2 <= delay1;
        delay3 <= delay2;
        
        if (delay1 && delay2 && delay3)
            dinp <= 1;
        else
            dinp <= 0;
        
        if(dinp)
            n <= n + 1'b1;
        else
            n <= 0;
    end
    always @(negedge inp) begin
        if(f) begin
            if(n>20'hc00) begin
                long = 1;
                short = 0;
            end
            else begin
                long = 0;
                short = 1;
            end
        end
        else begin
            long = 0;
            short = 0;
        end
    end
    
    assign op_long = long & ~delay1 & delay2;
    assign op_short = short & ~delay1 & delay2;
    
endmodule
 