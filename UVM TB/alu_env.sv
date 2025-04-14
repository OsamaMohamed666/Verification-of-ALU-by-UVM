class alu_env extends uvm_env;
`uvm_component_utils(alu_env)
alu_agent agt;
alu_scoreboard sb;
alu_coverage cov;
 
function new(string name = "alu_env", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
	agt = alu_agent::type_id::create("agt", this);
	sb = alu_scoreboard::type_id::create("sb", this);
	cov = alu_coverage::type_id::create("cov", this);
endfunction

function void connect_phase(uvm_phase phase);
	agt.mon_in.item_collect_port.connect(sb.item_collect_export_in);
	agt.mon_out.item_collect_port_out.connect(sb.item_collect_export_out);
	agt.mon_in.item_collect_port.connect(cov.item_collect_export_in);
	agt.mon_out.item_collect_port_out.connect(cov.item_collect_export_out);
endfunction
endclass