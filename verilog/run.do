vlib work
vlog DSP48A1.v REGISTER.v TB.v
vsim -voptargs=+acc work.TB
add wave *
run -all
#quit -sim