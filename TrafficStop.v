
module TrafficStop(CLK, Reset, A_Traffic, B_Traffic, state, Traffic_stop );

input A_Traffic, B_Traffic, CLK, Reset;
input [2:0] state;
parameter init_state = 0, A_state = 1, B_state = 2, A_is_green = 3, B_is_green = 4, Blink_state=5;
output reg [9:0] Traffic_stop;

always@(posedge CLK)
begin
if(Reset==1)
	Traffic_stop <= 0;
else
begin

	if((A_Traffic == 1 && state == A_state )|| (B_Traffic == 1 && state == B_state)) /// detecting high traffic on 
		Traffic_stop <= Traffic_stop + 1;
	else
		Traffic_stop <= 0;
end
end


endmodule