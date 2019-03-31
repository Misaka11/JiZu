module dm_4k(addr, din, we, clk, dout);
    input[11:2] addr;  // address bus
    input[31:0] din;   // 32-bit input data
    input we;    // memory write enable
    input clk;   // clock
	output[31:0] dout;  // 32-bit memory output
	reg[31:0] dm[1023:0];

	//read data
	assign dout = dm[addr];

	//write data
	always @(negedge clk) begin
		if(we) dm[addr] <= din;
	end

	//initial
	integer i;
	initial begin
		for(i = 0;i<=1023;i = i+1)
			dm[i] = 0;
	end
endmodule