module Top(mclk, set, inc, sw, rst, led_op, scan, ag);
    input mclk, set, inc, sw, rst;
    output wire led_op;
    output [3:0] scan;
    output [6:0] ag;
    
    wire[1:0] sel;
    reg [3:0] x;
    wire[15:0] op;
    
    Clk c (clk1, dset, dlinc, dinc, dsw, drst, op, led_op);
    clkdiv cd (mclk, clk1, clk2, clk3);
    debouncer d1 (set, clk1, dset);
    
    debouncer d3 (sw, clk1, dsw);
    debouncer d4 (rst, clk1, drst);
    Seven_Seg_Scan sss (sel, scan);
    selcontrol sc (clk2, sel);
    led7seg ls (x, ag);
    button b (clk1, inc, dlinc, dinc);
    
    always@(sel[1:0]) begin
     case(sel[1:0])
         2'b00: x = op[3:0];
         2'b01: x = op[7:4];
         2'b10: x = op[11:8];
         2'b11: x = op[15:12];
     endcase
    end
    
endmodule
