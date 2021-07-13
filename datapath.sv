
module instructionmemory(PCn,clk,data_out);

reg [7:0] im [0:4095];
input clk;
input reg [11:0] PCn;
output reg [31:0] data_out;

initial begin
//PC=0;

im[0]=8'd19; im[1]= 8'd6; im[2]=8'd80; im[3]=8'd0;

im[4]=8'd147; im[4+1]= 8'd102; im[4+2]=8'd176; im[4+3]=8'd0;


im[8]=8'd35; im[8+1]= 8'd34; im[8+2]=8'd192; im[8+3]=8'd0;
//data_in={8'd51, 8'd135,8'd198,8'd0};

im[12]=8'd35; im[12+1]= 8'd36; im[12+2]=8'd208; im[12+3]=8'd0;
//data_in={8'd179, 8'd135,8'd198,8'd64};

im[16]=8'd19; im[16+1]= 8'd118; im[16+2]=8'd6; im[16+3]=8'd0;
//data_in={8'd147, 8'd102,8'd176,8'd0};

im[20]=8'd3; im[20+1]= 8'd38; im[20+2]=8'd70; im[20+3]=8'd0;
//data_in={8'd19, 8'd120,8'd7,8'd1};


im[24]=8'd51; im[24+1]= 8'd135; im[24+2]=8'd198; im[24+3]=8'd0;
//data_in={8'd179, 8'd104,8'd216,8'd0};


im[28]=8'd179; im[28+1]= 8'd246; im[28+2]=8'd6; im[28+3]=8'd0;

im[32]=8'd179; im[32+1]= 8'd135; im[32+2]=8'd198; im[32+3]=8'd64;


im[36]=8'd131; im[36+1]= 8'd38; im[36+2]=8'd128; im[36+3]=8'd0;


im[40]=8'd51; im[40+1]= 8'd136; im[40+2]=8'd198; im[40+3]=8'd64;


im[44]=8'd179; im[44+1]= 8'd8; im[44+2]=8'd248; im[44+3]=8'd64;

end
always @(posedge clk) begin

data_out={im[PCn+3],im[PCn+2],im[PCn+1],im[PCn]};
end

endmodule 

module multiplexer(in1,in2,out,sel);

input in1,in2,sel;
output out;

assign out= sel ? in1: in2;

endmodule

module mux32(in1,in2,out,sel);

input [31:0] in1,in2;
input sel;
output [31:0] out;

assign out= sel ? in1: in2;
endmodule 

module mux11(in1,in2,out,sel);

input [11:0] in1,in2;
input sel;
output [11:0] out;

assign out= sel ? in1: in2;


endmodule

module decoder(instruction,rs1,rs2,rd,imm,  funct7,funct3);

input reg [31:0] instruction;
output reg signed [31:0] imm;
output [4:0] rs1,rs2,rd;
output[6:0] funct7;
output [2:0] funct3;
wire [6:0] opcode;

assign opcode=instruction[6:0];
assign rd= instruction[11:7];
assign rs1= instruction[19:15];
assign rs2= instruction[24:20];
assign funct7=instruction[31:25];
assign funct3= instruction[14:12];


always @ (instruction) begin

	case(opcode)
		7'b0110111: imm={instruction[31:20], {20{1'b0}}}; //lui auipc
		7'b0010111:  imm={instruction[31:20], {20{1'b0}}};
		7'b1101111: imm={{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction [24:21], 1'b0};
		7'b1100111: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b0010011: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b0000011: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b1100011: imm= {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
		7'b0100011: imm={{21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7]};
	default: imm={{21{instruction[31]}}, instruction[30:20]};
endcase

end

endmodule

module registerfile(rs1,rs2,rd,write,wdata,data1,data2);

input [4:0] rs1,rs2,rd;
input reg signed [31:0] wdata;
input write;
output reg signed [31:0] data1,data2;

reg signed [31:0] rf [0:31];

always @(*) begin

rf[0]=0;
if (write) begin;
	rf[rd]=wdata;
	end
data1=rf[rs1];
data2=rf[rs2];
rf[0]=0;
end

endmodule

module controller(instruction, aluop,alusrc, memtoreg, regwrite,branch,memread,memwrite,length,sign);

input [31:0] instruction;
output reg[4:0] aluop;
output reg alusrc,memtoreg,regwrite,memread,memwrite, sign;//sign for loads if we r signextending
output reg [2:0] branch;
output reg [1:0] length; // for loads and stores


