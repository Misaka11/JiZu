module PC(clk,rst,npc,pcwrite,pc);
	input clk,rst;
	input[31:0] npc;
	input pcwrite;
	output reg[31:0] pc;
	initial begin
		pc =  32'h3000;
	end

	always @(negedge clk) begin
		if (rst) begin
			pc <= 32'h3000;
		end
		else if(pcwrite)begin
			pc <= npc;
		end
	end
endmodule

