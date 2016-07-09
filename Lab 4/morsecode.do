# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog morsecode.v

# Load simulation using mux as the top level simulation module.
vsim MorseCode

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {CLOCK_50} 0 0 ns, 1 1 ns -r 2
force {KEY[0]} 0 0 ns, 1 4 ns 
force {KEY[1]} 0 0 ns, 1 8 ns
force {SW[2:0]} 010 0 ns

run 80 ns