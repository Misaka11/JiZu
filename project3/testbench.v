module testbench();
	reg clk,rst;	//时钟信号，重置信号

	initial begin
		clk = 0; 
		rst = 1;
		#20 rst = 0;
	end

	always #10 clk = ~clk;
	mips _mips(clk,rst);

endmodule