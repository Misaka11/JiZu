module dm_4k(addr, din, wr, read, clk, dout);
	input clk;
	input [1:0] wr;
	input [2:0] read;
	input [11:2] addr;
	input [31:0] din;
	output reg [31:0] dout;

	
	//*******MemRead*******//
    parameter lb = 3'b001, lbu = 3'b010, lh = 3'b011, lhu = 3'b100, lw = 3'b101;

    //*******MemWr*******//
    parameter noWr = 2'b00, sb = 2'b01, sh = 2'b10, sw = 2'b11;

	reg [31:0] dm[1023:0];
	integer i;
	initial
		begin
		dout = 32'b0;
		for(i=0;i<=1023;i=i+1)
			dm[i]=32'b0;
		end


	always @(posedge clk)
	begin
		//MemRead
		case(read)
			lb:
			begin
				dout = {{24{dm[addr[11:2]][7]}}, dm[addr[11:2]][7:0]};
			end
			lbu:
			begin
				dout = {{24{1'b0}}, dm[addr[11:2]][7:0]};
			end
			lh:
			begin
				dout = {{16{dm[addr[11:2]][15]}}, dm[addr[11:2]][15:0]};
			end
			lhu:
			begin
				dout = {{16{1'b0}}, dm[addr[11:2]][15:0]};
			end
			lw:
			begin
				dout = dm[addr[11:2]];
			end
			default:
			begin
				dout = dm[addr[11:2]];
			end
		endcase // read

		//MemWr
		case(wr)
			sb:
			begin
				dm[addr[11:2]][7:0] = din[7:0];
			end
			sh:
			begin
				dm[addr[11:2]][15:0] = din[15:0];
			end
			sw:
			begin
				dm[addr[11:2]] = din;
			end
		endcase // wr

	end

endmodule




