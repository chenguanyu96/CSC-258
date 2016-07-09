# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog sequence_detector.v

# Load simulation using mux as the top level simulation module.
vsim sequence_detector

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
force {KEY[0]} 0 0 ns, 1 1 ns -r 2
force {SW[0]} 0 0 , 1 4
force {SW[1]} 1 0 ns, 0 6 ns, 1 8 ns
# Run simulation for a few ns.
run 55 ns
