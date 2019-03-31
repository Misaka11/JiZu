module testbench();
	reg clk, rst;

	initial
		begin 
			clk = 1'b0;
			rst = 1'b1;
			#20 rst = 1'b0;
		end

	always 
		#40 clk = ~clk;

	mips Mips(.clk(clk), .rst(rst));
endmodule



