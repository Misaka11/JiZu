module reg_IFID(clk, rst, wr, flush, pc_4_in, instr_in, pc_4_out, instr_out);
	input clk, rst;
	input wr, flush;
	input [31:0] pc_4_in;
	input [31:0] instr_in;

	output [31:0] pc_4_out;
	output [31:0] instr_out;

	reg [31:0] pc_4_out;
	reg [31:0] instr_out;

	initial 
	begin 
		pc_4_out <= 32'h00000000;
		instr_out <= 32'h00000000;
	end

	always @(negedge clk)
	begin
		if(rst) 
		begin
			 pc_4_out <= 32'h00000000;
			instr_out <= 32'h00000000;
		end 

		else if(wr)
		begin
			 pc_4_out <= pc_4_in;
			 instr_out <= instr_in;
		end
		
		if(flush)
		begin
		  pc_4_out <= 32'h00000000;
		  instr_out <= 32'h00000000;
		end
	end

endmodule // reg_IFID



module reg_IDEx(clk, rst, pc_4_in, data1_in, data2_in, ExtImmi_in, rs_in, rd_in, rt_in, ALUctr_in, 
				RegDst_in, RegWr_in, MemWr_in, MemRead_in, MemtoReg_in, Extop_in, ALUSrc_in, branch_in, jump_in,
				pc_4_out, data1_out, data2_out, ExtImmi_out, rs_out, rd_out, rt_out, ALUctr_out,
				RegDst_out, RegWr_out, MemWr_out, MemRead_out, MemtoReg_out, Extop_out, ALUSrc_out, branch_out, jump_out);

	input clk, rst;
	input RegDst_in, RegWr_in, MemtoReg_in, Extop_in, ALUSrc_in, branch_in, jump_in;
	input [1:0] MemWr_in;
	input [2:0] MemRead_in;
	input [4:0] ALUctr_in;
	input [4:0] rs_in, rd_in, rt_in;
	input [31:0] pc_4_in, data1_in, data2_in, ExtImmi_in;

	output reg RegDst_out, RegWr_out, MemtoReg_out, Extop_out, ALUSrc_out, branch_out, jump_out;
	output reg [1:0] MemWr_out;
	output reg [2:0] MemRead_out;
	output reg [4:0] ALUctr_out;
	output reg [4:0] rs_out, rd_out, rt_out;
	output reg [31:0] pc_4_out, data1_out, data2_out, ExtImmi_out;

  initial
  begin
    RegDst_out <= 1'b0;
		RegWr_out <= 1'b0;
		MemWr_out <= 2'b00;
		MemtoReg_out <= 1'b0;
		Extop_out <= 1'b0;
		ALUSrc_out <= 1'b0;
		branch_out <= 1'b0;
		jump_out <= 1'b0;
		MemRead_out <= 3'b000;
		ALUctr_out <= 5'b00000;
		rs_out <= 5'b00000;
		rd_out <= 5'b00000;
		rt_out <= 5'b00000;
		pc_4_out <= 32'h00000000;
		data1_out <= 32'h00000000;
		data2_out <= 32'h00000000;
		ExtImmi_out <= 32'h00000000;
	end
			
  
	always @(negedge clk)
	begin
		if(rst)
		begin
			RegDst_out <= 1'b0;
			RegWr_out <= 1'b0;
			MemWr_out <= 2'b00;
			MemtoReg_out <= 1'b0;
			Extop_out <= 1'b0;
			ALUSrc_out <= 1'b0;
			branch_out <= 1'b0;
			jump_out <= 1'b0;
			MemRead_out <= 3'b000;
			ALUctr_out <= 5'b00000;
			rs_out <= 5'b00000;
			rd_out <= 5'b00000;
			rt_out <= 5'b00000;
			pc_4_out <= 32'h00000000;
			data1_out <= 32'h00000000;
			data2_out <= 32'h00000000;
			ExtImmi_out <= 32'h00000000;
		end 

		else 
		begin
			RegDst_out <= RegDst_in;
			RegWr_out <= RegWr_in;
			MemWr_out <= MemWr_in;
			MemtoReg_out <= MemtoReg_in;
			Extop_out <= Extop_in;
			ALUSrc_out <= ALUSrc_in;
			branch_out <= branch_in;
			jump_out <= jump_in;
			MemRead_out <= MemRead_in;
			ALUctr_out <= ALUctr_in;
			rs_out <= rs_in;
			rd_out <= rd_in;
			rt_out <= rt_in;
			pc_4_out <= pc_4_in;
			data1_out <= data1_in;
			data2_out <= data2_in;
			ExtImmi_out <= ExtImmi_in;
		end
	end
endmodule // reg_IDEx



