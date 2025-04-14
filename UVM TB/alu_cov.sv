class alu_coverage extends uvm_component;
uvm_analysis_imp_MON_IN #(seq_item, alu_coverage) item_collect_export_in;
uvm_analysis_imp_MON_OUT #(seq_item, alu_coverage) item_collect_export_out;
seq_item item_q_in,item_q_out;
`uvm_component_utils(alu_coverage)

covergroup cg_enable;
cp_A_enable : coverpoint item_q_in.a_en;
cp_B_enable : coverpoint item_q_in.b_en;
cp_A_enable_X_cp_B_enable : cross cp_A_enable,cp_B_enable;
endgroup
//**********************INPUT DATA**********************
covergroup cg_data_inputs; 
cp_A : coverpoint item_q_in.A {
	bins	pos_A[]= {[1:15]};
	bins	neg_A[]= {[-15:0]};
	illegal_bins	A_out_of_range = {-16};
}

cp_B : coverpoint item_q_in.B {
	bins	pos_B[]= {[1:15]};
	bins	neg_B[]= {[-15:0]};
	illegal_bins	B_out_of_range = {-16};
}
endgroup
//**********************OPERATIONS**********************
covergroup cg_operations;
//	Coverage of a operation when a_en is high and b_en is low 
cp_a_op : coverpoint item_q_in.a_op iff(item_q_in.a_en && !item_q_in.b_en) 
{
	bins	a_op[] = {[0:6]};
	illegal_bins	op_a_out_of_range = {7};
}
//	Coverage of b operation when a_en is high and b_en is high
cp_b_op : coverpoint item_q_in.b_op iff (item_q_in.a_en&&item_q_in.b_en)
{
	bins	b_op[]={[0:3]};
}
//	Coverage of b operation when a_en is low and b_en is high
cp_b_op_exception : coverpoint item_q_in.b_op iff(item_q_in.b_en && !item_q_in.a_en)
{
	bins	b_op[] = {[0:2]};
	illegal_bins	b_op_out_of_range = {3};
}
endgroup
//**********************OUTPUT**********************
covergroup cg_output;
cp_output : coverpoint item_q_out.C {
	bins	all_zeros = {0};
	bins	all_ones = {-1};
	bins	almost_min_boundry = {-30};
	bins	almost_max_boundry = {30};
	bins	others[] = default;
	illegal_bins	min_boundries = {-32,-31}; // out of wanted range
	illegal_bins	max_boundry = {31}; // cannot be reached either by arthematic or logical operators
}
endgroup 


function new(string name = "alu_coverage", uvm_component parent = null);
super.new(name, parent);
	item_collect_export_in = new("item_collect_export_in", this);
	item_collect_export_out = new("item_collect_export_out", this);
	cg_data_inputs=new();
	cg_enable = new();
	cg_data_inputs = new();
	cg_operations = new();
	cg_output = new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

function void write_MON_IN(seq_item req);
	item_q_in=req;
	cg_enable.sample();
	cg_data_inputs.sample();
	cg_operations.sample();
endfunction 

function void write_MON_OUT(seq_item req);
	item_q_out=req;
	cg_output.sample();
endfunction

endclass


