module NPC(pc_four,jAddr,jump,bAddr,branch,zero,npc);
	input [31:0] pc_four;
	input[31:0] jAddr,bAddr;
	input jump, branch, zero;
	output reg[31:0] npc;
	always @(pc_four or jump or branch or zero) begin
		if (jump) begin
			npc <= jAddr;
		end
		else if (branch & zero) begin
			npc <= bAddr;
		end
		else npc <= pc_four;
	end
endmodule