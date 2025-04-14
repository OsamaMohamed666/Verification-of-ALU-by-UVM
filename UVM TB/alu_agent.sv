class alu_agent extends uvm_agent;
`uvm_component_utils(alu_agent)
alu_driver drv;
alu_sequencer seqr;
alu_monitor_in mon_in;
alu_monitor_out mon_out;

function new(string name = "alu_agent", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(get_is_active == UVM_ACTIVE) begin 
		drv = alu_driver::type_id::create("drv", this);
		seqr = alu_sequencer::type_id::create("seqr", this);
	end
	mon_in = alu_monitor_in::type_id::create("mon_in", this); 
	mon_out = alu_monitor_out::type_id::create("mon_out", this);
endfunction

function void connect_phase(uvm_phase phase);
	if(get_is_active == UVM_ACTIVE) begin 
		drv.seq_item_port.connect(seqr.seq_item_export);
	end
endfunction
endclass