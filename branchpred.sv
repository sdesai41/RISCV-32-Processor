module branchpred(clk,outcome, branch, PCpred,PCupdate,out);

input clk;
input [2:0] branch;
input [11:0] PCpred,PCupdate;
input outcome;
reg [1:0] state [0:4095];
output reg out;
integer i;

initial begin 
for (i=0; i<4096; i=i+4) begin
state[i]=2'b01;
end
end

always @(posedge clk) begin
	#5
	$display("state @ %h=%b",PCpred,state[PCpred]);
	case(state[PCpred]) //output branch prediction 0 no 1 yes
	2'b00: out=0;
	2'b01: out=0;
	2'b10: out=1;
	2'b11: out=1;
	endcase
if (!(!branch)) begin // if we are branching update state based on outcome
	if (outcome) begin
		$display("Pos outcome @ %h",PCupdate);
		case (state[PCupdate]) //increment if we branch
			2'b11: state[PCupdate]<=state[PCupdate];
			default: state[PCupdate]<=state[PCupdate]+1;
		endcase
	end
	else if (!outcome) begin
		$display("neg outcome @ %h",PCupdate);
		case (state[PCupdate]) //decrement if we dont branch
			2'b00: state[PCupdate]<=state[PCupdate];
			default: state[PCupdate]<=state[PCupdate]-1;
		endcase
	end
end
end
endmodule

module btb(clk,PC,PCupdate,branch,target,addrout);

parameter PCSIZE=12;
parameter BTBSIZE=32;

input clk;
integer i;
reg [4:0] count=0;
input [2:0] branch;
input [PCSIZE-1:0] PC,PCupdate, target;
reg [2*PCSIZE-1:0] BTB [0:BTBSIZE-1];
output reg [PCSIZE-1:0] addrout;

always @ (posedge clk) begin
#5
		for (i=0; i<BTBSIZE; i=i+1) begin //search if addr is in BTB
			if (BTB[i][2*PCSIZE-1:PCSIZE]==PC) begin
				addrout=BTB[i][PCSIZE-1:0]; //set addrout to target
				break;
			end
		end
	if (!(!branch)) begin 	//update BTB on branches
		if (count<BTBSIZE) begin 
			BTB[count][2*PCSIZE-1:PCSIZE]=PCupdate; //store address
			BTB[count][PCSIZE-1:0]=target; //store target addy
			count=count+1;
		end
		else if (count==BTBSIZE) begin
			count=0;
			BTB[count][2*PCSIZE-1:PCSIZE]=PCupdate;
			BTB[count][PCSIZE-1:0]=target;
		end
	end
end

endmodule
		







