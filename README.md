# Verification-of-ALU-by-UVM
## Design specs of an  ALU
  1) Inputs A and B are signed data as well as the output C.
  2) Operations of alu depends on a and b enables then a_op and b_op.
  3) ALU only operates when alu_en is high otherwise, the output is ignored.
  4) Asynchronous active low reset.
  


## UVM Environment 
 Explained in Verification plan.
 The testbench is executed using Synopsys VCS (DVE); however, due to confidentiality constraints, simulation results cannot be shared. Alternatively, a representative version will be provided via EDA Playground by using run.bash file


## TESTBENCH Architecture 
![TESTBENCH ARCHITECTURE](https://github.com/user-attachments/assets/32c31858-ca99-46ce-bf09-d7734dca5530)


## UVM TOPOLOGY
![image](https://github.com/user-attachments/assets/cccff600-1937-4eb3-82dc-0adc49cb744f)


## Simulation results
  ##### LOG
  ![image](https://github.com/user-attachments/assets/507a55f8-d384-461d-abdd-4740a5a99eeb)

  ##### Waveform 
  ![image](https://github.com/user-attachments/assets/04fec46e-764a-445e-a1ee-8e2f578026a1)


## Coverage 
In the coverage reports file.
Note: line coverage isn't fully covered as toggling reset from 0 to 1, default branch, toggling of alu_en are not covered and i just excluded all of it from coverage using DVE as its that important to be covered




 
