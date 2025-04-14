module ALU(
	input						clk,
	input						rst_n,
	input						ALU_en,
	input						a_en,
	input						b_en,
	input			    [2:0]	a_op,
	input			    [1:0]	b_op,
	input      signed	[4:0]	A,
	input	   signed	[4:0]	B,
	output reg signed	[5:0]	C
);
//Sign extended signals of inputs to avoid wrong sign extendend of output
wire signed [5:0] a_ext , b_ext;
assign a_ext = {A[4],A}; 
assign b_ext = {B[4],B}; 

always_ff @(posedge clk or negedge rst_n) begin 
	if(!rst_n)
		C<=0;
	else if (ALU_en) begin
		if (b_en && a_en) begin
		case(b_op)
			2'b00	:	C<= ~(a_ext | b_ext);
			2'b01	:	C<= a_ext ~^ b_ext;
			2'b10	:	C<= a_ext - 1'b1;
			2'b11	:	C<= b_ext + 2'b10;
			endcase 
		end
		else if (a_en && !b_en) begin
			case(a_op) 
			3'b000	:	C<= a_ext+b_ext;
			3'b001	:	C<= a_ext-b_ext;
			3'b010	:	C<= a_ext^b_ext;
			3'b011	:	C<= a_ext&b_ext;
			3'b100	:	C<= a_ext& b_ext;
			3'b101	:	C<= a_ext|b_ext;
			3'b110	:	C<= a_ext ~^ b_ext;
            default : 	C<=0; 
			endcase
		end
		else if (b_en && !a_en) begin 
			case(b_op)
			2'b00	:	C<= ~(a_ext & b_ext);
			2'b01	:	C<= a_ext + b_ext;
			2'b10	:	C<= a_ext + b_ext;
            default	:   C<= 0;
			endcase 
		end 
	end 
end 
endmodule
			
