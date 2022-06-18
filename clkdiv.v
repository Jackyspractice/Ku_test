module clkdiv(mclk, clk1, clk2, clk3);
    input mclk;
    output clk1, clk2, clk3;


    reg [30:0] q = 0 ;

    always @(posedge mclk)
    begin
        q <= q + 1'b1;
    end
    assign clk1 = q[1];
    assign clk2 = q[17];
	assign clk3 = q[22];
endmodule 