module reg_ExMem(clk, rst, RegWr_in, branch_in, MemWr_in, MemRead_in, MemtoReg_in, zero_in, HI_Wr_in, LO_Wr_in,
				pc_result_in, ALU_result_in, data2_in, HI_result_in, LO_result_in, rw_in,
				RegWr_out, branch_out, MemWr_out, MemRead_out, MemtoReg_out, zero_out, HI_Wr_out, LO_Wr_out,
				pc_result_out, ALU_result_out, data2_out, HI_result_out, LO_result_out, rw_out);

	input clk, rst;
	input RegWr_in, branch_in, MemtoReg_in, zero_in, HI_Wr_in, LO_Wr_in;
	input [1:0] MemWr_in;
	input [2:0] MemRead_in;
	input [31:0] pc_result_in, ALU_result_in, data2_in, HI_result_in, LO_result_in;
	input [4:0] rw_in;

	output reg RegWr_out, branch_out, MemtoReg_out, zero_out, HI_Wr_out, LO_Wr_out;
	output reg [1:0] MemWr_out;
	output reg [2:0] MemRead_out;
	output reg [31:0] pc_result_out, ALU_result_out, data2_out, HI_result_out, LO_result_out;
	output reg [4:0] rw_out;

  	initial
  	begin
			RegWr_out <= 1'b0;
			HI_Wr_out <= 1'b0;
			LO_Wr_out <= 1'b0;
			MemWr_out <= 2'b00;
			MemRead_out <= 3'b000;
			MemtoReg_out <= 1'b0;
			branch_out <= 1'b0;
			zero_out <= 1'b0;
			pc_result_out <= 32'h00000000;
			ALU_result_out <= 32'h00000000;
			data2_out <= 32'h0000;
			HI_result_out <= 32'b0;
			LO_result_out <= 32'b0;
			rw_out <= 5'b00000;
	end

	always @(negedge clk)
	begin
		if(rst)
		begin
			RegWr_out <= 1'b0;
			HI_Wr_out <= 1'b0;
			LO_Wr_out <= 1'b0;
			MemWr_out <= 2'b00;
			MemRead_out <= 3'b000;
			MemtoReg_out <= 1'b0;
			branch_out <= 1'b0;
			zero_out <= 1'b0;
			pc_result_out <= 32'h00000000;
			ALU_result_out <= 32'h00000000;
			data2_out <= 32'h0000;
			HI_result_out <= 32'b0;
			LO_result_out <= 32'b0;
			rw_out <= 5'b00000;
		end

		else
		begin
			RegWr_out <= RegWr_in;
			HI_Wr_out <= HI_Wr_in;
			LO_Wr_out <= LO_Wr_in;
			MemWr_out <= MemWr_in;
			MemRead_out <= MemRead_in;
			MemtoReg_out <= MemtoReg_in;
			branch_out <= branch_in;
			zero_out <= zero_in;
			pc_result_out <= pc_result_in;
			ALU_result_out <= ALU_result_in;
			data2_out <= data2_in;
			HI_result_out <= HI_result_in;
			LO_result_out <= LO_result_in;
			rw_out <= rw_in;
		end
	end
endmodule


module reg_MemWB(clk, rst, RegWr_in, HI_Wr_in, LO_Wr_in, MemtoReg_in, dout_in, ALU_result_in, HI_result_in, LO_result_in, rw_in,
				RegWr_out, HI_Wr_out, LO_Wr_out, MemtoReg_out, dout_out, ALU_result_out, HI_result_out, LO_result_out, rw_out);

	input clk, rst;
	input RegWr_in, MemtoReg_in, HI_Wr_in, LO_Wr_in;
	input [31:0] dout_in, ALU_result_in, HI_result_in, LO_result_in;
	input [4:0] rw_in;

	output reg RegWr_out, MemtoReg_out, HI_Wr_out, LO_Wr_out;
	output reg [31:0] dout_out, ALU_result_out, HI_result_out, LO_result_out;
	output reg [4:0] rw_out;

  initial
  begin
			RegWr_out <= 1'b0;
			HI_Wr_out <= 1'b0;
			LO_Wr_out <= 1'b0;
			MemtoReg_out <= 1'b0;
			dout_out <= 32'h00000000;
			ALU_result_out <= 32'h00000000;
			HI_result_out <= 32'b0;
			LO_result_out <= 32'b0;
			rw_out <= 5'b00000;
	end

	always @(negedge clk)
	begin
		if(rst)
		begin
			RegWr_out <= 1'b0;
			HI_Wr_out <= 1'b0;
			LO_Wr_out <= 1'b0;
			MemtoReg_out <= 1'b0;
			dout_out <= 32'h00000000;
			ALU_result_out <= 32'h00000000;
			HI_result_out <= 32'b0;
			LO_result_out <= 32'b0;
			rw_out <= 5'b00000;
		end

		else
		begin
			RegWr_out <= RegWr_in;
			HI_Wr_out <= HI_Wr_in;
			LO_Wr_out <= LO_Wr_in;
			MemtoReg_out <= MemtoReg_in;
			dout_out <= dout_in;
			ALU_result_out <= ALU_result_in;
			HI_result_out <= HI_result_in;
			LO_result_out <= LO_result_in;
			rw_out <= rw_in;
		end
	end
endmodule 



