module D_latch(clk, d, p, c, q);

parameter width = 1;

// Assigning ports as input/output
input clk, p, c;
input [width-1 : 0] d;
output reg [width-1 : 0] q;

// Initializing the output
initial
	q <= {width{1'b0}};

// D-Latch action
always @(posedge clk)
begin
	if (~p)
		q <= {width{1'b1}};
	else if (~c)
		q <= {width{1'b0}};
	else
		q <= d;
end

endmodule 
