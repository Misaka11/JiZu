module datapath(clk, rst, immi, ALUctr, rs, rt, rd, branch, branch_type, jump, RegDst, ALUSrc, MemtoReg, RegWr, MemWr, Extop, MemRead, Reg31Wr, jumpDst, instr_out_IFID);

	input clk, rst;
	input [15:0] immi;
	input [4:0] rs,rt,rd;
	input [4:0] ALUctr;
	input [2:0] branch_type;
	input [2:0] MemRead;
	input [1:0] MemWr;
	input RegWr,Reg31Wr,RegDst,branch,jump,Extop,ALUSrc,MemtoReg, jumpDst;
	
	output [31:0] instr_out_IFID;
	
	wire [31:0] pc_result_out_ExMem, ALU_result_out_ExMem, dataWr_out_ExMem, HI_result_out_ExMem, LO_result_out_ExMem;
	wire PCSrc;
	wire [31:0] dout_out_MemWB, ALU_result_out_MemWB, HI_result_out_MemWB, LO_result_out_MemWB;
	wire [31:0] result_toReg;
	wire RegWr_out_MemWB, MemtoReg_out_MemWB;
	wire [4:0] rw_out_MemWB;
	wire [1:0] ForwardA, ForwardB, ForwardB2, ForwardC, ForwardD;
	wire stall;
	wire pc_Wr, IFID_Wr, ctrl_Wr;
	wire [31:0] HI_result, LO_result, HI_output, LO_output;
	wire HI_Wr, LO_Wr, HI_Wr_out_ExMem, LO_Wr_out_ExMem, HI_Wr_out_MemWB, LO_Wr_out_MemWB;


	//IF
	wire [31:0] inpc, outpc, instr;
	wire [31:0] pc_4_out_IFID, instr_out_IFID;
	wire [31:0] pc_4, pc_temp, pc_jump, pc_branch, pc_immi, pc_reg;
	wire IFID_flush;
	
	assign pc_4 = outpc + 4;
	assign IFID_flush = (!stall)&&(jump || PCSrc);
	mux2 mux_pc_temp(pc_4, pc_branch, PCSrc, pc_temp);
	mux2 mux_inpc(pc_temp, pc_jump, jump, inpc);
	PC pc(clk, rst, inpc, pc_Wr, outpc);
	im_4k IM(outpc[11:2], instr);
	reg_IFID R1(clk, rst, IFID_Wr, IFID_flush, pc_4, instr, pc_4_out_IFID, instr_out_IFID);

	//ID
	wire RegDst_out_IDEx, RegWr_out_IDEx, MemtoReg_out_IDEx, Extop_out_IDEx, ALUSrc_out_IDEx, branch_out_IDEx, jump_out_IDEx;
	wire [1:0] MemWr_out_IDEx;
	wire [2:0] MemRead_out_IDEx;
	wire [4:0] ALUctr_out_IDEx;
	wire [4:0] rs_out_IDEx, rd_out_IDEx, rt_out_IDEx;
	wire [31:0] pc_4_out_IDEx, data1_out_IDEx, data2_out_IDEx, ExtImmi_out_IDEx;
	wire RegDst_in_IDEx, RegWr_in_IDEx, MemtoReg_in_IDEx, Extop_in_IDEx, ALUSrc_in_IDEx, branch_in_IDEx, jump_in_IDEx;
	wire [1:0] MemWr_in_IDEx;
	wire cmp_result;

	wire [31:0] data1, data2;
	wire [31:0] ExtImmi;
	wire [31:0] cmp_data1, cmp_data2;

	assign ExtImmi = {{16{immi[15]}}, immi};
	assign pc_immi = {outpc[31:28], instr_out_IFID[25:0], 2'b00};
	assign pc_reg = data1;
	mux2 pc_Jump(pc_immi, pc_reg, jumpDst, pc_jump);
	assign pc_branch = pc_4_out_IFID + (ExtImmi<<2);

	Register register(clk, RegWr_out_MemWB, Reg31Wr, rs, rt, rw_out_MemWB, pc_4_out_IFID, result_toReg, data1, data2);
	
	mux3_32 mux_cmp1(data1, result_toReg, ALU_result_out_ExMem, ForwardC, cmp_data1);
	mux3_32 mux_cmp2(data2, result_toReg, ALU_result_out_ExMem, ForwardD, cmp_data2);
	comparator cmp(branch_type ,cmp_data1, cmp_data2, cmp_result);
	assign PCSrc = branch&cmp_result;

	mux2_1 mux_RegDst(1'b0, RegDst, ctrl_Wr, RegDst_in_IDEx);
	mux2_1 mux_RegWr(1'b0, RegWr, ctrl_Wr, RegWr_in_IDEx);
	mux2_2 mux_MemWr(2'b00, MemWr, ctrl_Wr, MemWr_in_IDEx);
	mux2_1 mux_MemtoReg(1'b0, MemtoReg, ctrl_Wr, MemtoReg_in_IDEx);
	mux2_1 mux_Extop(1'b0, Extop, ctrl_Wr, Extop_in_IDEx);
	mux2_1 mux_ALUSrc(1'b0, ALUSrc, ctrl_Wr, ALUSrc_in_IDEx);
	mux2_1 mux_branch(1'b0, branch, ctrl_Wr, branch_in_IDEx);
	mux2_1 mux_jump(1'b0, jump, ctrl_Wr, jump_in_IDEx);
	  
	reg_IDEx R2(clk, rst, pc_4_out_IFID, data1, data2, ExtImmi, rs, rd, rt, ALUctr, 
				RegDst_in_IDEx, RegWr_in_IDEx, MemWr_in_IDEx, MemRead, MemtoReg_in_IDEx, Extop_in_IDEx, ALUSrc_in_IDEx, branch_in_IDEx, jump_in_IDEx,
				pc_4_out_IDEx, data1_out_IDEx, data2_out_IDEx, ExtImmi_out_IDEx, rs_out_IDEx, rd_out_IDEx, rt_out_IDEx, ALUctr_out_IDEx,
				RegDst_out_IDEx, RegWr_out_IDEx, MemWr_out_IDEx, MemRead_out_IDEx, MemtoReg_out_IDEx, Extop_out_IDEx, ALUSrc_out_IDEx, branch_out_IDEx, jump_out_IDEx);

	//Ex
	wire [31:0] inputA, inputB, B_temp, pc_result, dataWr_in_ExMem;
	wire [31:0] ALU_result;
	wire [4:0] rw;
	wire zero;

	wire RegWr_out_ExMem, branch_out_ExMem, MemtoReg_out_ExMem, zero_out_ExMem;
	wire [1:0] MemWr_out_ExMem;
	wire [2:0] MemRead_out_ExMem;
	//wire [31:0] pc_result_out_ExMem, ALU_result_out_ExMem, data2_out_ExMem;
	wire [4:0] rw_out_ExMem;

	assign pc_result = pc_4_out_IDEx + (ExtImmi_out_IDEx<<2);
	assign rw = (RegDst_out_IDEx == 1)?rd_out_IDEx:rt_out_IDEx;
	
	mux3_32 mux_inputA(data1_out_IDEx, result_toReg, ALU_result_out_ExMem, ForwardA, inputA);
	mux2 mux_B_temp(data2_out_IDEx, ExtImmi_out_IDEx, ALUSrc_out_IDEx, B_temp);
	mux3_32 mux_inputB(B_temp, result_toReg, ALU_result_out_ExMem, ForwardB, inputB);
	mux3_32 mux_dataWr(data2_out_IDEx, result_toReg, ALU_result_out_ExMem, ForwardB2, dataWr_in_ExMem); // dataWr
	ALU alu(inputA, inputB, ALUctr_out_IDEx, zero, HI_Wr, LO_Wr, ALU_result, HI_result, LO_result);
	reg_ExMem R3(clk, rst, RegWr_out_IDEx, branch_out_IDEx, MemWr_out_IDEx, MemRead_out_IDEx, MemtoReg_out_IDEx, zero, HI_Wr, LO_Wr,
				pc_result, ALU_result, dataWr_in_ExMem, HI_result, LO_result, rw,
				RegWr_out_ExMem, branch_out_ExMem, MemWr_out_ExMem, MemRead_out_ExMem, MemtoReg_out_ExMem, zero_out_ExMem, HI_Wr_out_ExMem, LO_Wr_out_ExMem,
				pc_result_out_ExMem, ALU_result_out_ExMem, dataWr_out_ExMem, HI_result_out_ExMem, LO_result_out_ExMem, rw_out_ExMem);

	//Mem
	//wire PCSrc;
	wire [31:0] dout;
	//wire RegWr_out_MemWB, MemtoReg_out_MemWB;
	//wire [31:0] dout_out_MemWB, ALU_result_out_MemWB;
	//wire [4:0] rw_out_MemWB;

	dm_4k DM(ALU_result_out_ExMem[11:2], dataWr_out_ExMem, MemWr_out_ExMem, MemRead_out_ExMem, clk, dout);
	reg_MemWB R4(clk, rst, RegWr_out_ExMem, HI_Wr_out_ExMem, LO_Wr_out_ExMem, MemtoReg_out_ExMem, dout, ALU_result_out_ExMem, HI_result_out_ExMem, LO_result_out_ExMem, rw_out_ExMem,
				RegWr_out_MemWB, HI_Wr_out_MemWB, LO_Wr_out_MemWB, MemtoReg_out_MemWB, dout_out_MemWB, ALU_result_out_MemWB, HI_result_out_MemWB, LO_result_out_MemWB, rw_out_MemWB);
	//WB
	//wire [31:0] result_toReg;
	mux2 mux_result(ALU_result_out_MemWB, dout_out_MemWB, MemtoReg_out_MemWB, result_toReg);
  
  	//ForwardingUnit
  	ForwardingUnit forward(rs, rt, rs_out_IDEx, rt_out_IDEx, rw_out_ExMem, rw_out_MemWB, RegWr_out_ExMem, RegWr_out_MemWB, ALUSrc_out_IDEx, ForwardA, ForwardB, ForwardB2, ForwardC, ForwardD);
  
  	//HazardDetectionUnit
  	HazardDetectionUnit hazard(rs, rt, rt_out_IDEx, rw, rw_out_ExMem, RegWr_out_IDEx, MemtoReg_out_IDEx, MemtoReg_out_ExMem, branch, stall, pc_Wr, IFID_Wr, ctrl_Wr);
  
  	//reg HI LO
  	reg_HI R_HI(clk, HI_Wr_out_MemWB, HI_result_out_MemWB, HI_output);
  	reg_LO R_LO(clk, LO_Wr_out_MemWB, LO_result_out_MemWB, LO_output);

endmodule // datapath


