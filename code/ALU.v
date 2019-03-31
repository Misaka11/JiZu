module ALU(a, b, aluctr, zero, HI_wr, LO_wr, result, HI_result, LO_result);
	input [31:0] a, b;
	input [4:0] aluctr;
	reg   [63:0] mul_result;
	output reg [31:0] result, HI_result, LO_result;
	output zero;
	output reg HI_wr, LO_wr;


	//*******ALUctr******//
    parameter Add  = 5'b00000, Addu = 5'b00001, Sub  = 5'b00010, Subu = 5'b00011, Mul  = 5'b00100, 
    		  Mulu = 5'b00101, Div  = 5'b00110, Divu = 5'b00111, Slt  = 5'b01000, Sltu = 5'b01001, 
    		  And  = 5'b01010, Or   = 5'b01011, Xor  = 5'b01100, Nor  = 5'b01101, Lui  = 5'b01110, 
    		  Sll  = 5'b01111, Srl  = 5'b10000, Sra  = 5'b10001;

  initial
  begin
    mul_result = 64'b0;
    result = 32'b0;
    HI_result = 32'b0;
    LO_result = 32'b0;
  end

	assign zero = (result == 0)?1:0;
	always @ (a or b or aluctr)
		begin 
			HI_wr = 0;
			LO_wr = 0;

			case(aluctr)
				Add:
				begin 
					result = a + b;
				end
				Addu:
				begin
					result = a + b;
				end
				Sub:
				begin
					result = a - b;
				end
				Subu:
				begin
					result = a - b;
				end
				Mul:
				begin 
					mul_result = a*b;
					HI_result = mul_result[63:32];
					LO_result = mul_result[31:0];
					HI_wr = 1;
					LO_wr = 1;
				end
				Mulu:
				begin 
					mul_result = a*b;
					HI_result = mul_result[63:32];
					LO_result = mul_result[31:0];
					HI_wr = 1;
					LO_wr = 1;
				end
				Div:
				begin
					LO_result = a/b;
					HI_result = a%b;
					HI_wr = 1;
					LO_wr = 1;
				end
				Divu:
				begin
					LO_result = a/b;
					HI_result = a%b;
					HI_wr = 1;
					LO_wr = 1;
				end
				Slt:
				begin
					if(a<b)
						result = 32'b1;
					else
						result = 32'b0;
				end
				Sltu:
				begin
					if(a<b)
						result = 32'b1;
					else
						result = 32'b0;
				end
				And:
				begin
					result = a&b;
				end
				Or:
				begin
					result = a|b;
				end
				Xor:
				begin
					result = a^b;
				end
				Nor:
				begin
					result = a|b;
					result = ~result;
				end
				Lui:
				begin
					result = {b[15:0], 16'b0};
				end
				Sll:
				begin
					result = b<<a;
				end
				Srl:
				begin
					result = b>>a;
				end
				Sra:
				begin
					//result = {a{b[31]}, b[31:a]};
				end
			endcase 
		end

endmodule



