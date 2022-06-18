module alarm_clock(clk, clk_min, clk_hr, addhr, addmin, rst, on, alarm_op, hr, min);
    input clk, rst, addhr, addmin, on;
    input[7:0] clk_hr, clk_min;
    output reg alarm_op;
    output reg [7:0] hr, min;
    always@(posedge clk) begin
        if (rst) begin
            hr <= 0;
            min <= 0;
            alarm_op <= 0;
        end
        else begin
            if (addhr) begin
                if(hr[3:0] == 4'd9) begin
                    hr[7:4] <= hr[7:4]+1;
                    hr[3:0] <= 0;
                end
                else
                    hr[3:0] <= hr[3:0]+1;
            end
            else if (addmin) begin
                if(min[3:0] == 4'd9) begin
                    min[7:4] <= min[7:4]+1'd1;
                    min[3:0] <= 0;
                    if(min[7:4] == 4'd5) begin
                        hr[3:0] <= hr[3:0]+1;
                        min[7:4] <= 0;
                        if(hr[3:0] == 4'd9) begin
                            hr[7:4] <= hr[7:4]+1;
                            hr[3:0] <= 0;
                        end
                    end
                end
                else
                    min[3:0] <= min[3:0]+1'd1;
            end
        end
        if (clk_hr == hr && clk_min == min) begin
            if (on)
                alarm_op <= 1;
        end
        else if (clk_hr == hr && clk_min == (min+1)) begin
            if (on)
                alarm_op <= 0;
        end
    end
endmodule
