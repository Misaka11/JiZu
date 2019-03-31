module ex_me(clk,ALUout_3,busB_3,rw_3,MemWr_3,MemtoReg_3,RegWr_3,rd_3,
	ALUout_4,busB_4,rw_4,MemWr_4,MemtoReg_4,RegWr_4,rd_4);
	input clk;
	input[31:0] ALUout_3,busB_3;
	input[4:0] rw_3,rd_3;
	input MemWr_3,MemtoReg_3,RegWr_3;
	output reg[31:0] ALUout_4,busB_4;
	output reg[4:0] rw_4,rd_4;
	output reg MemWr_4,MemtoReg_4,RegWr_4;
	initial
	begin
		ALUout_4 = 0;
		busB_4 = 0;
		rw_4 = 0;
		MemWr_4 = 0;
		MemtoReg_4 = 0;
		RegWr_4 = 0;
		rd_4 = 0;
	end
	always @(negedge clk) begin
		ALUout_4 <= ALUout_3;
		busB_4 <= busB_3;
		rw_4 <= rw_3;
		MemWr_4 <= MemWr_3;
		MemtoReg_4 <= MemtoReg_3;
		RegWr_4 <= RegWr_3;
		rd_4 <= rd_3;
	end
endmodule