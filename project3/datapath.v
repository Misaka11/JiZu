module datapath(clk,rst);
	input clk;
	input rst;
	//module FUnit
	wire[31:0] pc_1,npc_1,pc_four_1,instr_1;
	//module DUnit
	wire[31:0] pc_four_2,instr_2;
	wire [5:0] op_2;
	wire [4:0] rs_2,rt_2,rd_2;
	wire [15:0] imm16_2;
	wire [5:0] func_2;
	wire ExtOp_2,ALUSrc_2,RegDst_2,MemWr_2,Branch_2,Jump_2,MemtoReg_2,RegWr_2;
	wire[2:0] ALUctr_2;
	wire[31:0] busA_2,busB_2; 
	wire[31:0] jAddr_2,bAddr_2;
	//module EUnit
	wire[31:0] pc_four_3;
	wire [4:0] rt_3,rd_3,rw_3,rs_3;
	wire [15:0] imm16_3;
	wire ExtOp_3,ALUSrc_3,RegDst_3,MemWr_3,MemtoReg_3,RegWr_3;
	wire[2:0] ALUctr_3;
	wire[31:0] busA_3,busB_3,imm32_3;
	reg[31:0] A_3,B_3;
	wire[31:0] ALUout_3;
	//module MUnit
	wire[31:0] ALUout_4,busB_4;
	wire[4:0] rw_4,rd_4;
	wire MemWr_4,MemtoReg_4,RegWr_4;
	wire[31:0] Do_4;
	//module WUnit
	wire[31:0] Do_5,ALUout_5;
	wire[4:0] rw_5,rd_5;
	wire MemtoReg_5,RegWr_5;
	wire[31:0] Di_5;
	//zhuanfa Unit
	wire[1:0] ALUSrcA_3,ALUSrcB_3;
	wire MemRead_3,pcwrite,stall,ifwrite;
	reg if_flush,Zero_2;

	//module FUnit
	assign pc_four_1 = pc_1 + 4;

	NPC _NPC(pc_four_1,jAddr_2,Jump_2,bAddr_2,Branch_2,Zero_2,npc_1);
	PC _PC(clk,rst,npc_1,pcwrite,pc_1);
	im_4k _IM(pc_1[11:2],instr_1);

		//  IF/ID寄存器
	if_id _fd(clk,if_flush,ifwrite,pc_four_1,instr_1,pc_four_2,instr_2);


	//module DUnit
		//将指令切分
	assign op_2 = instr_2[31:26];
	assign rs_2 = instr_2[25:21];  
    assign rt_2 = instr_2[20:16];  
    assign rd_2 = instr_2[15:11];
    assign imm16_2 = instr_2[15:0];
    assign func_2 = instr_2[5:0];
    assign jAddr_2 = {pc_four_2[31:28],instr_2[25:0],2'b00};
    assign bAddr_2=pc_four_2+{{14{imm16_2[15]}},imm16_2,2'b00};//计算branch转移地址

    ctrl _ctrl(op_2,func_2,ExtOp_2,ALUSrc_2,ALUctr_2,RegDst_2,MemWr_2,Branch_2,Jump_2,MemtoReg_2,RegWr_2,MemRead_2);
    RFile _RFile(clk,RegWr_5,rs_2,rt_2,rw_5,Di_5,busA_2,busB_2);
    LoadUse LU(MemRead_3,rt_2,rt_3,rs_2,stall,pcwrite,ifwrite);	//loaduse检测
    always @(*)
	begin
	if(busA_2 - busB_2 == 0)
	begin
		Zero_2 = 1;
	end
	else begin
	 	Zero_2 = 0;
	 end

	if_flush=(Zero_2&Branch_2)||Jump_2;	
	end

   		 //   ID/EX寄存器
 	id_ex _dx(clk,stall,pc_four_2,imm16_2,busA_2,busB_2,rt_2,rd_2,ExtOp_2,ALUSrc_2,RegDst_2,MemWr_2,MemtoReg_2,RegWr_2,MemRead_2,ALUctr_2,rs_2,
	pc_four_3,imm16_3,busA_3,busB_3,rt_3,rd_3,ExtOp_3,ALUSrc_3,RegDst_3,MemWr_3,MemtoReg_3,RegWr_3,MemRead_3,ALUctr_3,rs_3);

	//module EUnit
		//zhuan fa Unit
	ZHF _ZHF(RegWr_4,rd_4,RegWr_5,rd_5,rs_3,rt_3,ALUSrc_3,ALUSrcA_3,ALUSrcB_3);
		//mux for A_3
	always @(*) 
	begin
		
		case(ALUSrcA_3)
			2'b00: A_3 = busA_3;
			2'b01: A_3 = ALUout_4;
			2'b10: A_3 = Di_5;
		endcase
	end
		//mux for B_3
	always @(*)
	begin
		case(ALUSrcB_3)
			2'b00: B_3 = busB_3;
			2'b01: B_3 = ALUout_4;
			2'b10: B_3 = Di_5;
			2'b11: B_3 = imm32_3;
		endcase
	end
	assign rw_3 = RegDst_3 ? rd_3 : rt_3;
	immExtend _iE(imm16_3,ExtOp_3,imm32_3);
	ALU _ALU(A_3,B_3,ALUctr_3,ALUout_3);
		// Ex/Mem
	ex_me _xm(clk,ALUout_3,busB_3,rw_3,MemWr_3,MemtoReg_3,RegWr_3,rd_3,
	ALUout_4,busB_4,rw_4,MemWr_4,MemtoReg_4,RegWr_4,rd_4);

	//module MUnit

	dm_4k _DM(ALUout_4[11:2],busB_4,MemWr_4,clk,Do_4);

		// Mem/Wr
	me_wr _er(clk,Do_4,ALUout_4,rw_4,MemtoReg_4,RegWr_4,rd_4,
	Do_5,ALUout_5,rw_5,MemtoReg_5,RegWr_5,rd_5);

	//module WUnit
	
	assign Di_5 = MemtoReg_5 ? Do_5:ALUout_5;

endmodule