# 🚀 DSP48A1 IP Core - RTL Design and Implementation 🛠️

## 📖 Project Overview
This repository contains the complete Register-Transfer Level (RTL) design and verification of the DSP48A1 block. The design provides high-speed arithmetic operations including multiplication, addition, subtraction, and accumulation. The architecture is modeled for the Xilinx Vertex 5 FPGA family.

## 🏗️ Architecture & Modules
The project is implemented using Verilog RTL and is divided into four main stages to allow independent development and verification.
* 🧩 **DSP48A1 Module:** The top-level module integrating the data paths and arithmetic logic.
* 💾 **Register Modules:** Includes customizable internal pipeline registers (A0, A1, B0, B1, C, D, M, P) with synchronous/asynchronous reset options.

## 🔍 Simulation & Verification
The functionality was thoroughly verified using Questa Sim.
* 🧪 A comprehensive self-checking testbench was developed to evaluate four different internal data paths.
* 🔄 The testbench cycles through various operational modes (OPMODE) and verifies the outputs (`BCOUT`, `PCOUT`, `P`, `M`, `CARRYOUT`, `CARRYOUTF`) against expected golden values.
* 📜 A `wave.do` script is provided to automate the simulation environment and waveform generation.

## 📊 Implementation Results (Xilinx Vivado)
The RTL was fully elaborated, synthesized, and implemented targeting the Vertex 5 architecture. The following verified reports were extracted from the Vivado design flow:

### 1️⃣ Elaboration, Synthesis & Utilization
* 🧱 **Cells:** 336
* 🔌 **Ports:** 3480
* 🕸️ **Nets:** 830
* 📉 **Slice LUTs:** 275 (1% utilization)
* 📈 **Slice Registers:** 376 (<1% utilization)

### 2️⃣ Timing Closure
* ⏱️ All user-specified timing constraints were met successfully.
* ⏳ **Worst Negative Slack (WNS):** 5.132 ns
* ⏲️ **Worst Hold Slack (WHS):** 0.140 ns

### 3️⃣ Power Analysis
* ⚡ **Total On-Chip Power:** 0.281 W
* 🔋 **Dynamic Power:** 0.150 W (53%)
* 🔌 **Device Static Power:** 0.131 W (47%)

## ✨ Code Quality
* 🛡️ The Verilog source code was analyzed using linting tools, resulting in zero design errors.

---
### 👨‍💻 Author
**Ahmed Goda Sharawy**
*🎓 Digital Communication and Electronics Student | Focused on digital integrated circuit design and hardware verification*
