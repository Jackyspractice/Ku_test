module FSM(clk, set, linc, inc, sw, rst, sw_clr, sw_start, clk_start, clock_addmin, clock_addhr, alarm_addhr, alarm_addmin, alarm_on, clk_mode, sw_mode, op_mode);
    input clk, set, linc, inc, sw, rst;
    
    output reg sw_clr, sw_start, clk_start, clock_addmin, clock_addhr, alarm_addhr, alarm_addmin, alarm_on;
    output reg [2:0] op_mode, sw_mode;
    output reg [1:0] clk_mode;
    
    parameter  Clock_hr_min = 0, Clock_min_sec = 1, Clock_set_hr = 2, Clock_set_min = 3, Alarm_clock = 4, Alarm_set_hr = 5, Alarm_set_min = 6, Stopwatch = 7, Stopwatch_start = 8, Stopwatch_stop = 9, Clock_addhr = 10, Clock_addmin = 11, Alarm_addhr = 12, Alarm_addmin = 13, Stopwatch_mode = 14, Alarm_on = 15, idle = 16;
    reg [4:0] State, StateNext;
    reg sw_mode_add;
    
    always @(posedge clk) begin
        if (rst) begin
            State <= idle;
            sw_mode = 0;
        end
        else
            State <= StateNext;
        if (sw_mode_add) begin
            if (sw_mode == 2)
                    sw_mode = 0;
                else 
                    sw_mode = sw_mode + 1;
        end
    end
    
    always @(*) begin
        case (State)
            idle:begin
                sw_start = 0;
                sw_clr = 1;
                clock_addmin = 0;
                clock_addhr = 0;
                alarm_addhr = 0;
                alarm_addmin = 0;
                alarm_on = 0;
                clk_mode = 0;
                sw_mode_add = 0;
                op_mode = 0;
                StateNext = Clock_hr_min;
            end
            Clock_hr_min: begin
                clk_start = 1;
                clk_mode = 0;
                op_mode = 0;
                if (inc && ~linc && ~set && ~sw)
                    StateNext = Clock_min_sec;
                else if (~inc && set && ~sw)
                    StateNext = Clock_set_hr;
                else if (linc && ~set && ~sw)
                    StateNext = Alarm_clock;
                else if (~inc && ~set && sw)
                    StateNext = Stopwatch;
                else
                    StateNext = Clock_hr_min;
            end
            Clock_min_sec: begin
                clk_start = 1;
                clk_mode = 1;
                op_mode = 0;
                if (inc && ~linc && ~set && ~sw) 
                    StateNext = Clock_hr_min;
                else if (~inc && set && ~sw)
                    StateNext = Clock_set_hr;
                else if (linc && ~set && ~sw)
                    StateNext = Alarm_clock;
                else if (~inc && ~set && sw)
                    StateNext = Stopwatch;
                else
                    StateNext = Clock_min_sec;
            end
            Clock_set_hr: begin
                clk_start = 0;
                clock_addhr = 0;
                clk_mode = 0;
                op_mode = 0;
                if (~inc && set && ~sw)
                    StateNext = Clock_set_min;
                else if (inc && ~set && ~sw)
                    StateNext = Clock_addhr;
                else 
                    StateNext = Clock_set_hr;
            end
            Clock_set_min: begin
                clk_start = 0;
                clock_addmin = 0;
                clk_mode = 0;
                op_mode = 0;
                if (~inc && set && ~sw)
                    StateNext = Clock_hr_min;
                else if (inc && ~set && ~sw)
                    StateNext = Clock_addmin;
                else
                    StateNext = Clock_set_min;
            end
            Alarm_clock: begin
                alarm_on = 0;
                op_mode = 1;
                StateNext = Alarm_set_hr;
            end
            Alarm_set_hr: begin
                alarm_addhr = 0;
                op_mode = 1;
                if (inc && ~set && ~sw)
                    StateNext = Alarm_addhr;
                else if (~inc && set && ~sw)
                    StateNext = Alarm_set_min;
                else 
                    StateNext = Alarm_set_hr;
            end
            Alarm_set_min: begin
                alarm_addmin = 0;
                op_mode = 1;
                if (inc && ~set && ~sw)
                    StateNext = Alarm_addmin;
                else if (~inc && set && ~sw)
                    StateNext = Alarm_on;
                else
                    StateNext = Alarm_set_min;
            end
            Alarm_on: begin
                alarm_on = 1;
                op_mode = 1;
                StateNext = Clock_hr_min;
            end
            Stopwatch: begin
                sw_mode_add = 0;
                sw_start = 0;
                sw_clr = 1;
                op_mode = 2;
                if (~inc && ~set && sw)
                    StateNext = Stopwatch_start;
                else if (~inc && set && ~sw)
                    StateNext = Clock_hr_min;
                else if (inc && ~set && ~sw)
                    StateNext = Stopwatch_mode;
                else 
                    StateNext = Stopwatch;
            end
            Stopwatch_start: begin
                sw_start = 1;
                sw_clr = 0;
                op_mode = 2;
                if (inc && ~set && ~sw)
                    StateNext = Stopwatch;
                else if (~inc && ~set && sw)
                    StateNext = Stopwatch_stop;
                else 
                    StateNext = Stopwatch_start;
            end
            Stopwatch_stop: begin
                sw_start = 0;
                sw_clr = 0;
                op_mode = 2;
                if (inc && ~set && ~sw)
                    StateNext = Stopwatch;
                else if (~inc && ~set && sw)
                    StateNext = Stopwatch_start;
                else
                    StateNext = Stopwatch_stop;
            end
            Stopwatch_mode: begin
                sw_mode_add = 1;
                StateNext = Stopwatch;
            end
            Clock_addhr: begin
                clock_addhr = 1;
                StateNext = Clock_set_hr;
            end
            Clock_addmin: begin
                clock_addmin = 1;
                StateNext = Clock_set_min;
            end
            Alarm_addhr: begin
                alarm_addhr = 1;
                StateNext = Alarm_set_hr;
            end
            Alarm_addmin: begin
                alarm_addmin = 1;
                StateNext = Alarm_set_min;
            end
        endcase
    end
endmodule
