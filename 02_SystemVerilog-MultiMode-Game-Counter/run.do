# 1. Quit any running simulation
quit -sim

# 2. Clear the transcript console
.main clear

# 3. Compilation (STRICT ORDER REQUIRED)
# Order: Package -> Interface -> DUT -> TB -> Top
vlog game_counter_pkg.sv game_counter_if.sv game_counter.sv game_counter_tb.sv top.sv

# 4. Simulation (with coverage and full access)
vsim -coverage -voptargs="+acc" work.top

# 5. Add all signals inside the interface to the Wave window
add wave -position insertpoint sim:/top/i/*

# 6. Run simulation until $stop is reached
run -all

# 7. Zoom full in the wave window to see the entire simulation
wave zoom full
