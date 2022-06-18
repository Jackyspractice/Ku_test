module Seven_Seg_Scan(sel, scan);
    input [1:0]sel;
    output reg [3:0] scan;
    always@(sel[1:0])
     case(sel[1:0])
         2'b00:scan = 4'b1110;
         2'b01:scan = 4'b1101;
         2'b10:scan = 4'b1011;
         2'b11:scan = 4'b0111;
     endcase
endmodule

module selcontrol(clk, sel);
    input clk;
    output reg [1:0]sel;
    
    always@(posedge clk) begin
        begin
            sel <= 2'b00;
        end
         begin
            if (sel==2'b11) begin
                sel <= 2'b00; 
            end
            else begin
                sel <= sel+1'b01;
            end
        end
    end
endmodule