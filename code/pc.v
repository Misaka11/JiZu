module PC(clk, rst, inpc, pc_Wr, outpc);
	input clk, rst;
	input [31:0] inpc;
	input pc_Wr;
	output [31:0] outpc;

	reg [31:0] outpc;

	initial
		begin 
			outpc = 32'h3000;
		end

	always @(negedge clk)
		begin
			if(rst)
			begin
				outpc <= 32'h3000;
			end
			else if(pc_Wr)
			begin
				outpc <= inpc;
			end
		end
endmodule




