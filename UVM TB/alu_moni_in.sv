class alu_monitor_in extends uvm_monitor;
virtual alu_intf vif;
uvm_analysis_port #(seq_item) item_collect_port;
seq_item mon_in_item;
`uvm_component_utils(alu_monitor_in)

function new(string name = "alu_monitor_in", uvm_component parent = null);
	super.new(name, parent);
	item_collect_port = new("item_collect_port", this);
	mon_in_item = new();
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual alu_intf) :: get(this, "", "vif", vif))
	`uvm_fatal(get_type_name(), "Not set at top level");
endfunction

task run_phase (uvm_phase phase);
	forever begin
		wait(vif.rst_n && vif.ALU_en);
		@(posedge vif.clk )
		mon_in_item.ALU_en = vif.Monitor_in.ALU_en;
		mon_in_item.a_en = vif.Monitor_in.a_en;
		mon_in_item.b_en = vif.Monitor_in.b_en;
		mon_in_item.b_op = vif.Monitor_in.b_op;
		mon_in_item.a_op = vif.Monitor_in.a_op;
		mon_in_item.A = vif.Monitor_in.A;
		mon_in_item.B = vif.Monitor_in.B;
		@(posedge vif.clk)
		item_collect_port.write(mon_in_item);
	end
endtask
endclass