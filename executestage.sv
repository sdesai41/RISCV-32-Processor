module ALU(aluop,sign,data1,op2,result, zero, neg);

input reg signed [31:0] data1;
input reg signed [31:0] op2;
input sign;

wire [4:0] shamt;
input [4:0] aluop;
output  zero,neg;
output reg [31:0] result;

wire [31:0] operand1, operand2;
wire signed [31:0] addout,sllout,srlout,sraout,subout,andout,orout,xorout,unsubout;



assign operand1=data1; //unsigned versions
assign operand2=op2; // unsigned versions
assign shamt=op2[4:0]; //shift amount

//results based on operation
assign addout=data1+op2;
assign sllout= data1<<(shamt);
assign srlout=data1>>(shamt);
assign sraout= data1>>>(shamt);
assign subout=data1-op2;
assign andout=data1&op2;
assign orout= data1|op2;
assign xorout= data1^op2;
assign unsubout=operand1-operand2;

assign zero = (result==0) ? 1'b1 : 1'b0;
assign neg = (result<0) ? 1'b1 : 1'b0;

always @(*) begin 

	case(aluop)
	5'b00000:result=addout;
	5'b00001:begin
			if (!sign) begin
				result=unsubout;
				end
			else begin
				result=subout;
			end
		end
	5'b00010: result=sllout;
	5'b00011:result=xorout;
	5'b00100: result=srlout;
	5'b00101: result=sraout;
	5'b00110: result=orout;
	5'b00111: result=andout;
	5'b01000: begin
		if (!sign) begin
			if (unsubout<0) begin
				result=32'd1;
			end
			else begin
				result=0;
			end
		end
		else begin
			if (subout<0) begin
				result=32'd1;
			end
			else begin
				result=0;
			end
		end
	end
	5'b01001:begin 
					result=op2;
				end
	endcase
end
endmodule


module pcadder(PC,imm,pcresult);
parameter PCSIZE=16;

input reg [PCSIZE-1:0] PC;
input reg signed [31:0] imm;
output  [PCSIZE-1:0] pcresult;

assign pcresult=PC+imm;
endmodule


module instrcounter(instr,ctrlf,PC);
parameter instrsize=32;
parameter PCSIZE=16;

input reg [PCSIZE-1:0] PC;
input reg [instrsize-1:0] instr;
input ctrlf;

reg [16:0] rcount,icount, bcount, loadcount, storecount,jtype, jrtype, auipc, lui;  

initial begin
rcount=0;
icount=0; 
bcount=0;
loadcount=0;
storecount=0;
jtype=0;
jrtype=0;
auipc=0;
lui=0;
end
always @(*) begin
#10
if (!ctrlf) begin
 case(instr[6:0])
			7'b0110011: rcount++;
			7'b0010011: icount++;
			7'b0100011: storecount++;
			7'b0000011: loadcount++;
			7'b1100011: bcount++;
			7'b0110111: lui++;
			7'b0010111: auipc++;
			7'b1101111: jtype++;
			7'b1100111: jrtype++;
			default:begin
			end
			endcase
$display("PC=%d", PC);
$display("instruction=%h", instr);
//$display("rcount=%d,icount=%d,bcount=%d,loadcount=%d,storecount=%d,jtype=%d,jrtype=%d ,auipc=%d,lui=%d", rcount,icount, bcount, loadcount, storecount,jtype, jrtype, auipc, lui); 
			
end			
end
endmodule
