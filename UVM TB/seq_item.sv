class seq_item extends uvm_sequence_item;
  
randc	bit	signed [4:0]	A;
randc 	bit	signed [4:0]	B;
rand	bit					ALU_en;
rand	bit					a_en;
rand	bit	[2:0]			a_op;
rand	bit					b_en;
rand	bit	[1:0]			b_op;
//output
logic	  	signed [5:0]	C;

function new(string name = "seq_item");
    super.new(name);
endfunction

// UTILITY AND FIELD MACROS 
`uvm_object_utils_begin(seq_item)  
	`uvm_field_int(A,UVM_ALL_ON)
	`uvm_field_int(B,UVM_ALL_ON)
	`uvm_field_int(a_en,UVM_ALL_ON)
	`uvm_field_int(b_en,UVM_ALL_ON)
	`uvm_field_int(a_op,UVM_ALL_ON)
	`uvm_field_int(b_op,UVM_ALL_ON)
	`uvm_field_int(ALU_en,UVM_ALL_ON)
`uvm_object_utils_end 
	

//******************CONSTRAINTS****************
// ALU_en is high in a soft cosntraint 
constraint alu_enable {  ALU_en ==1'b1;}
// A and B have range of values [-15:15]
constraint B_values {B inside {[-15:15]};}
constraint A_values {A inside {[-15:15]};}
// a_op = 7 is illegal
constraint a_operation { a_op inside {[0:6]};}
// b_op = 3 is illegal when b_en is the only asserted enable
constraint b_operation { (!a_en &b_en) -> b_op inside {[0:2]};}

  virtual function void direct_test(bit  case_num);
	ALU_en =1;
	case (case_num)
	0	:	begin // almost minimum value of C (-30) 6'b1000_10
				A = 5'b10001; // -15
				B = 5'b10001; // -15
				a_en = 1;
				b_en = 0;
				a_op = 0;	// addition
				b_op = 0;
				end
	1	:	begin // almost maximum value of C (30) 6'b011110
				A = 5'b01111; 
				B = 5'b01111; 
				a_en = 1;
				b_en = 0;
				a_op = 3'b000;	// adding 15 with 15 to get 30 to hit maximum value of arthematic op
				b_op = 0;
				end	

	endcase 
endfunction

endclass