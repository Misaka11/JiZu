module ALU(A,B,ALUctr,result);
	input[31:0] A,B;		//数据来源
	input[2:0] ALUctr;		//根据ALUctr进行相应操作
	output reg[31:0] result;	//计算结果
	initial begin
		result = 0;
	end
	//参照课本167页，根据ALUctr 相应执行 addu,subu,or,sltu
	always @(A or B or ALUctr) begin
		case(ALUctr)
			2'b000: result = A + B;
			2'b001: result = A + B;
			2'b010: result = A | B;
			//没有2'b011
			2'b100: result = A - B;
			2'b101: result = A - B;
			2'b110: result = (A < B);
			2'b111: result = (A < B);
		endcase
	end
endmodule