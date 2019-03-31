module RFile(clk,RegWr,rs,rt,rw,Di,result1,result2);
	input clk,RegWr; 		 	//RegWr 写使能
	input[4:0] rs,rt,rw;	//RFile的三个寄存器
	input[31:0] Di;	    	//dm或alu送来的数据
	output[31:0] result1,result2;	//输出的两个数据
	reg[31:0] registers[31:0];

	//initial
	integer i;
	initial begin
		for(i = 0;i<=31; i = i+1)
			registers[i] = 0;
	end

	//output
	assign result1 = registers[rs];
	assign result2 = registers[rt];

	//input
	always @(negedge clk) begin
		if(RegWr && rw) registers[rw] <= Di; //防止写数据进入0号寄存器
	end

endmodule