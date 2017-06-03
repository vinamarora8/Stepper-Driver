module stepper_driver(clk, start, data, ready);

// Assigning ports as in/out
input clk;
input start;
input [7:0] data;
output ready;

// Connections for generating "start_pulse"
wire start_d;
wire running;
D_latch start_pulse_generator(
	.clk(clk),
	.d(start & (~running)),
	.p(1'b1),
	.c(1'b1),
	.q(start_d)
	);
wire start_pulse = start & (~start_d);

// Connections for generating "running"
wire stop;
sync_SR_latch run_controller(
	.clk(clk),
	.s(start_pulse),
	.r(stop),
	.p(1'b1),
	.c(1'b1),
	.q(running)
	);

// Connections for "step_count"
wire [7:0] step_count;
wire [7:0] next ={step_count[7], ((step_count[7]) ? step_count[6:0] + 1 : step_count[6:0] - 1)};
D_latch #(8) step_count_controller(
	.clk((running) ? clk : start_pulse),
	.d((running) ? next : data),
	.p(1'b1),
	.c(1'b1),
	.q(step_count)
	);

// Connections for "stop"
assign stop = (next[6:0] == 0);

// Connections for "ready"
assign ready = ~running;

endmodule
