class direct_seq extends uvm_sequence#(seq_item);
seq_item req1;
`uvm_object_utils(direct_seq)

function new (string name = "direct_seq");
super.new(name);
endfunction

int dr_stimuls =4; //default 4 repeats 
bit i =0;
virtual task body();
	repeat (dr_stimuls) begin
		req1 = seq_item::type_id::create("req1");
		start_item(req1);
		req1.direct_test(i);
		i++;
		finish_item(req1);
	end 
endtask
endclass