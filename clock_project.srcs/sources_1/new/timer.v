`timescale 1ns / 1ps


module timer(
input clkout,
input [1:0]ref,
input load,
input digit,
input timer_on,
input prevld,
input [5:0]q,
output reg led,
output [6:0]seg,
output reg [3:0]an
    );
    reg [5:0]min = 0,mins;
    reg [5:0]sec = 0,secs;
    reg [5:0]min1 = 0;
    reg [5:0]sec1 = 0;
    reg digitval;
    reg finish=0;
    reg [3:0]val = 0; 
     always@(posedge digit)
        digitval = ~digitval;
    
    always@(q)
    begin
        if(load)
            begin
                if(!digitval)
                    begin
                        if(q>59)
                            sec = 59;
                        else
                            sec = q;    
                    end
                else
                    begin
                        if(q>59)
                            min = 59;
                        else
                            min = q;
                    end
            end
    end

always@(*)
begin 
    if(min1==0&&sec1==0)
        finish=1;
    else
        finish=0;
end

always@(*)
begin
    if(finish==1 && clkout==1 && timer_on)
        led=1;
    else
    led=0;
end
//and g1(led,finish,clkout,timer_on);

always@(posedge clkout or posedge prevld)
    begin
        if(load==0 && timer_on&& finish==0)
            begin
                min1 = (sec1==0)?min1-1:min1;
                sec1 = (sec1==0)?59:sec1-1;
            end
        if(prevld==1)
        begin
            min1 = min;
            sec1 = sec;
        end
        else if(load)
        begin
            min1 = mins;
            sec1 = secs;
        end
    end

always@(*)
begin
    if(load)
    begin
        mins = min;
        secs = sec;
    end
    else
    begin 
        mins = min1;
        secs = sec1;
    end
end

 always @(*)
begin
     case(ref)
     2'b00: 
         begin
         an = 4'b1110; // "0"  
         val = secs%10;
         end
     2'b01:
         begin
         an = 4'b1101;
         val = secs/10;
         end 
     2'b10:
         begin an = 4'b1011;
         val = mins%10; // "2" 
         end
     2'b11:
         begin
         an = 4'b0111; // "3"
         val = mins/10;
         end 
     endcase
 end
  segment s10(.val(val),.seg(seg));
    
endmodule
