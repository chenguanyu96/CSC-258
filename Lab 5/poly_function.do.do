# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog poly_function.v

# Load simulation using mux as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
force {CLOCK_50} 0 0 ns, 1 1 ns -r 2
force {KEY[0]} 0 0 ns, 1 4 ns 
force {KEY[1]} 1 6 ns, 0 8 ns, 1 10 ns, 0 12 ns, 1 14 ns, 0 16 ns, 1 18 ns, 0 20 ns, 1 22 ns
force {SW[7:0]} 00000010 0 ns, 000000011 11 ns, 00000100 15 ns, 00000001 19 ns
#A = 3, B = 4, C = 5, x = 2
#Ax^2 + Bx + C = 12 + 8 + 5 = 25 (11001)
# Run simulation for a few ns.
run 55 ns
