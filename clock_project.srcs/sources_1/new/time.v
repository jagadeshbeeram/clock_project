module ctime(
input clk,
input load,loadstate,//loadstate = 0 hrs 1=> min
input increment,
input decrement,
input enable,state,//state 0=>clock,1=>stop watch
input reset,
output [6:0] seg,
output reg [5:0]sec,
output reg [3:0]an,
output reg [4:0]hr,
output reg [5:0] min 
    );
    wire clkout,clksec;
    wire increment1;
    wire [6:0] seg1;
    wire [1:0]ref;
    reg [3:0]val = 0;
   reg [3:0]sec1 = 0;
   reg [3:0]sec2 = 0;
     reg [3:0] min1,min2,min11,min12,min21,min22,mins1,mins2;
    reg [3:0] hr1,hr2,hr11,hr12,hr21,hr22,hour1,hour2;  
    reg u=0;
    reg d =0;;
    
 clock_divider ckl0(.clk(clk),.clkout(clkout));
 
always@(*)
begin
    min = min2*10 + min1;
    hr = hr2*10 + hr1;
end

 always@(posedge clkout or posedge reset)
 begin
     if(reset==1 && enable==0 )
         begin
             min1 = 0;
             min2 = 0;
             sec1 = 0;
             sec2 = 0;
         end
      else if( enable==1 && load==0)
         begin
            if(sec1==9)
                begin
                    sec1 = 0;
                    sec2 = sec2+1;
                end
            else
                sec1 = sec1+1;
            if(sec2==6)
                begin
                    sec2=0;
                    if(min1==9)
                        begin
                            min1=0;
                            min2=min2+1;
                        end
                    else
                        min1 = min1+1;
                end
            if(min2==6)
                begin
                    min2=0;
                    if(hr1==9)
                        begin
                            hr1=0;
                            hr2=hr2+1;
                        end
                    else
                        hr1 = hr1+1;
                end
             if(hr2==2&&hr1==4)
                begin
                   hr1=0;
                   hr2=0;
                end
             if(state == 0)
                sec <= sec2 * 10 + sec1;
             else
                sec = 6'b000000;
         end
     else if(load)
         begin
            min1 = mins1;
            min2 = mins2;
            hr1 = hour1;
            hr2 = hour2;
         end
 end

 always@(*)
 begin
    if(load==0)
    begin
        hour1=hr1;
        hour2=hr2;
        mins1=min1;
        mins2=min2;
    end
    else 
        begin
                hour1=hr11;
                hour2=hr12;
                mins1=min11;
                mins2=min12;
        end
 end
 
 always@(posedge increment)
 begin
    if(load)
    begin
//    min11 = min1;
//    min12 = min2;
//    hr11 = hr1;
//    hr12 = hr2;
        if(loadstate)
        begin
            hr12 = (hour1==9)?hour2 + 1: hour2;
            hr11 = (hour1==9)? 0:hour1 + 1;
            if(hr12==2&&hr11==4)
            begin
                hr11<=0;
                hr12 <= 0;
            end
        end
        else
        begin
            min12 = (mins1==9)?mins2 + 1: mins2;
            min11 = (mins1==9)? 0:mins1 + 1;
            if(min12==6 && min11==0)
            begin
                min11<=0;
                min12 <= 0;
            end
        end
     end
 end
 
// always@(*)
// begin
//    if(load==0)
//        u=0;
//    else if(load && increment)
//        u=1;
// end
 
// always@(posedge decrement)
// begin
//    if(load)
//    begin
//        if(loadstate)
//        begin
//            if(hour2==0&&hour1==0)
//            begin
//                hr21<=3;
//                hr22 <= 2;
//            end
//            else
//            begin
//                hr22 = (hour1==0)?hour2 - 1: hour2;
//                hr21 = (hour1==0)? 9:hour1 - 1;
//            end
            
//        end
//        else
//        begin
//            if(mins2==0&&mins1==0)
//            begin
//                min21 <= 9;
//                min22 <= 5;
//            end
//            else
//            begin
//                min22 = (mins1==0)?mins2 - 1: mins2;
//                min21 = (mins1==0)? 9:mins1 - 1;
//            end
            
//        end
//    end
// end
 
// always@(*)
// begin
//    if (increment)
//    begin
//        u=1;
//        d=0;
//    end
//    if (decrement)
//    begin
//        u=0;
//        d=1;
//    end
// end
 
  refresh s1(.clk(clk),.LED_activating_counter(ref));
 always @(*)
begin
     case(ref)
     2'b00: 
         begin
         an = 4'b1110; // "0"  
         if(state)
         val = sec1;
         else
         val = mins1;
         end
     2'b01:
         begin
         an = 4'b1101;
         if(state)
         val = sec2;
         else
         val = mins2;
         end 
     2'b10:
         begin an = 4'b1011;
         if(state)
         val = min1;
         else
         val = hour1; // "2" 
         end
     2'b11:
         begin
         an = 4'b0111; // "3"
         if(state)
         val = min2;
         else
         val = hour2;
         end 
     endcase
 end
  segment s0(.val(val),.seg(seg));
endmodule