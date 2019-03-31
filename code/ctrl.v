module Control(ins, immi, op, func, ALUctr, rs, rt, rd, Branch, branch_type, Jump, RegDst, ALUsrc, MemtoReg, RegWr, MemWr, ExtOp, MemRead, JumpLink, JumpDst);

	input     [31:0] ins;
  
    output [5:0] op, func;
	output [15:0] immi;
	output [4:0] rs, rt, rd;

    assign op   = ins[31:26];
	assign func = ins[5:0];
	assign immi = ins[15:0];
	assign rs   = ins[25:21];
	assign rt   = ins[20:16];
	assign rd   = ins[15:11];
	
	
	output reg [4:0] ALUctr;
	output reg [2:0] branch_type;
	output reg [2:0] MemRead;
	output reg [1:0] MemWr;
	output reg 		 Branch;
	output reg 		 Jump;
	output reg    RegDst;
	output reg		  ALUsrc;//WrEn
	output reg 		 MemtoReg;
	output reg  	 RegWr;
	output reg 		 ExtOp;
	output reg 		 JumpLink;
	output reg 		 JumpDst;

	//*********op*********// ?R??
	parameter R     = 6'b000000, ADDI  = 6'b001000, ADDIU    = 6'b001001, LUI    = 6'b001111, SLTI = 6'b001010, 
			  SLTIU = 6'b001011, ANDI  = 6'b001100, ORI      = 6'b001101, XORI   = 6'b001110, BEQ  = 6'b000100, 
			  BNE   = 6'b000101, BGEZ  = 6'b000001, BGTZ     = 6'b000111, BLEZ   = 6'b000110, BLTZ = 6'b000001, //BLTZ==BGEZ
			  LW    = 6'b100011, SW    = 6'b101011, LB       = 6'b100000, LBU    = 6'b100100, SB   = 6'b101000, 
			  J     = 6'b000010, JAL   = 6'b000011, CP0_OP   = 6'b010000;/*{CP0_OP???SYSCALL}*/
	

	//********func********// op = 6'b000000, R??
    parameter ADD  = 6'b100000, ADDU = 6'b100001, SUB  = 6'b100010, SUBU = 6'b100011, SLT  = 6'b101010, 
      		  SLTU = 6'b101011, AND  = 6'b100100, NOR  = 6'b100111, DIVU = 6'b011010, DIV  = 6'b011011,
              OR   = 6'b100101, XOR  = 6'b100110, SLLV = 6'b000100, SRAV = 6'b000111, SRLV = 6'b000110, 
              SLL  = 6'b000000, SRL  = 6'b000010, SRA  = 6'b000011, JR   = 6'b001000, JALR = 6'b001001, 
              MUL  = 6'b011000, MULU = 6'b011001;

    //********Mul_func******// 
	parameter MFLO = 6'b010010, MFHI = 6'b010000,
			  MTLO = 6'b010011, MTHI = 6'b010001;

	//********CP0_func{?SYSCALL}******// op = 6'b000000
	parameter SYSCALL = 6'b001100;

    //*******ALUctr******//
    parameter Add  = 5'b00000, Addu = 5'b00001, Sub  = 5'b00010, Subu = 5'b00011, Mul  = 5'b00100, 
    		  Mulu = 5'b00101, Div  = 5'b00110, Divu = 5'b00111, Slt  = 5'b01000, Sltu = 5'b01001, 
    		  And  = 5'b01010, Or   = 5'b01011, Xor  = 5'b01100, Nor  = 5'b01101, Lui  = 5'b01110, 
    		  Sll  = 5'b01111, Srl  = 5'b10000, Sra  = 5'b10001, Nop  = 5'b00000;

    //*******branch type*******//
    parameter beq = 3'b000, bne = 3'b001, bgez = 3'b010, bgtz = 3'b011, blez = 3'b100, bltz = 3'b101;

    //*******MemRead*******//
    parameter lb = 3'b001, lbu = 3'b010, lh = 3'b011, lhu = 3'b100, lw = 3'b101;

    //*******MemWr*******//
    parameter noWr = 2'b00, sb = 2'b01, sh = 2'b10, sw = 2'b11;


    //*******Initial*****//
    initial begin
    	ALUctr		= 5'd0;
    	branch_type = 3'b0;
    	MemRead     = 3'b0;
    	MemWr       = 2'b0;
    	JumpLink	= 0;
    	JumpDst     = 0;
     	Branch		= 0;
    	Jump		= 0;
    	RegDst		= 0;
    	ALUsrc		= 0;
    	MemtoReg	= 0;
    	RegWr 	 	= 0;
    	ExtOp		= 0;
    end


    //******Always*******//
	always @(*)begin

		//???
		ALUctr      = 5'b0;
		branch_type = 3'b0;
		MemRead 	= 3'b0;
		MemWr 		= 2'b0;
		JumpDst 	= 0;
		JumpLink 	= 0;


		case (op)
			R:begin
				//JR
				if (func == JR) begin 
					Branch   = 0;
					Jump     = 1;
					RegDst   = 0;
					ALUsrc   = 0;
						
					MemtoReg = 0;
					RegWr    = 0;
					ExtOp    = 0;

					JumpDst  = 1;
				end 
				//JALR
				else if(func == JALR)
				begin
					Branch   = 0;
					Jump     = 1;
					RegDst   = 0;
					ALUsrc   = 0;
						
					MemtoReg = 0;
					RegWr    = 0;
					ExtOp    = 0;

					JumpDst  = 1;
					JumpLink = 1;
				end

				//----{mul}begin
				/*else if (func == MULT || func == MFLO || func == MFHI || func == MTLO || func == MTHI) begin
					Branch = 3'b000;
					Jump   = 2'b0;
					if (func == MFLO || func == MFHI) RegDst = 1; else RegDst = 0;
					ALUsrc = 0;
						
					MemtoReg = 0;
					if (func == MFLO || func == MFHI) RegWr  = 1; else RegWr  = 0;
					MemWr    = 2'b0;
					ExtOp    = 0;
					MemRead  = 2'b00;			
					ALUshf   = 0;
					ALUctr   = 3'b000;	
				end 
				//----{mul}end
				//----{cp0_SYSCALL}begin
				else if (func == SYSCALL) begin
					Branch = 3'b000;
					Jump   = 2'b0;
					RegDst = 0;
					ALUsrc = 0;
						
					MemtoReg = 0;
					RegWr    = 0;
					MemWr    = 2'b0;
					ExtOp    = 0;
					MemRead  = 2'b00;
					ALUshf   = 0;
					ALUctr   = 3'b000;
				end*/
				//----{cp0_SYSCALL}end

				//R else
				else begin
					Branch = 0;
					Jump   = 0;
					RegDst = 1;
					ALUsrc = 0;
						
					MemtoReg = 0;
					RegWr    = 1;
					ExtOp    = 0;
					
					case (func)
						ADD : ALUctr = Add;
						ADDU: ALUctr = Addu;
						SUB : ALUctr = Sub;
						SUBU: ALUctr = Subu;
						MUL : ALUctr = Mul;
						MULU: ALUctr = Mulu;
						DIV : ALUctr = Div;
						DIVU: ALUctr = Divu;
						SLT : ALUctr = Slt;
						SLTU: ALUctr = Sltu;
						AND : ALUctr = And;
						NOR : ALUctr = Nor;
						OR  : ALUctr = Or;
						XOR : ALUctr = Xor;
						SLL : ALUctr = Sll;
						SLLV: ALUctr = Sll;
						SRA : ALUctr = Sra;
						SRAV: ALUctr = Sra;
						SRL : ALUctr = Srl;
						SRLV: ALUctr = Srl;
						default: ALUctr = Nop;
					endcase 
				end
				//----{R_else}end
			end//end R

			//?R
			ADDI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 1;

				ALUctr   = Addu;
			end
			ADDIU:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 1;

				ALUctr   = Addu;
			end
			LUI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 0;

				ALUctr   = Lui;
			end 
			SLTI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 1;

				ALUctr   = Slt;
			end
			SLTIU:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 1;

				ALUctr   = Sltu;
			end
			ANDI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 0;

				ALUctr   = And;
			end
			ORI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 0;

				ALUctr   = Or;
			end
			XORI:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				ExtOp    = 0;

				ALUctr   = Xor;
			end
			BEQ:begin
				branch_type = beq;
				Branch   = 1;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;
			end
			BNE:begin
				branch_type = bne;
				Branch   = 1;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;
			end
			BGEZ:begin//BLTZ==BGEZ???????????
				if (rt == 5'b00001)      branch_type = bgez; 
				else if (rt == 5'b00000) branch_type = bltz;  
				Branch   = 1;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;		
			end
			BGTZ:begin
				branch_type = bgtz;
				Branch   = 1;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;
			end
			BLEZ:begin
				branch_type = blez;
				Branch   = 1;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;
			end
			LW:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				ExtOp    = 1;

				MemRead  = lw;
				ALUctr   = Addu;
			end
			SW:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;

				MemWr    = sw;
				ALUctr   = Addu;
			end
			LB:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				ExtOp    = 1;

				MemRead  = lb;
				ALUctr   = Addu;
			end
			LBU:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				ExtOp    = 1;

				MemRead  = lbu;
				ALUctr   = Addu;
			end
			SB:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 1;

				MemWr    = sb;
				ALUctr   = Addu;
			end
			J:begin
				Branch   = 0;
				Jump     = 1;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 0;

				JumpDst  = 0;
				JumpLink = 0;
			end
			JAL:begin
				Branch   = 0;
				Jump     = 1;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 0;

				JumpLink = 1;
			end
			/*CP0_OP:begin
				Branch   = 3'b000;
				Jump     = 2'b00;
				RegDst   = 0;//rt
				ALUsrc   = 0;
					
				MemtoReg = 0;
				if (cp0Op == 3'b001) RegWr = 1; else RegWr = 0;
				MemWr    = 2'b00;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;				
			end*/
			default:begin
				Branch   = 0;
				Jump     = 0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				ExtOp    = 0;

				ALUctr   = Nop;				
			end
		endcase
	end
endmodule 