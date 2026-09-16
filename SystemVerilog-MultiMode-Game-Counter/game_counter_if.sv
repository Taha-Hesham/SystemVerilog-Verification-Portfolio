`timescale 1ns/100ps

/****************************************************************************
 * ARCHITECTURAL STANDARD: TB-DUT SYNCHRONIZATION VIA CLOCKING BLOCK
 * ----------------------------------------------------------------------------
 * This rule defines the latency (in clock cycles) required for the Testbench 
 * (TB) to observe the effect of a driven signal on the Design (DUT).
 *
 * 1. FULL SYNCHRONIZATION (TB: Sequential <-> DUT: Sequential)
 *    - Setup  : TB uses 'cb'  |  DUT uses 'always_ff'
 *    - Latency: 2 Clock Cycles.
 *    - Path   : Edge 1 -> DUT reads driven data. Edge 2 -> TB samples DUT output.
 *
 * 2. COMBINATIONAL BYPASS (TB: Combinational <-> DUT: Combinational)
 *    - Setup  : TB drives/reads directly (No cb)  |  DUT uses 'always_comb'
 *    - Latency: 0 Clock Cycles (Instantaneous).
 *    - Warning: Highly prone to Race Conditions.
 *
 * 3. COMBINATIONAL DUT RESPONSE (TB: Sequential -> DUT: Combinational)
 *    - Setup  : TB uses 'cb'  |  DUT uses 'always_comb'
 *    - Latency: 1 Clock Cycle.
 *    - Path   : DUT reacts instantly, but TB waits for the next edge to sample.
 *
 * 4. SEQUENTIAL DUT RESPONSE (TB: Combinational -> DUT: Sequential)
 *    - Setup  : TB drives directly (No cb)  |  DUT uses 'always_ff'
 *    - Latency: 1 Clock Cycle.
 *    - Path   : DUT updates state on the first edge. TB reads it immediately.
 **************************************************************************/

interface interf (input bit clk);
	import game_pkg::*;

    logic rst;
    state_e s;
    logic init;
    logic [3:0] init_value;
    logic [3:0] count;
    logic loser;
    logic winner;
    logic [3:0] loser_count;
    logic [3:0] winner_count;
    logic gameover;
    logic [1:0] who;

	clocking cb @(posedge clk);
		input count,loser_count,winner_count;
	endclocking

	modport dut(
		input clk,rst,s,init,init_value,output count,loser,winner,loser_count,winner_count,gameover,who);

	modport tb(
		output rst,s,init,init_value,input loser,winner,gameover,who,clocking cb);


endinterface