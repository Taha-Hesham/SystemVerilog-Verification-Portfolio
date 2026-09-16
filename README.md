# Digital Design & Verification Portfolio

Welcome to my hardware engineering portfolio. This repository serves as a collection of my projects in digital logic design, boolean optimization, and advanced SystemVerilog verification methodologies. 

Below is an overview of the projects included in this repository, organized by directory.

---

## 📁 Directory: SystemVerilog-MultiMode-Game-Counter

### Overview
This folder contains the RTL design and a robust SystemVerilog verification environment for a Multi-Mode Game Counter. The project focuses on architectural accuracy, standard verification methodologies, and precise edge-case handling (overflow/underflow protection).

### Project Architecture
* **Design Under Test (DUT)**: `game_counter.sv` (Multi-mode counter logic)
* **Interface**: `game_counter_if.sv` (Features `clocking blocks` for strict TB-DUT synchronization)
* **Package**: `game_counter_pkg.sv` (Shared enums and typedefs)
* **Testbench**: `game_counter_tb.sv` (Comprehensive directed testing with immediate assertions)
* **Top Module**: `top.sv`

### Verification Highlights
* **Race-Condition-Free**: Implemented IEEE 1800 standard synchronization using `clocking blocks` to perfectly isolate the Active and Reactive regions in the simulation scheduler.
* **Assertion-Based Verification (ABV)**: Used immediate assertions tightly coupled with the clocking block sampling to validate hardware behavior.
* **Edge-Case Coverage**: Tested complex bounce scenarios, asynchronous resets, and synchronous clears upon reaching the "GAMEOVER" state.

### How to Run (QuestaSim/ModelSim)
An automated TCL script is provided for clean compilation and waveform generation.
1. Open QuestaSim/ModelSim.
2. Change the directory to this project folder.
3. Run the following command in the transcript:
   ```tcl
   do run.do
   ```

---

## 📁 Directory: Combinational-Logic-Optimization

### Overview
This folder contains a digital logic minimization project demonstrating the reduction of complex multi-variable boolean functions into optimized gate-level schematics. The structural optimization and schematic generation were performed using **Logic Friday**.

### Project Contents
* **Logic Friday Project (`assignment_1.lfcn`)**: The source file containing the configured truth tables and logic expressions for a 9-input (A-I), multi-output (F0, F1, m) digital circuit.
* **Gate-Level Schematics**:
  * `non_minimized.png`: The schematic representation of the raw, unoptimized boolean expressions.
  * `minimized.png`: The optimized gate-level schematic resulting from exact minimization algorithms, significantly reducing the overall logic gate count and hardware footprint.

### Highlights
* **Boolean Minimization**: Simplification of complex logic functions to reduce hardware complexity.
* **Hardware Efficiency**: Direct visual and mathematical comparison between unoptimized logic mappings and fully minimized gate-level networks.
