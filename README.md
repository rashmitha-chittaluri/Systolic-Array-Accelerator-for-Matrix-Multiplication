# Introduction
This project implements a custom 8×8 TPU-style systolic array accelerator for matrix multiplication. The design multiplies an 8×8 weight matrix (Matrix A) with an 8×8 input/data matrix (Matrix B) using a fully pipelined parallel architecture. Before computation begins, the elements of both matrices are reordered into a systolic-friendly streaming format, then fed into dedicated input queues. These queues deliver one value per cycle into the systolic grid.
Each Processing Element (PE) performs a multiply–accumulate (MAC) operation using the weight and data values it receives. On every clock cycle, weights propagate from top to bottom, and data propagate from left to right. This movement creates a rhythmic “wavefront” of computation that spreads across the array—allowing all 64 PEs to work in parallel.
The design therefore achieves highly efficient matrix multiplication with a measured throughput of 8.951 GOPS in simulation.

# Systolic Array Architecture
At the heart of the design is an 8×8 grid of Processing Elements.
Each PE contains three fundamental registers:
1.	A weight register to store and pass Matrix A elements downward
2.	A data register to store and pass Matrix B elements rightward
3.	An accumulator (ALU) to add the product of weight × data to the running partial sum
Together, these 64 PEs compute the entire 8×8 matrix multiplication in a wavefront fashion. Every cycle, new values enter from the top and left edges, propagate across the array, and partial sums accumulate until final results emerge from the bottom-right region.


![Systolic Architecture](fpga/arch%20of%20Sys.png)



## Design Architecture (Modules Overview)
The full system is organized into modular Verilog components.
At the top level, tpu_top.v connects the systolic array, controller, and on-chip memory structures.
The systolic array itself is instantiated from systolic.v, which builds the 8×8 grid of PEs from pe.v.
A centralized control module (controller.v) coordinates data injection, propagation timing, and accumulation windows.
For FPGA deployment, tpu_fpga_wrapper.v maps the design to physical I/O—including clock, reset, start signals, and LED status.
This modular structure allows easy extension to larger arrays (e.g., 16×16) or integration with AXI interfaces for real system-on-chip use.
Google TPU Inspiration:
The architecture is inspired by Google’s Tensor Processing Unit (TPU). To better understand the system, I recreated a simplified TPU block diagram by combining information from publicly available TPU patents and system analysis. This diagram helped clarify the interactions between the systolic matrix-multiply unit, weight FIFOs, activation buffers, and unified memory interfaces used in the TPU.
Although many internal TPU details are proprietary, the core systolic principles—data streaming, weight stationary flow, and spatially distributed MAC operations—are well documented and directly influenced the structure of this implementation.

## Architecture Overview
Below is the high-level architecture of the 8×8 TPU-Style Systolic Array:

![Architecture](docs/Arch.png)



## Steps to Run This Project in Vivado
#Download or Clone the Repository
              git clone https://github.com/<your-username>/systolic_accelerator.git
             Or download the ZIP and extract it. 
#	Open Vivado
              Start Vivado from terminal or desktop:
               vivado &
#	Create a New Vivado Project
1.	Click Create New Project
2.	Select RTL Project
3.	Check "Do not specify sources at this time"
4.	Select your FPGA board or part (e.g., PYNQ-Z2 → xc7z020clg400-1)
5.	Finish
   
# Add RTL (Design) Files
Go to:
Project Manager → Add Sources → Add or Create Design Sources
Add all files from:
rtl/ & testbench/
# Set the Simulation Top Module
Vivado → Run Simulation → Run Behavioral Simulation
If prompted, set:
test_tpu.v
# Run Behavioral Simulation
1.	Click Run Behavioral Simulation
2.	Wait for testbench to run
3.	Check the console output for:
o	SRAM dumps
o	Three matrix groups
o	PASS/FAIL results
o	Throughput summary

## Expected output:
Throughput: 8.951 GOPS
Total cycles: 44
Execution time: 114.40 ns
All addresses PASS!!

# Add Constraint File (For FPGA Build)
Go to:
Add Sources → Add or Create Constraints
Add:
constraints/pynq_z2.xdc
This maps the FPGA pins (clock, reset, start button, LED).
# Set FPGA Top Module
In the Sources window:
•	Right-click tpu_fpga_wrapper.v
•	Select Set as Top
# Run Synthesis
Click:
Flow Navigator → Run Synthesis
Wait for synthesis to complete.
# Run Implementation
Click:
Run Implementation
This performs place & route.
# Generate Bitstream
Click:
Generate Bitstream
Vivado will output a .bit file.
# Program the FPGA
1.	Connect FPGA board
2.	Go to Hardware Manager
3.	Open Target → Auto Connect
4.	Click Program Device
5.	Select the generated .bit file

# To start the TPU:
•	Press BTN1
•	LED0 lights up when computation is done


## Vivado Floorplan
The FPGA floorplan generated during implementation:

![Vivado Floorplan](docs/vivado_floorplan.png)






