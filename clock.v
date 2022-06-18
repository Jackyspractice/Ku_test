module clock(clk, start, clr, sec, min, hr, addhr, addmin);
    input clk;
    input clr, start, addhr, addmin;
    output reg [23:0]sec;
    output reg [7:0]min, hr;

    always@(posedge clk) begin
        if (clr) begin
            sec <= 0;
            min <= 0;
            hr <= 0;
        end
        else begin
            if (start) begin
                if(sec[3:0] != 4'd9)
                    sec[3:0] <= sec[3:0]+1;
                else begin
                    sec[7:4] <= sec[7:4]+1'd1;
                    sec[3:0] <= 0;
                    if(sec[7:4] == 4'd9)begin
                        sec[11:8] <= sec[11:8]+1'd1;
                        sec[7:4] <= 0;
                        if(sec[11:8] == 4'd9)begin
                            sec[15:12] <= sec[15:12]+1'd1;
                            sec[11:8] <= 0;
                            if(sec[15:12] == 4'd9)begin
                                sec[19:16] <= sec[19:16]+1'd1;
                                sec[15:12] <= 0;
                                if(sec[19:16] == 4'd9)begin
                                    sec[23:20] <= sec[23:20]+1'd1;
                                    sec[19:16] <= 0;
                                    if(sec[23:20] == 4'd5) begin
                                        min[3:0] <= min[3:0]+1'd1;
                                        sec[23:20] <= 0;
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
                                    end
                                end
                            end
                        end
                    end
                end
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
        end
    end
endmodule
