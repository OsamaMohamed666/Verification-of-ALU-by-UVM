class alu_monitor_out extends uvm_monitor;
virtual alu_intf vif;
uvm_analysis_port #(seq_item) item_collect_port_out;
seq_item mon_out_item;
`uvm_component_utils(alu_monitor_out)

function new(string name = "alu_monitor_out", uvm_component parent = null);
	super.new(name, parent);
	item_collect_port_out = new("item_collect_port_out", this);
	mon_out_item = new();
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual alu_intf) :: get(this, "", "vif", vif))
	`uvm_fatal(get_type_name(), "Not set at top level");
endfunction

task run_phase (uvm_phase phase);
	forever begin
		wait(vif.rst_n && vif.ALU_en);
		@(negedge vif.clk)// iff mon_out_item.ALU_en)
		mon_out_item.C = vif.Monitor_out.C;
		item_collect_port_out.write(mon_out_item);

end
endtask
endclass