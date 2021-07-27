module ALU(aluop, sign,data1,op2,result, zero, neg);

input reg signed [31:0] data1;
input reg signed [31:0] op2;
input sign;

wire [4:0] shamt;
input [4:0] aluop;
output  zero,neg;
output reg [31:0] result;

wire [31:0] operand1, operand2;
wire signed [31:0] addout,sllout,srlout,sraout,subout,andout,orout,xorout,unsubout;

assign zero = (result==0) ? 1'b1 : 1'b0;
assign neg = (result<0) ? 1'b1 : 1'b0;



 // operand 2 based on alusrc

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
	5'b01001:result=op2;
	default: result=0;
	endcase
end
endmodule


module pcadder(PC,imm,pcresult);
input reg [11:0] PC;
input reg signed [31:0] imm;
output reg  [11:0] pcresult;

always @(*) begin
pcresult<=PC+imm;
end
endmodule
