`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////
//    IonControl 1.0:  Copyright 2016 Sandia Corporation              
//    This Software is released under the GPL license detailed    
//    in the file "license.txt" in the top-level pyGSTi directory 
//////////////////////////////////////////////////////////////////

module delay_generator_no_retrigger(
		input wire clk,
		input wire [DelayWidth-1:0] delay, 
		input wire trigger,
		output reg q = 1'b0,
		input wire ce
	 );
	 
parameter DelayWidth = 4;
parameter [DelayWidth-1:0] Null = 0;

reg waiting = 1'b0;
reg [1:0] state = 2'h0;
reg [DelayWidth-1:0] timer = Null;

always @(posedge clk) begin
	q <= 1'b0;       // default if not overwritten
	case (state)
		2'h0: if (trigger & ce) begin
				state <= 2'h1;
				timer[DelayWidth-1:0] <= delay[DelayWidth-1:0]-2'h2;
			end
		2'h1: if (timer==Null) 
				state <= 2'h2;
			else 
				timer[DelayWidth-1:0] <= timer[DelayWidth-1:0]-1'h1;
		2'h2: begin
				state <= 2'h3;
				q <= 1'b1;
			end
		2'h3: begin
				q <= 1'b0;
				if (~trigger) state <= 1'h0;
			end
	endcase
end


endmodule
