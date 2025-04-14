class alu_driver extends uvm_driver#(seq_item);
virtual alu_intf vif;
`uvm_component_utils(alu_driver)

function new(string name = "alu_driver", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(virtual alu_intf) :: get(this, "", "vif", vif))
	`uvm_fatal(get_type_name(), "Not set at top level");
endfunction

task reset_inputs();
	`uvm_info(get_type_name(), "Resetting input signals", UVM_LOW)
	vif.Driver.ALU_en <=0;
	vif.Driver.A <=0;
	vif.Driver.B <=0;
	vif.Driver.a_en <=0;
	vif.Driver.a_op <=0;
	vif.Driver.b_en <=0;
	vif.Driver.b_op <=0;
endtask 

task run_phase (uvm_phase phase);
	reset_inputs();
	@(posedge vif.Driver.rst_n); // wait untill reset is deasserted 
	
	forever begin
		seq_item_port.get_next_item(req);
		drive();
		seq_item_port.item_done();
	end
endtask

task drive();
	@(negedge vif.Driver.clk) 
	//DRIVING INPUTS
		vif.Driver.ALU_en <=req.ALU_en;
		vif.Driver.A <=req.A;
		vif.Driver.B <=req.B;
		vif.Driver.a_en <=req.a_en;
		vif.Driver.a_op <=req.a_op;
		vif.Driver.b_en <=req.b_en;
		vif.Driver.b_op <=req.b_op;
	//DRIVING OUTPUTS
	@(negedge vif.Driver.clk )
		req.C <= vif.Driver.C;
endtask 
endclass