`include "uvm_macros.svh"
import uvm_pkg::*;

`include "alu_intf.sv"
`include "alu_test.sv"

module tb_top;
bit clk;
bit reset;
always #5 clk = ~clk;

initial begin
clk = 0;
reset = 0;
#5; 
reset = 1;
end



initial begin
//set interface in config_db
uvm_config_db#(virtual alu_intf)::set(uvm_root::get(), "*", "vif", vif);
$dumpfile("dump.vcd");
$dumpvars;
end
initial begin
	run_test("alu_test");
end

alu_intf vif(clk, reset);

 ALU dut(
 .clk(clk),
 .rst_n(reset),
 .ALU_en(vif.ALU_en),
 .A(vif.A),
 .B(vif.B),
 .b_op(vif.b_op),
 .b_en(vif.b_en),
 .a_en(vif.a_en),
 .a_op(vif.a_op),
 .C(vif.C)
);
endmodule