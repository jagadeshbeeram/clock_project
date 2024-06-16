module clock_divider(
input clk,
output reg clkout );
reg [25:0] count;
    always @(negedge clk)
        begin
        count <=count + 1;
            if (count == 50000000)
            begin
            clkout <= !clkout;//change of state of clock after every 0.5 sec
            count <= 0;
            end
        end
endmodule