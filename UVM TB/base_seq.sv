class base_seq extends uvm_sequence#(seq_item);
seq_item req1;
`uvm_object_utils(base_seq)

function new (string name = "base_seq");
super.new(name);
endfunction

int no_stimuls =100; //default 100 repeats 
//bit i;
virtual task body();
	repeat (no_stimuls) begin
	 //`uvm_do(req1);
		req1 = seq_item::type_id::create("req1");
		start_item(req1);
		assert(req1.randomize()) else `uvm_fatal(get_type_name(),"Failed to randomize");
		finish_item(req1);
	end 
endtask
endclass