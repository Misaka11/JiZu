module Register(clk, RegWr, Reg31Wr, rs, rt, rw, Reg31din, busW, busA, busB);
	input clk, RegWr, Reg31Wr;
	input [4:0] rs, rt, rw;
	input [31:0] busW, Reg31din;
	output [31:0] busA, busB;

	reg [31:0] register [31:0];
	integer i;
	initial
	begin 
		for(i=0; i<32; i=i+1)
			register[i] = 32'b0;
	end

	assign busA = (rs==0)?0:register[rs];
	assign busB = (rt==0)?0:register[rt];
	always @(posedge clk)
	begin
		if(RegWr)
			register[rw] <= busW;
		if(Reg31Wr)
			register[31] <= Reg31din;
	end

endmodule


module reg_HI(clk, wr, din, dout);
	input clk;
	input wr;
	input [31:0] din;
	output reg [31:0] dout;

	initial
	begin
		dout = 32'b0;
	end

	always @(posedge clk) 
	begin
		if(wr)
		begin
			dout = din;
		end
	end

endmodule // reg_HI


module reg_LO(clk, wr, din, dout);
	input clk;
	input wr;
	input [31:0] din;
	output reg [31:0] dout;

	initial
	begin
		dout = 32'b0;
	end

	always @(posedge clk) 
	begin
		if(wr)
		begin
			dout = din;
		end
	end

endmodule // reg_LO




