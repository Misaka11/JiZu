module immExtend(din,ExtOp,dout);
	input [15:0] din;		//16位数据
	input ExtOp;
	output [31:0] dout;		//32位数据
	wire[31:0] d1,d2;
	assign d1 = {{16{din[15]}},din};	//符号扩展
	assign d2 = {{16'b0},din};			//零扩展
	assign dout = ExtOp ? d1 : d2;
endmodule