always @ (instruction) begin
	case(instruction[6:0])
		7'b0110011: begin //rtype
						regwrite=1;
						alusrc=0;
						branch=0;
						memwrite=0;
						memread=0;
						memtoreg=0;
						length=2'b00;
						
						if (instruction[14:12]==3'b000 && instruction[31:25]==7'b0000000) begin//add
							aluop=5'b00000;
							sign=1;
							end
						else if (instruction[14:12]==3'b000 && instruction[31:25]==7'b0100000) begin//subtract
							aluop=5'b00001;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//shift left logical
							aluop=5'b00010;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//compare signed (sub)
							aluop=5'b01000;
							sign=1;
							end
						else if (instruction[14:12]==3'b011) begin//compare unsigned (sub)
							aluop=5'b01000;
							sign=0;
							end
						else if (instruction[14:12]==3'b100) begin // xor
							aluop=5'b00011;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0000000) begin //SRL
							aluop=5'b00100;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0100000) begin //SRA
							aluop=5'b00101;
							sign=1;
							end
						else if (instruction[14:12]==3'b110) begin// or
							aluop=5'b00110;
							sign=1;
							end
						else if (instruction[14:12]==3'b111) begin // and
							aluop=5'b00111;
							sign=1;
							end
							end
			7'b0010011:  begin //itype
						regwrite=1;
						alusrc=1;
						branch=0;
						memwrite=0;
						memread=0;
						memtoreg=0;
						length=2'b00;
						
						if (instruction[14:12]==3'b000) begin//add
							aluop=5'b00000;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//shift left logical
							aluop=5'b00010;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//compare signed (sub)
							aluop=5'b01000;
							sign=1;
							end
						else if (instruction[14:12]==3'b011) begin//compare unsigned (sub)
							aluop=5'b01000;
							sign=0;
							end
						else if (instruction[14:12]==3'b100) begin // xor
							aluop=5'b00011;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0000000) begin //SRL
							aluop=5'b00100;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0100000) begin //SRA
							aluop=5'b00101;
							sign=1;
							end
						else if (instruction[14:12]==3'b110) begin// or
							aluop=5'b00110;
							sign=1;
							end
						else if (instruction[14:12]==3'b111) begin // and
							aluop=5'b00111;
							sign=1;
							end
							end
			7'b0100011:  begin //stype
						regwrite=0;
						alusrc=1;
						branch=0;
						memwrite=1;
						memread=0;
						memtoreg=0;
						sign=1;
						aluop=5'b00000;
						if (instruction[14:12]==3'b000) begin//1 byte
							length=2'b01;
							end
						else if (instruction[14:12]==3'b001) begin//halfword
							length=2'b10;
							end
						else if (instruction[14:12]==3'b010) begin//word
							length=2'b00;
							end
					end
			7'b0000011:  begin //loadtype
						regwrite=1;
						alusrc=1;
						branch=0;
						memwrite=0;
						memread=1;
						memtoreg=1;
						aluop=5'b00000;
						if (instruction[14:12]==3'b000) begin//1 byte
							length=2'b01;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//halfword
							length=2'b10;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//word
							length=2'b00;
							sign=1;
							end
						else if (instruction[14:12]==3'b100) begin//byte unsigned
							length=2'b01;
							sign=0;
							end
						else if (instruction[14:12]==3'b101) begin//halfword unsigned
							length=2'b10;
							sign=0;
							end
					end
			7'b1100011:  begin //branchtype
						regwrite=0;
						alusrc=0;
						
						memwrite=0;
						memread=1;
						memtoreg=1;
						length=0;
						aluop=5'b00001;
						if (instruction[14:12]==(3'b000)) begin
							sign=1;
							branch=3'b001;
						end
						else if (instruction[14:12]==(3'b001)) begin
						sign=1;
						branch=3'b010;
						end
						else if (instruction[14:12]==(3'b100)) begin
						sign=1;
						branch=3'b011;
						end
						else if (instruction[14:12]==(3'b101)) begin
						sign=1;
						branch=3'b100;
						end
						else if (instruction[14:12]==(3'b111)) begin
						sign=0;
						branch=3'b110;
						end
						else if (instruction[14:12]==(3'b110)) begin
						sign=0;
						branch=3'b101;
						end
					end
			7'b0110111: begin //LUI
							regwrite=1;
							alusrc=1;
							branch=0;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b01001;
							sign=1;
							end
			7'b0010111: begin //AUIPC
							regwrite=0;
							alusrc=1;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			7'b1101111: begin //JAL
							regwrite=0;
							alusrc=0;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			7'b1100111: begin //JALR
							regwrite=1;
							alusrc=0;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			default:	begin
							regwrite=0;
							alusrc=0;
							branch=3'b000;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=0;
							end
			endcase
		end
endmodule

module datapath(clk);

//input [11:0] PC;
reg [11:0] PCnew,PCout,PCout2;
//input reg [7:0] im [0:4095];
reg [31:0]instruction,instrout;
reg signed [31:0] imm,immout;
reg [4:0] rs1,rs2,rd,rdout,rdo2,rdo3;
reg[6:0] funct7;
reg [2:0] funct3;
reg signed [31:0] wdata;
reg signed [31:0] data1,data1out,data2,data2out,data2out2;
reg pcsrc;
reg signed [31:0] rdata,result,resultout,resulto2,rdataout;
wire zero,neg;
reg zeroout,negout;
reg[4:0] aluop,aluopout;
reg alusrc,alusrcout,memtoreg,memtoregout,memtorego2, memtorego3, regwrite,regwriteout,regwriteo2,regwriteo3,memread,memwrite,signout,signout2,memwriteout,memwriteout2,memreadout,memreadout2;//sign for loads if we r signextending
reg [2:0] branch,branchout,branchout2;
reg [1:0] length,lengthout,lengthout2;
reg [11:0] PCresult,PCresultout;
reg [11:0] PC4;
input clk;

initial begin 
PCnew=0; 
pcsrc=0;
end

add4 pcadd4(PCnew,clk, PC4);

instructionmemory IM(PCnew, clk, instruction);

fetchdecode reg1(clk, instruction, PCnew,instrout,PCout);

decoder decode(instrout, rs1,rs2,rd, imm, funct7,funct3);

registerfile rf(rs1,rs2,rdo3,regwriteo3, wdata,data1,data2);

controller control(instrout, aluop,alusrc, memtoreg, regwrite,branch, memread,memwrite, length,sign );

decodeex reg2(clk,PCout,imm,immout,data1,data2,rd,regwrite,sign,memtoreg,memwrite,memread,length, alusrc,branch,aluop,PCout2,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout);


ALU aluex(aluopout,signout,immout,data1out,data2out,alusrcout,result,zero,neg);

pcadder PCADD(PCout2, immout,clk, PCresult);

exmem reg3(clk,data2out,data2out2,result,resultout,zero,zeroout,neg,negout,rdout,rdo2,PCresult, PCresultout, memreadout,memreadout2,memwriteout,memwriteout2, lengthout, lengthout2, signout, signout2, regwriteout,regwriteo2, memtoregout,memtorego2,branchout,branchout2);

datamemory mem(data2out2, resultout, memreadout2,memwriteout2,lengthout2,rdata,signout2);

branchdecision branchchoice(branchout2,zeroout,negout,pcsrc);

memwb reg4(clk,resultout,resulto2, rdata,rdataout,rdo3,rdo2,memtorego2, regwriteo2,memtorego3,regwriteo3);

mux32 writeback(rdataout, resulto2,wdata, memtorego3);

mux11 pcmux(PCresultout,PC4,PCnew,pcsrc);

endmodule

module ALU(aluop, sign, imm,data1,data2,alusrc,result, zero, neg);

input reg signed [31:0] imm;
input reg signed [31:0] data1,data2;
wire signed [31:0] op2;
input sign,alusrc;

wire [4:0] shamt;
input [4:0] aluop;
output  zero,neg;
output reg [31:0] result;

wire [31:0] operand1, operand2;
wire signed [31:0] addout,sllout,srlout,sraout,subout,andout,orout,xorout,unsubout;

assign zero = (result==0) ? 1'b1 : 1'b0;
assign neg = (result<0) ? 1'b1 : 1'b0;



mux32 aluselect(imm,data2,op2,alusrc);

assign operand1=data1;
assign operand2=op2;
assign shamt=op2[4:0];

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

module datamemory(wdata, address, memread, memwrite, length, rdata,sign);

input [31:0] wdata,address;
input memread, memwrite,sign;
input [1:0] length;
output reg [31:0] rdata;
reg [7:0] dm [0:4095];

always @ (*) begin
	
	if (memwrite) begin
		case(length)
		2'b00: begin
		dm[address]=wdata[7:0];
		dm[address+1]=wdata[15:8];
		dm[address+2]=wdata[23:16];
		dm[address+3]=wdata[31:24];
		end
		2'b01: dm[address]=wdata[7:0];
		2'b10: begin
		dm[address]=wdata[7:0];
		dm[address+1]=wdata[15:8];
		end
	endcase
	end 
	if (memread) begin
		case(length)
		2'b00: begin
		rdata[7:0]=dm[address];
		rdata[15:8]=dm[address+1];
		rdata[23:16]=dm[address+2];
		rdata[31:24]=dm[address+3];
		end
		2'b01: begin 
			if(sign) begin
			rdata={{24{dm[address][7]}},dm[address]};
			end
			else begin
			rdata={{24{1'b0}},dm[address]};
			end
		end
		2'b10: begin
		if (sign) begin
		rdata={{16{dm[address+1][7]}},dm[address+1],dm[address]};
		end
		else begin 
		rdata={{16{1'b0}},dm[address+1],dm[address]};
		end
	end	
	endcase
end	
end
endmodule

module branchdecision(branch,zero, neg,pcsrc);

input [2:0] branch;
input reg zero, neg;
output reg pcsrc;

always @(*) begin

case(branch)

3'b000: pcsrc=1'b0;
3'b001: begin
	if(zero) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b010: begin
	if(!zero) begin
		pcsrc=1;
	end
	else begin 
		pcsrc=0;
	end
end
3'b011: begin
if(neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b100:  begin
if(!neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b101: begin
if(neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b110: begin
if(!neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b111: pcsrc=1;
endcase
end
endmodule 


module pcadder(PC,imm,clk,pcresult);
input clk;
input reg [11:0] PC;
input reg signed [31:0] imm;
output reg  [11:0] pcresult;

always @(posedge clk) begin
#20
pcresult<=PC+imm;
end

endmodule

module add4(PC,clk, PC4);
input clk;
input reg[11:0] PC;
output reg [11:0] PC4;

always @(posedge clk) begin
#20
PC4<=PC+4;
end
endmodule

module fetchdecode(clk, instr, PC,instrout,PCout);
input clk;
input reg [11:0] PC;
input reg [31:0] instr;
output reg [11:0] PCout;
output reg [31:0] instrout;
always @ (posedge clk) begin
PCout<=PC;
instrout<=instr;
end
endmodule 

module decodeex(clk,PC,imm,immout,data1,data2,rd,regwrite,sign,memtoreg,memwrite,memread,length, alusrc,branch,aluop,PCout,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout);
input clk;
input reg regwrite,sign,memtoreg,memread,alusrc,memwrite;
input reg [1:0] length;
input reg [2:0] branch;
input reg [4:0] aluop, rd;

input reg [11:0] PC;
input reg signed [31:0] data1,data2,imm;

output reg regwriteout,signout,memtoregout,memreadout,alusrcout,memwriteout;
output reg [1:0] lengthout;
output reg [2:0] branchout;
output reg [4:0] aluopout, rdout;

output reg [11:0] PCout;
output reg signed [31:0] data1out,data2out,immout;
always @ (posedge clk) begin
PCout<=PC;
data1out<=data1;
data2out<=data2;
regwriteout<=regwrite;
signout<=sign;
memtoregout<=memtoreg;
memwriteout<=memwrite;
memreadout<=memread;
alusrcout<=alusrc;
branchout<=branch;
lengthout<=length;
aluopout<=aluop;
rdout<=rd;
immout<=imm;
end
endmodule

module exmem(clk,data2,data2out,result,resultout,zero,zeroout,neg,negout,rd,rdout,PCresult, PCresultout, memread,memreadout,memwrite,memwriteout, length, lengthout, sign, signout, regwrite,regwriteout, memtoreg,memtoregout,branch,branchout);

input clk;
input reg regwrite,sign,memtoreg,memread,zero,memwrite,neg;
input reg [1:0] length;
input reg [2:0] branch;
input reg [4:0] rd;

input reg [11:0] PCresult;
input reg signed [31:0] result,data2;

output reg regwriteout,signout,memtoregout,memreadout,zeroout,negout,memwriteout;
output reg [1:0] lengthout;
output reg [2:0] branchout;
output reg [4:0]  rdout;

output reg [11:0] PCresultout;
output reg signed [31:0] resultout,data2out;

always @ (posedge clk) begin
PCresultout<=PCresult;
resultout<=result;
data2out<=data2;
regwriteout<=regwrite;
signout<=sign;
memtoregout<=memtoreg;
memwriteout<=memwrite;
memreadout<=memread;
zeroout<=zero;
negout<=neg;
branchout<=branch;
lengthout<=length;
rdout<=rd;
end
endmodule

module memwb(clk,result,resultout, rdata,rdataout,rdout,rd,memtoreg, regwrite,memtoregout,regwriteout);

input clk;
input reg regwrite,memtoreg;
input reg [4:0] rd;
input reg signed [31:0] rdata,result;

output reg regwriteout,memtoregout;
output reg [4:0]  rdout;

output reg signed [31:0] rdataout,resultout;

always @ (posedge clk) begin
rdataout<=rdata;
resultout<=result;
regwriteout<=regwrite;
memtoregout<=memtoreg;
rdout<=rd;
end
endmodule 