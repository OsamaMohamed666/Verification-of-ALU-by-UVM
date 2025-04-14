`include "alu_package.sv"
class alu_test extends uvm_test;
alu_env env;
base_seq bseq;
direct_seq dseq;
`uvm_component_utils(alu_test)

function new(string name = "alu_test", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = alu_env::type_id::create("env", this);
endfunction

task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	bseq = base_seq::type_id::create("bseq");
	bseq.no_stimuls =300;
	bseq.start(env.agt.seqr);
	
	$display("----------------------------------------------------------------------------------------------------------");
	`uvm_info(get_type_name(),$sformatf("---------------ENDING OF THE CRTAT NO. OF TESTS = %0d----------------",bseq.no_stimuls),UVM_LOW);
	$display("----------------------------------------------------------------------------------------------------------");
	
	//DIRECT TEST
	dseq = direct_seq::type_id::create("dseq");
	`uvm_info(get_type_name(),$sformatf("---------------BEGINING OF THE DIRECT TEST AT NO. OF TESTS = %0d ----------------",dseq.dr_stimuls),UVM_LOW);
	dseq.start(env.agt.seqr);
	#10
	phase.drop_objection(this);
  //phase.phase_done.set_drain_time(this, 10);
endtask

//END OF ELABORATION PHASE
virtual function void end_of_elaboration();
uvm_top.print_topology();
endfunction

//REPORT PHASE 
virtual function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
 
	svr = uvm_report_server::get_server();
	if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
		`uvm_info("Report_Phase", "---------------------------------------", UVM_NONE)
		`uvm_info("Report_Phase", "----TEST FAIL----", UVM_NONE)
    	`uvm_info("Report_Phase", "---------------------------------------", UVM_NONE)
	end
	else begin
		`uvm_info("Report_Phase", "---------------------------------------", UVM_NONE)
		`uvm_info("Report_Phase", "---- TEST PASS ----", UVM_NONE)
		`uvm_info("Report_Phase", "---------------------------------------", UVM_NONE)
	end
	//COVERAGE REPORTS
	`uvm_info("Report_Phase",$sformatf("Final coverage of Enable coverage and cross coverage is %0.2f%%",env.cov.cg_enable.get_coverage()),UVM_LOW);
	`uvm_info("Report_Phase",$sformatf("Final coverage of data inputs is %0.2f%%",env.cov.cg_data_inputs.get_coverage()),UVM_LOW);
	`uvm_info("Report_Phase",$sformatf("Final coverage of operations is %0.2f%%",env.cov.cg_operations.get_coverage()),UVM_LOW);
	`uvm_info("Report_Phase",$sformatf("Final coverage of data output is %0.2f%%",env.cov.cg_output.get_coverage()),UVM_LOW);
endfunction 
endclass