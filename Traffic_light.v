module Traffic_light (CLK, R, A, B, A_Traffic, B_Traffic, A_Time_L, A_Time_H, B_Time_L, B_Time_H, A_Light, B_Light);
input CLK, R, A, B, A_Traffic, B_Traffic;
output reg [3:0]  A_Time_L, A_Time_H, B_Time_L, B_Time_H;
output reg A_Light, B_Light;


reg [2:0] state ;
 /// A_state = normal mode for A 
 // B_state = normal mode for B 
 // A_is_green = when A is pressed
 // B_is_green = when B is pressed 
 // Blink_state = when A & B are blinking
 
parameter init_state = 0, A_state = 1, B_state = 2, A_is_green = 3, B_is_green = 4, Blink_state=5;
reg [6:0] cntA, cntB; /// for counting 90 & 30 seconds
wire [9:0] Traffic_stop; /// for counting 10 seconds when traffic is high
reg	[2:0] Traffic_cnt; /// for counting 5 seconds when traffic is low
wire [6:0] Traffic_gone; /// for counting 125 seconds when there is no traffic
wire [3:0] Traffic_Back; /// for counting 5 seconds when traffic starts again!!
reg Reset;
TrafficStop TS(CLK, Reset, A_Traffic, B_Traffic, state, Traffic_stop);
TrafficGone TG(CLK, Reset, A_Traffic,state, B_Traffic,Traffic_gone,Traffic_Back );

