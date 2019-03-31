module mux2(x, y, s, z);
	input [31:0] x, y;
	input s;
	output [31:0] z;

	assign z = (s==1)?y:x;
endmodule

module mux2_3(x, y, s, z);
	input [2:0] x, y;
	input s;
	output [2:0] z;
	assign z = (s==1)?y:x;
endmodule

module mux2_1(x, y, s, z);
  input x, y;
	input s;
	output z;

	assign z = (s==1)?y:x;
endmodule

module mux2_2(x, y, s, z);
  	input [1:0] x, y;
	input s;
	output [1:0] z;

	assign z = (s==1)?y:x;
endmodule

module mux3_32(x, y, z, s, dout);
  input [31:0] x, y, z;
  input [1:0] s;
  output [31:0] dout;
  
  wire [31:0] temp;
  
  assign temp = (s[0:0] == 0)?x:y;
  assign dout = (s[1:1] == 0)?temp:z;
endmodule



