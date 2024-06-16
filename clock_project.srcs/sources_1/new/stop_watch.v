`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



//module stop_watch(
//input clksec,
//input start,
//input reset,
//output [6:0]seg,
//output[3:0]an
//    );
//    reg[3:0]sec1 = 0;
//    reg[3:0]sec2 = 0;
//    reg[3:0]min1 = 0;
//    reg[3:0]min2 = 0;
//    reg dlkstate = 1'b0;
//    always@(posedge clksec or posedge reset)
//    begin
//        if(start)
//        begin
//            if(sec1==9)
//                begin
//                    sec1 = 0;
//                    sec2 = sec2+1;
//                end
//                else
//                sec1 = sec1+1;
                
//             if(sec2==6)
//                 begin
//                     sec2=0;
//                     if(min1==9)
//                     begin
//                        min1=0;
//                        min2=min2+1;
//                     end
//                     else
//                        min1 = min1+1;
//                 end
//        end
//    end
    
//endmodule
