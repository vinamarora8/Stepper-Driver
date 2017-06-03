module shift_register(clk, data, ce, down, clr, q);

// Parameter for width and delay generalization
parameter length=8;

// Assigning ports as in/out
input clk, clr, ce, down;
input data;

// Instantiate the register train
output reg [length-1 : 0] q;

initial q = {length{1'b0}};

// The Shifting part:
always @(posedge clk)
begin
	if (ce)
	begin
		if (down)
			q = {data, q[length-1 : 1]};
		else
			q = {q[length-2 : 0], data};
		if (clr)
			q = {length{1'b0}};
	end
end

endmodule