always @(posedge CLK)
begin
	if(R == 1)
	begin
		state <= init_state;
		Reset <= 1;
	end
	else //R==0
	begin
		case(state)
		  //*********************************************************
			init_state:  /// this state is for initializing lights and timers and all registers when someone press R
			begin
				cntA <= 0;
				cntB <= 0;
				
				A_Time_L <= 9;
				A_Time_H <= 8;
				B_Time_L <= 9;
				B_Time_H <= 8;
				
			//	Traffic_stop <= 0; 
				Traffic_cnt <= 0;
			//	Traffic_Back <=0;
		//		Traffic_gone <= 0;
				
				Reset <= 0;
				state <= A_state;
			end
			//*******************************************************************
			A_state: // this is A normal mode state
			begin
				if(A == 1) // when A is pressed
					state <= A_is_green; 
				else if(B == 1) // when B is pressed
					state <= B_is_green; 
				
				else if(cntA < 89 && (Traffic_cnt < 5) )  
				begin
				
					if(Traffic_stop < 10 ) /// increase timers if traffic is low
					begin
						if(A_Time_L == 0)
							A_Time_L <= 9;
						else
							A_Time_L <= A_Time_L - 1;
							
						if( A_Time_L == 0)
							A_Time_H <= A_Time_H - 1;
							
						if(B_Time_L == 0)
							B_Time_L <= 9;
						else
							B_Time_L <= B_Time_L - 1;
						
						if( B_Time_L == 0)
							B_Time_H <= B_Time_H - 1;
							
						cntA <= cntA + 1;
					end
						
					A_Light <= 1;
					B_Light <= 0;
					cntB <= 0;
					state <= A_state;
				
					if(A_Traffic == 0 && B_Traffic == 1) /// detecting low traffic on A and high traffic on B
						Traffic_cnt <= Traffic_cnt + 1;
					else
						Traffic_cnt <= 0;
						
			/*			
					if(A_Traffic == 1) /// detecting high traffic on A
						Traffic_stop <= Traffic_stop + 1;
					else
						Traffic_stop <= 0;
					
					if(A_Traffic == 0 && B_Traffic == 0) /// detecting no traffic on A and B
						Traffic_gone <= Traffic_gone + 1;
					else
						Traffic_gone <= 0;
				*/		
					if(Traffic_gone == 123) /// go to blinking state when there is no traffic !!! 
					begin
						A_Time_L <= 4'b1111;
						A_Time_H <= 4'b1111;
						B_Time_L <= 4'b1111;
						B_Time_H <= 4'b1111;
			//			Traffic_gone <= 0;
						state <= Blink_state;
					end						
				end
				
				else /// go to state B after 90 seconds
				begin
					Traffic_cnt <= 0;
				///	Traffic_stop <= 0;
					
					B_Light <= 1;
					A_Light<= 0;
					
					if(Traffic_gone == 125)
					begin
						state <= Blink_state;
						B_Time_L <= 4'b1111;
						B_Time_H <= 4'b1111;
						A_Time_L <= 4'b1111;
						A_Time_H <= 4'b1111;
					end
					
					else /// go to state B after 90 seconds
					begin
						state <= B_state;
						B_Time_L <= 9;
						B_Time_H <= 2;
						A_Time_L <= 9;
						A_Time_H <= 2;
					end
				end
			end	
			//*****************************************************************
			B_state:	// this is B normal mode
			begin
				if(A == 1) 
			     	state <= A_is_green; 
				  else if(B == 1) 
				     state <= B_is_green; 
				
				else if(cntB < 29 && Traffic_cnt < 5)
				begin
					
					if(Traffic_stop < 10 ) /// increase timers if traffic is low
					begin
						if(A_Time_L == 0)
							A_Time_L <= 9;
						else
							A_Time_L <= A_Time_L - 1;
							
						if( A_Time_L == 0)
							A_Time_H <= A_Time_H - 1;
							
						if(B_Time_L == 0)
							B_Time_L <= 9;
						else
							B_Time_L <= B_Time_L - 1;
						
						if( B_Time_L == 0)
							B_Time_H <= B_Time_H - 1;
						cntB <= cntB + 1;
					end
					
					A_Light <= 0;
					B_Light <= 1;
					cntA <= 0;
					state <= B_state;
					
					if(A_Traffic == 1 && B_Traffic == 0) /// detecting low traffic on B and high traffic on A
						Traffic_cnt <= Traffic_cnt + 1;
					else
						Traffic_cnt <= 0;
				/*		
					if(B_Traffic == 1) /// detecting high traffic on B
						Traffic_stop <= Traffic_stop + 1;
					else
						Traffic_stop <= 0;
						
					if(B_Traffic == 0 && A_Traffic == 0) /// detecting no traffic on A and B
						Traffic_gone <= Traffic_gone + 1;
					else
						Traffic_gone <= 0;
					*/			
					if(Traffic_gone == 125) /// go to blinking state when there is no traffic !!! 
					begin
						//Traffic_gone <= 0;
						A_Time_L <= 4'b1111;
						A_Time_H <= 4'b1111;
						B_Time_L <= 4'b1111;
						B_Time_H <= 4'b1111;
						state <= Blink_state;
					end							
				end
				else 
				begin
					Traffic_cnt <= 0;
			///		Traffic_stop <= 0;
					
					B_Light <= 0;
					A_Light<= 1;
					if(Traffic_gone == 125)
					begin
						state <= Blink_state;
						B_Time_L <= 4'b1111;
						B_Time_H <= 4'b1111;
						A_Time_L <= 4'b1111;
						A_Time_H <= 4'b1111;
					end
					else /// go to state B after 30 seconds
					begin
						state <= A_state;
						B_Time_L <= 9;
						B_Time_H <= 8;
						A_Time_L <= 9;
						A_Time_H <= 8;
					end
				end		
			end
			//*********************************************************************
			A_is_green: /// when A is pressed
			begin
				A_Light = 1;
				B_Light = 0;
				A_Time_L <= 4'b1111;
				A_Time_H <= 4'b1111;
				B_Time_L <= 4'b1111;
				B_Time_H <= 4'b1111;
				if(R == 1) // if R pressed
				begin
				 state <= init_state; 
				end
				else if(B == 1) 
				     state <= B_is_green; // if B pressed
			end
			
			//************************************************************************
			B_is_green: // when B is pressed
			begin
				A_Light <= 0;
				B_Light <= 1;
				A_Time_L <= 4'b1111;
				A_Time_H <= 4'b1111;
				B_Time_L <= 4'b1111;
				B_Time_H <= 4'b1111;
				if(R == 1) /// if R pressed
				begin
					state <= init_state; 
				end
				else if(A == 1)
				   state <= A_is_green;  /// if A pressed
			end
			
			
		//*********************************************************
			
			Blink_state: // when there is no traffic
			begin
				if(A == 1) 
				    state <= A_is_green; 
				else if(B == 1) 
				    state <= B_is_green; 
				else 
				  
				begin
					A_Light <= !A_Light; ///blinking
					B_Light <= !B_Light;  ///blinking
					
			/*		if(A_Traffic == 1 || B_Traffic ==1)
						Traffic_Back <= Traffic_Back + 1;
					else
						Traffic_Back <= 0;
			*/			
					if(Traffic_Back == 4) /// if traffic starts
					begin
					//	Traffic_Back <=0;
						state <= init_state;
					end
				end 
			end
		endcase
	end
end
endmodule

