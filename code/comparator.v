module comparator(branch_type, a, b, result);
    input branch_type;
    input [31:0] a, b;
    output reg result;

    //*******branch type*******//
    parameter beq = 3'b000, bne = 3'b001, bgez = 3'b010, bgtz = 3'b011, blez = 3'b100, bltz = 3'b101;
  
    always @(*)
    begin
        if(  (branch_type == beq  && a == b)
          || (branch_type == bne  && a != b)
          || (branch_type == bgez && a >= b)
          || (branch_type == bgtz && a > b)
          || (branch_type == blez && a <= b)
          || (branch_type == bltz && a < b) 
          )
        begin
            result <= 1'b1;
        end
        else 
        begin
            result <= 1'b0;
        end
      
    end

endmodule //comparator
