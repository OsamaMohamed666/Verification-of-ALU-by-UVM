`uvm_analysis_imp_decl(_MON_IN)
`uvm_analysis_imp_decl(_MON_OUT)
class alu_scoreboard extends uvm_scoreboard;
uvm_analysis_imp_MON_IN #(seq_item, alu_scoreboard) item_collect_export_in;
uvm_analysis_imp_MON_OUT #(seq_item, alu_scoreboard) item_collect_export_out;
seq_item item_in[$],item_out[$];
`uvm_component_utils(alu_scoreboard)

function new(string name = "alu_scoreboard", uvm_component parent = null);
	super.new(name, parent);
	item_collect_export_in = new("item_collect_export_in", this);
	item_collect_export_out = new("item_collect_export_out", this);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

function void write_MON_IN(seq_item req);
	item_in.push_back(req);
endfunction
 
function void write_MON_OUT(seq_item req);
	item_out.push_back(req);
endfunction

// externs functions 
extern function logic signed [5:0] A_operation(logic signed [4:0]A,B,logic signed [2:0] op);
extern function logic signed [5:0] B_operation(logic signed [4:0]A,B,logic signed [2:0] op);
extern function logic signed [5:0] AB_operation(logic signed [4:0]A,B,logic signed [2:0] op);

int cnt_crr,cnt_err; // counter for correct and incorrect outputs

virtual task run_phase (uvm_phase phase);
bit signed [5:0] out_tmp, out_exp; 
seq_item sb_item;

forever begin
	//EXTRACTING THE INPUT 
	wait(item_in.size > 0); 
	sb_item = item_in.pop_front();
	$display("----------------------------------------------------------------------------------------------------------");
	// A_EN AND B_EN OPERATIONS
	if (sb_item.b_en && sb_item.a_en) begin
		out_exp = AB_operation(sb_item.A, sb_item.B, sb_item.b_op);
		`uvm_info(get_type_name(), $sformatf("Expected data is %0b", out_exp), UVM_MEDIUM);
	end 	
	// A_EN OPERATIONS
	else if (sb_item.a_en && !sb_item.b_en) begin
		out_exp = A_operation(sb_item.A, sb_item.B, sb_item.a_op);
		`uvm_info(get_type_name(), $sformatf("Expected data is %0b", out_exp), UVM_MEDIUM);
	end 
	// B_EN OPERATIONS
	else if (!sb_item.a_en && sb_item.b_en) begin
		out_exp = B_operation(sb_item.A, sb_item.B, sb_item.b_op);
`		uvm_info(get_type_name(), $sformatf("Expected data is %0b", out_exp), UVM_MEDIUM);
	end 
	// EXTRACTING THE OUTPUT
	wait(item_out.size > 0); 
	sb_item = item_out.pop_front();
	out_tmp = sb_item.C;
	`uvm_info(get_type_name(), $sformatf(" Monitored output data is %0b, ", out_tmp), UVM_MEDIUM);
	// CALCULATE SUCCESSFUL AND FAILED TRANSACTIONS
	if (out_exp != out_tmp) begin
		cnt_err++;
		`uvm_info(get_type_name(), $sformatf("Incorrect output, expected is = %0b and out is = %0b, ", out_exp, out_tmp), UVM_MEDIUM);
	end
	else begin
		cnt_crr++;
	`uvm_error(get_type_name(), $sformatf("Correct output, expected is = %0b and out is = %0b, ", out_exp, out_tmp));
	end
	$display("----------------------------------------------------------------------------------------------------------");
end
endtask
//REPORT PHASE
function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("Report_Phase", $sformatf("Successful checks: %0d", cnt_crr), UVM_LOW);
	`uvm_info("Report_Phase", $sformatf("Unsuccessful checks: %0d", cnt_err), UVM_LOW);
endfunction
endclass
function logic signed [5:0] alu_scoreboard::A_operation(logic signed [4:0]A,B,logic signed [2:0] op);
begin
	logic signed [5:0] a_ext , b_ext;
	 a_ext = {A[4],A}; 
	 b_ext = {B[4],B}; 
	case(op) 
			3'b000	:	return (a_ext+b_ext);
			3'b001	:	return (a_ext-b_ext);
			3'b010	:	return (a_ext^b_ext);
			3'b011	:	return (a_ext&b_ext);
			3'b100	:	return (a_ext&b_ext);
			3'b101	:	return (a_ext|b_ext);
			3'b110	:	return (a_ext ~^ b_ext);
	endcase
end
endfunction
//************* B_en is the only high signal*************
function logic signed [5:0] alu_scoreboard::B_operation(logic signed [4:0]A,B,logic signed [2:0] op);
begin
	logic signed [5:0] a_ext , b_ext;
	a_ext = {A[4],A}; 
	b_ext = {B[4],B}; 
	case(op)
			2'b00	:	return (~(a_ext & b_ext));
			2'b01	:	return (a_ext + b_ext);
			2'b10	:	return (a_ext + b_ext);
	endcase 
end
endfunction
//************* Both are high *************
function logic signed [5:0] alu_scoreboard::AB_operation(logic signed [4:0]A,B,logic signed [2:0] op);
begin
	logic signed [5:0] a_ext , b_ext;
	a_ext = {A[4],A}; 
	b_ext = {B[4],B}; 
	case(op)
			2'b00	:	return (~(a_ext | b_ext));
			2'b01	:	return (a_ext ~^ b_ext);
			2'b10	:	return (a_ext - 1'b1);
			2'b11	:	return (b_ext + 2'b10);
	endcase 
end
endfunction