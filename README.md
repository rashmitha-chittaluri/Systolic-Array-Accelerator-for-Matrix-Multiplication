
#TPU-Style Systolic Accelerator for Matrix Multiplication  
### High-Performance Matrix Multiplication Engine (Verilog HDL + Xilinx Vivado)

This project implements a **TPU-style systolic array accelerator** for fast matrix multiplication, inspired by Google’s Tensor Processing Unit (TPU) architecture.  
The design is written entirely in **Verilog HDL** and can also be extended or wrapped in **SystemVerilog** if needed.

The accelerator is simulated using Vivado’s built-in simulator and can be synthesized and implemented on a Xilinx FPGA.

---

1. Project Overview

A systolic array is a 2D grid of Processing Elements (PEs) where data flows rhythmically through the array.  
This is especially efficient for matrix multiplication, which is the main building block of deep learning workloads.

### Key Features

- TPU-style systolic array for matrix multiplication  
- Pipelined MAC-based Processing Elements  
- On-chip SRAM-like memories for input matrices and partial sums  
- Testbench that:
  - Loads input matrices
  - Runs three matrix evaluations
  - Compares against golden outputs
  - Prints **throughput, cycles, and PASS/FAIL**
- Measured throughput (from simulation): ≈ 8.951 GOPS

2. Design Architecture

2.1 Top-Level View

Main modules (file names are examples; adjust if yours differ):

- `tpu_top.v`  
  - Connects systolic array, memories, and controller
- `systolic.v` (or `systolic_array.v`)  
  - Instantiates the 2D grid of PEs
- `pe.v`  
  - Verilog implementation of a single Processing Element (MAC + registers)
- `controller.v`  
  - Finite State Machine controlling data flow and timing
- `tpu_fpga_wrapper.v`  
  - Wraps the design for FPGA I/O: clock, reset, start, LED

### 2.2 Dataflow (TPU-style)

- Matrix A elements stream vertically (top to bottom)  
- Matrix B elements stream horizontally (left to right)  
- Partial sums propagate through the array and are stored in SRAM-style memories

---

## 3. Repository Structure

Example structure you can follow:

```text
systolic_accelerator/
│
├── rtl/
│   ├── pe.v
│   ├── systolic.v
│   ├── controller.v
│   ├── tpu_top.v
│   └── tpu_fpga_wrapper.v
│
├── tb/
│   ├── test_tpu.v
│   ├── matrices.hex
│   └── expected_output.hex
│
├── constraints/
│   └── pynq_z2.xdc
│
├── results/
│   ├── simulation_output.txt
│   ├── waveform.png
│   ├── throughput_summary.png
│   └── power_summary.png
│
└── README.md
