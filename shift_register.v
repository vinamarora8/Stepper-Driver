module shift_register(clk, data, clr, q);

// Parameter for width and delay generalization
parameter length=8;

// Assigning ports as in/out
input clk, clr;
input data;

// Instantiate the register train
output reg [length-1 : 0] q;

initial q = {length{1'b0}};

// The Shifting part:
always @(posedge clk)
begin
	q = {q[length-2 : 0], data};
	if (clr)
		q = {length{1'b0}};
end

endmodule
