module bound_flasher(clk, flick, rst_n, lamps );
	input clk;
	input flick;
	input rst_n;
	output reg [15:0] lamps;
	reg [4:0] kickback [5:0];
	reg [3:0]State;
	 reg [4:0]current_led;
	reg Mode  = 1;
initial begin
	State = 4'b0000;
	current_led = 5'b00000;
	kickback[0] = 16;
	kickback[1] = 5;
	kickback[2] = 11;
	kickback[3] = 0;
	kickback[4] = 6;
	kickback[5] = 0;
end
always @(posedge clk, negedge rst_n, posedge flick) begin
	if(rst_n == 0) begin
		current_led = 0;
		lamps = 0;
		State <= 0; 
		Mode <= 1;
		end
	else if(flick == 1'b1) begin
		if((current_led == 0 || current_led == 5) && (~Mode))  begin
			if(State != 5) begin 
				State <= State - 1;
				Mode <= 1;
				lamps[current_led] = 1'b1;
				end
			end
		end
	else begin
		if(current_led == kickback[State]) begin
			State <= (State + 1) % 6;
			Mode <= ~Mode;
			end
		if(Mode) begin
			lamps[current_led] = Mode;
			current_led = current_led + 1;		
			end
		else begin
			current_led = current_led - 1;
			lamps[current_led] = Mode;
			end
		end
	end
endmodule
