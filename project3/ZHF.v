module ZHF(RegWr_4,rd_4,RegWr_5,rd_5,rs_3,rt_3,ALUSrc_4,ALUSrcA_3,ALUSrcB_3);
	input RegWr_4,RegWr_5,ALUSrc_4;
	input[4:0] rd_4,rd_5,rs_3,rt_3;
	output reg[1:0] ALUSrcA_3,ALUSrcB_3;
	reg c1a,c2a,c1b,c2b;
	

	always @(RegWr_4 or rd_4 or rd_5 or rs_3 or rt_3 or RegWr_5 or c1a or c2a or c1b or c2b or ALUSrc_4) begin
		c1a <= RegWr_4 & (rd_4 != 0) & (rd_4 == rs_3);
		c2a <= RegWr_5 & (rd_5 != 0) & (rd_4 != rs_3) & (rd_5 == rs_3);
		c1b <= RegWr_4 & (rd_4 != 0) & (rd_4 == rt_3);
		c2b <= RegWr_5 & (rd_5 != 0) & (rd_4 != rt_3) & (rd_5 == rt_3);
		if(c1a)
		begin
		ALUSrcA_3[0]<=1;
	    ALUSrcA_3[1]<=0;
	    end
	    else if(c2a)
	    begin
	    ALUSrcA_3[0]<=0;
	    ALUSrcA_3[1]<=1;
	    end
	    else if(c1a!=1&&c2a!=1)
	    begin
	    ALUSrcA_3[0]<=0;
	    ALUSrcA_3[1]<=0;
	    end
	    
	    if(c1b)
	    begin
	    ALUSrcB_3[0]<=1;
	    ALUSrcB_3[1]<=0;	
	    end
	    else if(c2b)
	    begin
	    ALUSrcB_3[0]=0;
	    ALUSrcB_3[1]=1;	
	    end
	    else if(c1b!=1&&c2b!=1)
	    begin
	       if(ALUSrc_4)
	         begin
	         ALUSrcB_3[0]=1;
	         ALUSrcB_3[1]=1;	
	         end
	       else
	         begin
	         ALUSrcB_3[0]=0;
	         ALUSrcB_3[1]=0;	
	         end
	    end
	end
	

endmodule