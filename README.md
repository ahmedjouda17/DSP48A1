# DSP48A1 IP Core - RTL Design and Implementation

**Author:** Ahmed Goda Sharawy[cite: 1]

## Project Overview
This repository contains the complete Register-Transfer Level (RTL) design and verification of the DSP48A1 block[cite: 1]. The design provides high-speed arithmetic operations including multiplication, addition, subtraction, and accumulation[cite: 1]. The architecture is modeled for the Vertex 5 FPGA family.

## Architecture & Modules
The project is implemented using Verilog RTL and is divided into four main stages to allow independent development and verification[cite: 1].
* **DSP48A1 Module:** The top-level module integrating the data paths and arithmetic logic[cite: 1].
* **Register Modules:** Includes customizable internal pipeline registers (A0, A1, B0, B1, C, D, M, P) with synchronous/asynchronous reset options[cite: 1].

## Simulation & Verification
The functionality was thoroughly verified using Questa Sim[cite: 1].
* A comprehensive self-checking testbench was developed to evaluate four different internal data paths[cite: 1].
* The testbench cycles through various operational modes (OPMODE) and verifies the outputs (`BCOUT`, `PCOUT`, `P`, `M`, `CARRYOUT`, `CARRYOUTF`) against expected golden values[cite: 1].
* A `wave.do` script is provided to automate the simulation environment and waveform generation[cite: 1].

## Implementation Results (Xilinx Vivado)
The RTL was fully elaborated, synthesized, and implemented. The following verified reports were extracted from the Vivado design flow:

### 1. Elaboration, Synthesis & Utilization
* **Cells:** 336[cite: 1]
* **Ports:** 3480[cite: 1]
* **Nets:** 830[cite: 1]
* **Slice LUTs:** 275 (1% utilization)[cite: 1]
* **Slice Registers:** 376 (<1% utilization)[cite: 1]

### 2. Timing Closure
* All user-specified timing constraints were met successfully[cite: 1].
* **Worst Negative Slack (WNS):** 5.132 ns[cite: 1]
* **Worst Hold Slack (WHS):** 0.140 ns[cite: 1]

### 3. Power Analysis
* **Total On-Chip Power:** 0.281 W[cite: 1]
* **Dynamic Power:** 0.150 W (53%)[cite: 1]
* **Device Static Power:** 0.131 W (47%)[cite: 1]

## Code Quality
* The Verilog source code was analyzed using linting tools, resulting in zero design errors[cite: 1].
