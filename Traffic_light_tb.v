
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// This is a sample self-checking testbench
// 
//////////////////////////////////////////////////////////////////////////////////
module interface_tb;

reg CLK, R, A, B, A_Traffic, B_Traffic ;

wire [3:0] A_Time_L, A_Time_H, B_Time_L, B_Time_H;
wire  A_Light, B_Light;

///here we add the main block
Traffic_light uut (CLK, R, A, B, A_Traffic, B_Traffic, A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light);



/// here we build the clock
initial
begin
	CLK = 1'b0;
end
always 
#5
 CLK = ~CLK;
/// here we initial the reset 
initial
begin 
	A=0; 
	B=0; 
	A_Traffic=0;
	B_Traffic=0;
	R=1;
	#400;
	R=0;
	#1000;
	
	A=1;
	#30
	A=0;
	#30
	
	
	
	B=1;
	#30
	B=0;
	#30
	
	R=1;
	#30
	R=0;
	#30
	
	#1000
	
	B_Traffic=1;
	#300

	B_Traffic=0;
	
	A_Traffic=1;
	#300
	A_Traffic=0;
	
	#1000
	
	R=1;
	#10
	R=0;
	#50
	A_Traffic=1;
	#10
	A_Traffic=0;
	
	
	
	
#5000 $stop;	
end         

endmodule

//**************************************