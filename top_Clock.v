module Clk(clk, set, linc, inc, sw, rst, op, led_op);
    input clk, set, linc, inc, sw, rst;
    output wire led_op;
    output reg [15:0]op;
    wire [2:0] op_mode, sw_mode;
    wire [1:0] clk_mode, sel;
    wire [7:0] clk_min, clk_hr, alarm_hr, alarm_min;
    wire [23:0] clk_sec, sw_sec;
    reg [15:0] clk_op, sw_op, alarm_op;
    FSM f1 (clk, set, linc, inc, sw, rst, sw_clr, sw_start, clk_start, clock_addmin, clock_addhr, alarm_addhr, alarm_addmin, alarm_on, clk_mode, sw_mode, op_mode);
    clock c1 (clk, clk_start, rst, clk_sec, clk_min, clk_hr, clock_addhr, clock_addmin);
    alarm_clock a1 (clk, clk_min, clk_hr, alarm_addhr, alarm_addmin, rst, alarm_on, led_op, alarm_hr, alarm_min);
    stopwatch s1 (clk, sw_start, sw_clr, sw_sec, sw_min, sw_hr);
    
    always@(*) begin
        alarm_op[3:0] <= alarm_min[3:0];
        alarm_op[7:4] <= alarm_min[7:4];
        alarm_op[11:8] <= alarm_hr[3:0];
        alarm_op[15:12] <= alarm_hr[7:4];
        case(clk_mode) 
            0:begin
                clk_op[3:0] <= clk_min[3:0];
                clk_op[7:4] <= clk_min[7:4];
                clk_op[11:8] <= clk_hr[3:0];
                clk_op[15:12] <= clk_hr[7:4];
            end
            1:begin
                clk_op[3:0] <= clk_sec[19:16];
                clk_op[7:4] <= clk_sec[23:20];
                clk_op[11:8] <= clk_min[3:0];
                clk_op[15:12] <= clk_min[7:4];
            end
        endcase
        case(sw_mode) 
            0:begin
                sw_op[3:0] <= sw_sec[11:8];
                sw_op[7:4] <= sw_sec[15:12];
                sw_op[11:8] <= sw_sec[19:16];
                sw_op[15:12] <= sw_sec[23:20];
            end
            1:begin
                sw_op[3:0] <= sw_sec[7:4];
                sw_op[7:4] <= sw_sec[11:8];
                sw_op[11:8] <= sw_sec[15:12];
                sw_op[15:12] <= sw_sec[19:16];
            end
            2:begin
                sw_op[3:0] <= sw_sec[3:0];
                sw_op[7:4] <= sw_sec[7:4];
                sw_op[11:8] <= sw_sec[11:8];
                sw_op[15:12] <= sw_sec[15:12];
            end
        endcase
        case(op_mode)
            0: op <= clk_op;
            1: op <= alarm_op;
            2: op <= sw_op;
        endcase
    end
endmodule
