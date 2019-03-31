module id_ex(clk,stall,pc_four_2,imm16_2,busA_2,busB_2,rt_2,rd_2,ExtOp_2,ALUSrc_2,RegDst_2,MemWr_2,MemtoReg_2,RegWr_2,MemRead_2,ALUctr_2,rs_2,
	pc_four_3,imm16_3,busA_3,busB_3,rt_3,rd_3,ExtOp_3,ALUSrc_3,RegDst_3,MemWr_3,MemtoReg_3,RegWr_3,MemRead_3,ALUctr_3,rs_3);
	input clk,stall;	
	input[31:0] pc_four_2,busA_2,busB_2;
	input[15:0] imm16_2;
	input[4:0] rt_2,rd_2,rs_2;
	input[2:0] ALUctr_2;
	input ExtOp_2,ALUSrc_2,RegDst_2,MemWr_2,MemtoReg_2,RegWr_2,MemRead_2;
	output reg[31:0] pc_four_3,busA_3,busB_3;
	output reg[15:0] imm16_3;
	output reg[4:0] rt_3,rd_3,rs_3;
	output reg[2:0] ALUctr_3;
	output reg ExtOp_3,ALUSrc_3,RegDst_3,MemWr_3,MemtoReg_3,RegWr_3,MemRead_3;

	initial
	begin
		pc_four_3 = 0;
		imm16_3 = 0;
		busA_3 = 0;
		busB_3 = 0;
		rt_3 = 0;
		rd_3 = 0;
		rs_3 =0;
		ExtOp_3 = 0;
		ALUSrc_3 = 0;
		RegDst_3 = 0;
		MemWr_3  = 0;
		MemtoReg_3 = 0;
		RegWr_3 = 0;
		MemRead_3 =0;
		ALUctr_3 =0;
	end
    always @(negedge clk) begin
    if(stall)
    begin
		ExtOp_3 <= 0;
		ALUSrc_3 <= 0;
		RegDst_3 <= 0;
		MemWr_3  <= 0;
		MemtoReg_3 <= 0;
		RegWr_3 <= 0;
		MemRead_3 <= 0;
		ALUctr_3 <= 0;
    end
    else begin 
		pc_four_3 <= pc_four_2;
		imm16_3 <= imm16_2;
		busA_3 <= busA_2;
		busB_3 <= busB_2;
		rt_3 <= rt_2;
		rd_3 <= rd_2;
		ExtOp_3 <= ExtOp_2;
		ALUSrc_3 <= ALUSrc_2;
		RegDst_3 <= RegDst_2;
		MemWr_3  <= MemWr_2;
		MemtoReg_3 <= MemtoReg_2;
		RegWr_3 <= RegWr_2;
		MemRead_3 <=MemRead_2;
		ALUctr_3 <= ALUctr_2;
		rs_3 <= rs_2;
	end
    end
endmodule