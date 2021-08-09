module branchpred(outcome,clk,out);

input outcome,clk;
reg [1:0] state;
output reg out;

initial begin 
state=2'b01;
end

always begin
case(state)
2'b00: out=0;
2'b01: out=0;
2'b10: out=1;
2'b11: out=1;
endcase
end

always @ (posedge clk) begin
if (outcome) begin
case (state)
2'b11: state<=state;
default: state<=state+1;
endcase
end
else begin
case (state)
2'b00: state<=state;
default: state<=state-1;
endcase
end
end
endmodule


