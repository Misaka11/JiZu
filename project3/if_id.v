module if_id(clk,if_flush,ifwrite,pc_four_1,instr_1,pc_four_2,instr_2);
	input clk,if_flush,ifwrite;
	input[31:0] pc_four_1,instr_1;
	output reg[31:0] pc_four_2,instr_2;
	initial
	begin
		pc_four_2 = 0;
		instr_2 = 0;
	end

	always @(negedge clk) begin
	if(ifwrite) begin
		pc_four_2 <= pc_four_1;
		instr_2 <= instr_1;
	end
	else if(if_flush)
		begin
			pc_four_2 <= 0;
			instr_2 <= 0;
		end
	end
endmodule