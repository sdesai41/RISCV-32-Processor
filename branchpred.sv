module branchpred(outcome, branch, PCpred,PCupdate,out);

input [2:0] branch;
input [11:0] PCpred,PCupdate;
input outcome;
reg [1:0] state [0:4095];
output reg out;
integer i;

initial begin 
for (i=0; i<1024; i=i+4) begin
state[i]=2'b01;
end
end

always @(PCpred) begin
case(state[PCpred])
2'b00: out=0;
2'b01: out=0;
2'b10: out=1;
2'b11: out=1;
endcase
end

always @ (outcome) begin
if (!(!branch)) begin
	if (outcome) begin
		case (state[PCupdate])
			2'b11: state[PCupdate]<=state[PCupdate];
				default: state[PCupdate]<=state[PCupdate]+1;
		endcase
	end
	else begin
		case (state[PCupdate])
			2'b00: state[PCupdate]<=state[PCupdate];
			default: state[PCupdate]<=state[PCupdate]-1;
		endcase
	end
end	
end
endmodule

module btb(PC,PCupdate,branch,target,addrout);

parameter PCSIZE=12;
parameter BTBSIZE=32;


integer i;
reg [4:0] count=0;
input [2:0] branch;
input [PCSIZE-1:0] PC,PCupdate, target;

reg [2*PCSIZE-1:0] BTB [0:BTBSIZE-1];

output reg [PCSIZE-1:0] addrout;


always @ (PC) begin

	for (i=0; i<BTBSIZE; i=i+1) begin
		if (BTB[i][2*PCSIZE:PCSIZE]==PC) begin
			addrout=BTB[i][PCSIZE-1:0];
			break;
		end
	end
end

always @ (PCupdate or branch or target) begin
	if (!(!branch)) begin
		BTB[count][2*PCSIZE:PCSIZE]=PCupdate;
		BTB[count][PCSIZE-1:0]=target;
	end
end

endmodule
		







