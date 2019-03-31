module HazardDetectionUnit(rs_IFID, rt_IFID, rt_IDEx, rw_Ex, rw_ExMem, RegWr_IDEx, MemtoReg_IDEx, MemtoReg_ExMem, branch_ID, stall, PC_Wr, IFID_Wr, ctrl_Wr);
	input [4:0] rs_IFID, rt_IFID, rt_IDEx, rw_Ex, rw_ExMem;
	input RegWr_IDEx, MemtoReg_IDEx, MemtoReg_ExMem, branch_ID;

	output PC_Wr, IFID_Wr, ctrl_Wr, stall;

	reg stall;

	always @(*)
	begin
		//load use hazard
		if(MemtoReg_IDEx && ((rt_IDEx == rs_IFID) || (rt_IDEx == rt_IFID)))
		begin
			stall <= 1'b1;
		end
		//branch hazard
		else if(branch_ID && ( (RegWr_IDEx && (rw_Ex == rs_IFID || rw_Ex == rt_IFID))
							|| (MemtoReg_ExMem && (rw_ExMem == rs_IFID || rw_ExMem == rt_IFID))
							|| (MemtoReg_IDEx && (rw_Ex == rs_IFID || rw_Ex == rt_IFID)))) 
		begin
			stall <= 1'b1;
		end
		else 
		begin
			stall <= 1'b0;
		end
	end

	assign PC_Wr = ~stall;
	assign IFID_Wr = ~stall;
	assign ctrl_Wr = ~stall;
endmodule // HazardDetectionUnit


