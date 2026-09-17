# Multi-Mode Game Counter Verification

## Overview
This folder contains the RTL design and a robust SystemVerilog verification environment for a Multi-Mode Game Counter. The project focuses on architectural accuracy, standard verification methodologies, and precise edge-case handling.

## Project Architecture
* **DUT**: `game_counter.sv` (Multi-mode counter logic)
* **Interface**: `game_counter_if.sv` (Features `clocking blocks` for strict TB-DUT synchronization)
* **Package**: `game_counter_pkg.sv` (Shared enums and typedefs)
* **Testbench**: `game_counter_tb.sv` (Comprehensive directed testing with immediate assertions)
* **Top Module**: `top.sv`

## Verification Highlights
* **Race-Condition-Free**: Implemented IEEE 1800 standard synchronization using `clocking blocks` to perfectly isolate the Active and Reactive regions.
* **Assertion-Based Verification (ABV)**: Used immediate assertions tightly coupled with the clocking block sampling to validate hardware behavior.
* **Edge-Case Coverage**: Tested complex bounce scenarios, asynchronous resets, and synchronous clears upon reaching the "GAMEOVER" state.

## How to Run (QuestaSim)
```tcl
do run.do
