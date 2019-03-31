module mips(clk, rst);
 	input clk, rst;
  
	wire [31:0] instr;
	wire [15:0] immi;
	wire [5:0] op, func;
	wire [4:0] rs,rt,rd;
	wire [4:0] ALUctr;
	wire [2:0] branch_type;
	wire [2:0] MemRead;
	wire [1:0] MemWr;
	wire RegWr,RegDst,branch,jump,ExtOp,ALUSrc,MemtoReg,JumpLink, JumpDst;

  	datapath DP(clk, rst, immi, ALUctr, rs, rt, rd, branch, branch_type, jump, RegDst, ALUSrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead, JumpLink, JumpDst, instr);
  	Control ctrl(instr, immi, op, func, ALUctr, rs, rt, rd, branch, branch_type, jump, RegDst, ALUSrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead, JumpLink, JumpDst);
  	
endmodule

