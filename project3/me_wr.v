module me_wr(clk,Do_4,ALUout_4,rw_4,MemtoReg_4,RegWr_4,rd_4,
	Do_5,ALUout_5,rw_5,MemtoReg_5,RegWr_5,rd_5);
	input clk;
	input[31:0] Do_4,ALUout_4;
	input[4:0] rw_4,rd_4;
	input MemtoReg_4,RegWr_4;
	output reg[31:0] Do_5,ALUout_5;
	output reg[4:0] rw_5,rd_5;
	output reg MemtoReg_5,RegWr_5;

	initial
	begin
		Do_5 = 0;
		ALUout_5 = 0;
		rw_5 = 0;
		MemtoReg_5 = 0;
		RegWr_5 = 0;
		rd_5 =0;
	end
	always @(negedge clk) begin
		Do_5 <= Do_4;
		ALUout_5 <= ALUout_4;
		rw_5 <= rw_4;
		MemtoReg_5 <= MemtoReg_4;
		RegWr_5 <= RegWr_4;
		rd_5 <= rd_4;
	end
endmodule