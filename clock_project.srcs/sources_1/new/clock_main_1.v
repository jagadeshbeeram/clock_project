`timescale 1ns / 1ps

module clock_main_1(
input clk,mode,load,loadstate,increment,decrement,
input almdigit,
input [5:0]alminput,
output alarm_led,timerled,
input start,reset,prevld,//start pin 1 and reset pin 2 
input alm_on,timer_on,
output reg [3:0]m,
output reg [6:0]seg,
output reg [3:0]an,
output [5:0]sec
    );
    wire clksec;
    wire [6:0]timeseg;
    wire [3:0]timean;
    wire [6:0]stopseg;
    wire [3:0]stopan;
    wire [6:0]alarm_seg,timerseg;
    wire [3:0]alarm_an,timeran;
    wire alm;
    wire [5:0]sec2;
    reg load1 = 0;
    reg load2 = 0;
    reg load3 = 0;
    reg k;
    reg digit0,digit1;
    reg [2:0] modevalue = 3'b000;
    wire [4:0] hr;
    wire [5:0] min;
    wire[1:0] activate;
    clock_divider ckl00(.clk(clk),.clkout(clksec));
    refresh r1(.clk(clk),.LED_activating_counter(activate));
    ctime c0(.enable(1),.reset(0),.state(1'b0),.clk(clk),.seg(timeseg),.sec(sec),.an(timean),.load(load1),.loadstate(loadstate),.increment(increment),.decrement(decrement),.hr(hr),.min(min));
    ctime c1(.enable(start),.reset(reset),.state(1'b1),.clk(clk),.seg(stopseg),.sec(sec2),.an(stopan),.load(1'b0),.loadstate(loadstate),.increment(increment),.decrement(decrement));
    alarm a1(.load(load2),.clk(clk),.clksec(clksec),.digit(digit0),.min(min),.hr(hr),.q(alminput),.alarm_led(alm),.seg(alarm_seg),.an(alarm_an));
    timer t(.clkout(clksec),.ref(activate),.load(load3),.digit(digit1),.timer_on(timer_on),.prevld(prevld),.q(alminput),.led(timerled),.seg(timerseg),.an(timeran));
    and g1(alarm_led,alm,alm_on);
//assign load1 = (modevalue==0&&load==1)?1:0;//load for clock setup
//assign load2 = (modevalue==2&&load==1)?1:0;//ooad for alarm setup
//start pin 1 and reset pin 2 
//    stop_watch s0(.clksec(clksec),.start(start),.reset(reset),.seg(stopseg),.an(stopan));
    always@(posedge mode)
    begin
        modevalue = (modevalue == 3)?0: modevalue +1;
    end
   
   always@(*)
   begin
   if (load==1&&modevalue==0)
        load1=1;
   else if(load==1 && modevalue==2)
        load2=1;
   else if(load==1 && modevalue==3)
        load3=1;
   else
       begin
           load1=0;
           load2=0;
           load3=0;
       end
        case(modevalue)
            3'b000:
                begin
                seg =timeseg;
                an = timean; 
                m = 4'b1000;
                end
            3'b001:
                begin
                seg <=stopseg;
                an <= stopan;
                m = 4'b0100; 
                end
            3'b010:
                begin
                seg<=alarm_seg;
                an <=alarm_an;
                m = 4'b0010;
                digit0 = almdigit;
                digit1 = 0;
                end
            3'b011:
                begin
                seg<=timerseg;
                an <=timeran;
                m = 4'b0001;
                digit1 = almdigit;
                digit0 = 0;
                end 
         endcase
   end
endmodule




