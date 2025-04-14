interface alu_intf (input clk,rst_n);

//inputs 
bit	signed [4:0]	A;
bit signed [4:0]	B;
bit					ALU_en;
bit					a_en;
bit		  [2:0]		a_op;
bit					b_en;
bit	      [1:0]		b_op;

//output 
logic signed [5:0]	C;

	
//Directions of Driver and Monitor Classes

modport Driver (output a_en,b_en,ALU_en,a_op,b_op,A,B,
				input C,clk,rst_n);

modport Monitor_in (input clk,rst_n,ALU_en,a_en,a_op,b_en,b_op,A,B);

modport Monitor_out (input clk,rst_n,C);


//**************************ASSERTIONS**************************
// 1) RESET
property reset_checking;
	@(posedge clk)
	!rst_n |-> C==0;
endproperty 
assert property(reset_checking)
else $display ("[ASSERTION ERROR]:: RESET STATE IS VIOLATED AT %0t ns",$time);

RESET_CHECKING:cover property(reset_checking);

// 2) OUTPUT HAS NOT X OR Z value
property output_validation;
      @(posedge clk)
 	  $isunknown(C) == 0;
endproperty
assert property(output_validation)
else $display ("[ASSERTION ERROR]:: OUTPUT_VALIDATION IS VIOLATED AT %0t ns",$time);
OUTPUT_VALIDATION:cover property(output_validation);

// 3) CHECKING WHEN A AND b ENABLE IS OFF , OUTPUT WILL NOT CHANGE
property output_stable;
	@(negedge clk) disable iff(!rst_n)
	ALU_en |-> (!a_en && !b_en) |-> $stable(C);
endproperty
assert property(output_stable)
	else $display ("[ASSERTION ERROR]:: OUTPUT_STABLE IS VIOLATED AT %0t ns",$time);
OUTPUT_STABLE:cover property(output_stable);

// 4) CHECKING THAT C DOESN'T HAS -32 VALUE
property output_range;
	@(negedge clk) disable iff(!rst_n)
	ALU_en |-> (C != -32);
endproperty
assert property(output_range)
	else $display ("[ASSERTION ERROR]:: OUTPUT_RANGE IS VIOLATED AT %0t ns",$time);
OUTPUT_RANGE:cover property(output_range);

// 5) CHECKING CASE NO. 7 OF a_op NOT TRIGGERED 
property illegal_a_op;
	@(posedge clk)
	a_op!=7;
endproperty
assert property (illegal_a_op)
	else $fatal(1,"[ASSERTION FAILED]::a_op hits 7 at %0t",$time);
ILLEGAL_A_OPERATION:cover property (illegal_a_op);

// 6) CHECKING CASE NO. 3 OF b_op IS NOT TRIGGERED WHEN b_en IS THE ONLY HIGH ENABLE 
property illegal_b_op;
	@(posedge clk)
	(!a_en & b_en) |-> b_op!=3;
endproperty
assert property (illegal_b_op) 
	else $fatal(1,"[ASSERTION FAILED]::b_op hits 3 when b_en is only high at %0t",$time);
ILLEGAL_B_OPERATION:cover property (illegal_b_op);

// 7) CHECKING THAT A IS NOT RANDOMIZED TO -16
property A_range;
	@(negedge clk) disable iff(!rst_n)
	ALU_en |-> (A != -16);
endproperty
assert property(A_range)
	else $display ("[ASSERTION ERROR]:: A_RANGE IS VIOLATED AT %0t ns",$time);
A_RANGE:cover property(A_range);

// 8) CHECKING THAT B IS NOT RANDOMIZED TO -16
property B_range;
	@(negedge clk) disable iff(!rst_n)
	ALU_en |-> (B != -16);
endproperty
assert property(B_range)
	else $display ("[ASSERTION ERROR]:: B_RANGE IS VIOLATED AT %0t ns",$time);
B_RANGE:cover property(B_range);

endinterface 
