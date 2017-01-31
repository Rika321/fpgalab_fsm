module counter_odd(out, reverse, pause, clk, reset);
	output [3:0] out;
	input reverse, pause, clk, reset;
	wire [3:0] Q, D, Q_next, next, next_above, increment;
	register #(4) counter(Q, D, clk, ~pause, reset);
	mux2v #(4) mux_dir(increment, 4'h2, 4'he, reverse); 		// output 1 when direct = 0
	assign Q_next = (Q + increment);
	mux2v #(4) mux_out(next, Q_next, Q, pause);
	assign above_range = (Q == 4'd9) && ~reverse;
	assign below_range = (Q == 4'd1) && reverse;
	mux2v #(4) mux_above_range(next_above, next, 4'b1, above_range);
	mux2v #(4) mux_below_range(D, next_above, 4'd9, below_range);
	assign out = Q;
endmodule