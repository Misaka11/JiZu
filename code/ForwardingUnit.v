module ForwardingUnit(rs_reg, rt_reg, rs_IDEx, rt_IDEx, rw_ExMem, rw_MemWB, RegWr_ExMem, RegWr_MemWB, ALUSrc_IDEx, ForwardA, ForwardB, ForwardB2, ForwardC, ForwardD);
	input [4:0] rs_IDEx, rt_IDEx, rw_ExMem, rw_MemWB, rs_reg, rt_reg;
	input RegWr_ExMem, RegWr_MemWB, ALUSrc_IDEx;

	output reg [1:0] ForwardA, ForwardB, ForwardB2, ForwardC, ForwardD;

	always @(*)
	begin

	//ForwardA
	if(RegWr_ExMem && (rw_ExMem != 5'b00000) && (rw_ExMem == rs_IDEx))
	begin
		ForwardA <= 2'b10;
	end
	else if(RegWr_MemWB && (rw_MemWB != 5'b00000) && (rw_MemWB == rs_IDEx))
	begin
		ForwardA <= 2'b01;
	end
	else
	begin
		ForwardA <= 2'b00;
	end

	//ForwardB
	if(!ALUSrc_IDEx && RegWr_ExMem && (rw_ExMem != 5'b00000) && (rw_ExMem == rt_IDEx))
	begin
		ForwardB <= 2'b10;
	end
	else if(!ALUSrc_IDEx && RegWr_MemWB && (rw_MemWB != 5'b00000) && (rw_MemWB == rt_IDEx))
	begin
		ForwardB <= 2'b01;
	end
	else
	begin
		ForwardB <= 2'b00;
	end
	
	//ForwardB2
	if(RegWr_ExMem && (rw_ExMem != 5'b00000) && (rw_ExMem == rt_IDEx))
	begin
		ForwardB2 <= 2'b10;
	end
	else if(RegWr_MemWB && (rw_MemWB != 5'b00000) && (rw_MemWB == rt_IDEx))
	begin
		ForwardB2 <= 2'b01;
	end
	else
	begin
		ForwardB2 <= 2'b00;
	end

	//ForwardC
	if(RegWr_ExMem && (rw_ExMem != 5'b00000) && (rw_ExMem == rs_reg))
	begin
		ForwardC <= 2'b10;
	end
	else if(RegWr_MemWB && (rw_MemWB != 5'b00000) && (rw_MemWB == rs_reg))
	begin
		ForwardC <= 2'b01;
	end
	else
	begin
		ForwardC <= 2'b00;
	end

	//ForwardD
	if(RegWr_ExMem && (rw_ExMem != 5'b00000) && (rw_ExMem == rt_reg))
	begin
		ForwardD <= 2'b10;
	end
	else if(RegWr_MemWB && (rw_MemWB != 5'b00000) && (rw_MemWB == rt_reg))
	begin
		ForwardD <= 2'b01;
	end
	else
	begin
		ForwardD <= 2'b00;
	end
	
	end

endmodule // ForwardingUnit

