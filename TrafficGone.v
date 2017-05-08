module TrafficGone(CLK, Reset, A_Traffic,state, B_Traffic,Traffic_gone,Traffic_Back );

input A_Traffic, B_Traffic, CLK, Reset;
input [2:0]state;

parameter init_state = 0, A_state = 1, B_state = 2, A_is_green = 3, B_is_green = 4, Blink_state=5;
output reg [6:0] Traffic_gone;
output reg [3:0]Traffic_Back;

always@(posedge CLK)
begin
if(Reset==1)
begin
	Traffic_gone <= 0;
	Traffic_Back <= 0;
end
else
begin

	if(B_Traffic == 0 && A_Traffic == 0) /// detecting no traffic on A and B
		Traffic_gone <= Traffic_gone + 1;
	else
		Traffic_gone <= 0;
		
	if((A_Traffic == 1 || B_Traffic ==1) && state == Blink_state )   
		Traffic_Back <= Traffic_Back + 1;
	else
		Traffic_Back <= 0;
end
end


endmodule
