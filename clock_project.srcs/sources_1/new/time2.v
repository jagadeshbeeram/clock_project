module ctime2(
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
    wire clkout;
    wire [6:0] seg1;
    wire [1:0]ref;
    reg [3:0]val = 0;
   reg [3:0]sec1 = 0;
   reg [3:0]sec2 = 0;
     reg [3:0] min1,min2,min11,min12,min21,min22;
    reg [3:0] hr1,hr2,hr11,hr12,hr21,hr22;  
    
 clock_divider ckl0(.clk(clk),.clkout(clkout));

always@(*)
begin
    min = min2*10 + min1;
    hr = hr2*10 + hr1;
end

 always@(posedge increment or posedge clkout)
 begin
     if(reset==1 && enable==0)
         begin
             sec1 <= 0;
             sec2 <= 0;
             min1 <= 0;
             min2 <= 0;
         end
     else if(enable==1 && load==0 && clkout==1)
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
               hr1<=0;
               hr2<=0;
            end
         if(state == 0)
            sec <= sec2 * 10 + sec1;
         else
            sec = 6'b000000;
     end
     else if(load == 1)
     begin
//        min1 = min11;
//        min2 = min12;
//        hr1 = hr11;
//        hr2 = hr12;
            if(loadstate)
        begin
            hr2 = (hr1==9)?hr2 + 1: hr2;
            hr1 = (hr1==9)? 0:hr1 + 1;
            if(hr2==2&&hr1==4)
            begin
                hr1<=0;
                hr2 <= 0;
            end
        end
        else
        begin
            min2 = (min1==9)?min2 + 1: min2;
            min1 = (min1==9)? 0:min1 + 1;
            if(min2==6 && min1==0)
            begin
                min1<=0;
                min2 <= 0;
            end
        end
     end
 end

 
// always@(posedge increment or posedge load)
// begin
//    if(load)
//    begin
//    min11 = min1;
//    min12 = min2;
//    hr11 = hr1;
//    hr12 = hr2;
//        if(loadstate)
//        begin
//            hr12 = (hr11==9)?hr12 + 1: hr12;
//            hr11 = (hr11==9)? 0:hr11 + 1;
//            if(hr12==2&&hr11==4)
//            begin
//                hr11<=0;
//                hr12 <= 0;
//            end
//        end
//        else
//        begin
//            min12 = (min11==9)?min12 + 1: min12;
//            min11 = (min11==9)? 0:min11 + 1;
//            if(min12==6 && min11==0)
//            begin
//                min11<=0;
//                min12 <= 0;
//            end
//        end
//     end
// end
 
// always@(posedge decrement)
// begin
//    if(load)
//    begin
//        min11 = min1;
//        min12 = min2;
//        hr11 = hr1;
//        hr12 = hr2;
//        if(loadstate)
//        begin
//            if(hr12==0&&hr11==0)
//            begin
//                hr11<=3;
//                hr12 <= 2;
//            end
//            else
//            begin
//                hr12 = (hr11==0)?hr12 - 1: hr12;
//                hr11 = (hr11==0)? 9:hr11 - 1;
//            end
            
//        end
//        else
//        begin
//            if(min12==0&&min11==0)
//            begin
//                min11 <= 9;
//                min12 <= 5;
//            end
//            else
//            begin
//                min12 = (hr11==0)?min12 - 1: min12;
//                min11 = (min11==0)? 9:min11 - 1;
//            end
            
//        end
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
         val = min1;
         end
     2'b01:
         begin
         an = 4'b1101;
         if(state)
         val = sec2;
         else
         val = min2;
         end 
     2'b10:
         begin an = 4'b1011;
         if(state)
         val = min1;
         else
         val = hr1; // "2" 
         end
     2'b11:
         begin
         an = 4'b0111; // "3"
         if(state)
         val = min2;
         else
         val = hr2;
         end 
     endcase
 end
  segment s0(.val(val),.seg(seg));
endmodule