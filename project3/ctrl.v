//各信号行为要参考课本166页表5.4，167页表5.5，5.6
module ctrl(op,func,ExtOp,ALUSrc,ALUctr,RegDst,MemWr,Branch,Jump,MemtoReg,RegWr,MemRead);
	input[5:0] op;
	input[5:0] func;
	output ExtOp,ALUSrc,RegDst,MemWr,Branch,Jump,MemtoReg,RegWr,MemRead;
	output reg[2:0] ALUctr;
	//op的7种类型
	parameter RTYPE = 6'b000000,ORI = 6'b001101,ADDIU = 6'b001001,
		LW = 6'b100011,SW = 6'b101011,BEQ = 6'b000100,JUMP = 6'b000010;
	reg i_r,i_ori,i_addiu,i_lw,i_sw,i_beq,i_jump;//中间变量，记录op状态
	always @(op) begin
		//初始化
		i_r = 0;
		i_ori = 0;
		i_addiu = 0;
		i_lw = 0;
		i_sw = 0;
		i_beq = 0;
		i_jump = 0;
		//记录op的状态并决定ALUctr行为
		case(op)
			RTYPE:
				begin
			 	i_r = 1;
			 	//如果是R型指令，根据func计算ALUctr
			 	ALUctr[2] = !func[2] & func[1];
				ALUctr[1] = func[3] & !func[2] & func[1];
				ALUctr[0] = !func[3] & !func[2] & !func[1] & !func[0]
					+ !func[2] & func[1] & !func[0];
				end 
			ORI: 
				begin
				i_ori = 1; assign ALUctr = 3'b010;
				end
			ADDIU:
				begin
				i_addiu = 1; assign ALUctr = 3'b000;
				end
			LW:
				begin
				i_lw = 1; assign ALUctr = 3'b000;
				end 
			SW: 
				begin 
				i_sw = 1; assign ALUctr = 3'b000;
				end
			BEQ:
				begin
				i_beq = 1; assign ALUctr = 3'b100;
				end 
			JUMP:
				begin
				 i_jump = 1; assign ALUctr = 3'b000;
				end 
		endcase
	end
	//根据op状态确定其它控制信号
//	assign R_type = i_r;
	assign MemRead = op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0];
	assign Branch = i_beq;
	assign Jump = i_jump;
	assign RegDst = i_r;
	assign ALUSrc = i_ori + i_addiu + i_lw + i_sw;
	assign MemtoReg = i_lw;
	assign RegWr = i_r + i_ori + i_addiu + i_lw;
	assign MemWr = i_sw;
	assign ExtOp = i_addiu + i_lw + i_sw;
endmodule