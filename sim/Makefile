sim:
	iverilog -g2012 -o sim.o  ./tb_arb.sv ../src/rr_arb.v ../src/rr_arb_opt.v 
	vvp sim.o

wave:
	gtkwave *.vcd

clean:
	rm -rf *.o *.vcd