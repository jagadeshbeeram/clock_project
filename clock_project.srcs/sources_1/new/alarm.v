`timescale 1ns / 1ps

module alarm(
input load,
input clk,clksec,
input digit,
input [5:0]min,
input [4:0]hr,
input [5:0]q,
output reg alarm_led,
output [6:0]seg,
output reg [3:0]an
    );
    reg [5:0]min1 = 0;
//    reg [3:0]min2 = 0;
//    reg [3:0]hr2 = 0;
    reg [4:0]hr1 = 0;
    reg digitval = 0;
    reg [3:0]val = 0;
    reg alarm_on=0;
    wire [1:0]ref;
    
    
    // taking input from the user for alarm
    always@(posedge digit)
        digitval = ~digitval;
    
    always@(q)
    begin
        if(load)
            begin
                if(!digitval)
                    begin
                        if(q>23)
                            hr1 = 23;
                        else
                            hr1 = q;    
                    end
                else
                    begin
                        if(q>59)
                            min1 = 59;
                        else
                            min1 = q;
                    end
            end
    end
    
//    always@(q)
//    begin
//    if (load==1)
//        case(digitval)
//            3'b000:
//                begin
//                    if (q > 2)
//                    begin
//                        hr2 = 2;
//                        if (hr1>3)
//                            hr1 = 3;
//                    end
//                    else
//                    hr2 = q;
//                end
//            3'b001:
//                begin
//                    if(hr2==2 && q>3)
//                        hr1 = 3;
//                    else if (q > 9)
//                    hr1 = 9;
//                    else
//                    hr1 = q;
//                end
//            3'b010:
//                begin
//                    if (q > 5)
//                    min2 = 5;
//                    else
//                    min2 = q;
//                end
//            3'b011:
//                begin
//                    if (q > 9)
//                    min1 = 9;
//                    else
//                    min1 = q;
//                end
//        endcase
//    end
    
// checking whether the alaram time matches with clock time
always@(*)
begin
    if(min== min1 && hr == hr1)
        alarm_on = 1;
    else
        alarm_on = 0;
    if (alarm_on && clksec)
        alarm_led=1;
    else 
        alarm_led = 0;
end

//assign alarm_on = (min==(min2*10 + min1)&& hr==(hr2*10+hr1))?1:0;

//assign alarm_led = (alarm_on && clksec)?1:0; 
    
    
 refresh s1(.clk(clk),.LED_activating_counter(ref));
    always @(*)
begin
     case(ref)
     2'b00: 
         begin
         an = 4'b1110; // "0"  
         val = min1%10;
         end
     2'b01:
         begin
         an = 4'b1101;
         val = min1/10;
         end 
     2'b10:
         begin an = 4'b1011;
         val = hr1%10; // "2" 
         end
     2'b11:
         begin
         an = 4'b0111; // "3"
         val = hr1/10;
         end 
     endcase
 end
  segment s10(.val(val),.seg(seg));
endmodule
