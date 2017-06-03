`timescale 1 us / 1 ns

module stepper_driver(clk, start, data, ready, q);

// Assigning ports as in/out
input clk;
input start;
input [7:0] data;
output ready;
output [3:0] q;

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
	.s(start_pulse & (data != 0)),
	.r(stop),
	.p(1'b1),
	.c(1'b1),
	.q(running)
	);

// Connections for "step_count"
wire [7:0] step_count;
wire [6:0] adder_output = ((step_count[7]) ? step_count[6:0] + 1 : step_count[6:0] - 1);
wire [7:0] next ={step_count[7], adder_output[6:0]};
D_latch #(8) step_count_controller(
	.clk((running) ? clk : start_pulse),
	.d((running) ? next : data),
	.p(1'b1),
	.c(1'b1),
	.q(step_count)
	);

// Connections for "q"
wire loop_step_up = (~(q[0] | q[1] | q[2])) | q[3];
wire loop_step_down = (~(q[1] | q[2] | q[3])) | q[0];
shift_register #(4) q_generator(
	.clk(clk),
	.data((step_count[7]) ? loop_step_down : loop_step_up),
	.clr(1'b0),
	.ce(running),
	.down(step_count[7]),
	.q(q)
	);

// Connections for "stop"
assign stop = (next[6:0] == 0 | step_count[6:0] == 0);

// Connections for "ready"
assign ready = ~(running | start_pulse);

endmodule
