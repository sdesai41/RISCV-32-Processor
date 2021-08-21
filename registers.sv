module fetchdecode(clk,instr, PC,instrout,PCout,fdwrite); //reg between fetch and decode stage
input clk, fdwrite;
input reg [11:0] PC;
input reg [31:0] instr;
output reg [11:0] PCout;
output reg [31:0] instrout;
always @ (posedge clk) begin
if (fdwrite) begin
//PCout<=PC;
//instrout<=instr;

PCout<= #5 PC;
instrout<= #5 instr;

end
end
endmodule 

module decodeex(clk,rs1,rs1out,rs2,rs2out, PC,imm,immout,data1,data2,rd,regwrite,sign,memtoreg,memwrite,memread,length, alusrc,branch,aluop,PCout,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout);

input clk;
input reg regwrite,sign,memtoreg,memread,alusrc,memwrite;
input reg [1:0] length;
input reg [2:0] branch;
input reg [4:0] aluop,rd, rs1,rs2;

input reg [11:0] PC;
input reg signed [31:0] data1,data2,imm;

output reg regwriteout,signout,memtoregout,memreadout,alusrcout,memwriteout;
output reg [1:0] lengthout;
output reg [2:0] branchout;
output reg [4:0] aluopout,rdout,rs1out,rs2out;

output reg [11:0] PCout;
output reg signed [31:0] data1out,data2out,immout;
always @ (posedge clk) begin
/*
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
rs2out<=rs2;
rs1out<=rs1;
*/

PCout<= #5 PC;
data1out<= #5 data1;
data2out<= #5 data2;
regwriteout<= #5 regwrite;
signout<= #5 sign;
memtoregout<= #5 memtoreg;
memwriteout<= #5 memwrite;
memreadout<= #5 memread;
alusrcout<= #5 alusrc;
branchout<= #5 branch;
lengthout<=#5 length;
aluopout<= #5 aluop;
rdout<= #5 rd;
immout<=#5 imm;
rs2out<=#5 rs2;
rs1out<= #5 rs1;

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
/*
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
*/

PCresultout<=#5 PCresult;
resultout<= #5 result;
data2out<=#5 data2;
regwriteout<= #5 regwrite;
signout<= #5 sign;
memtoregout<= #5 memtoreg;
memwriteout<= #5 memwrite;
memreadout<= #5 memread;
zeroout<= #5 zero;
negout<=#5 neg;
branchout<=#5 branch;
lengthout<=#5 length;
rdout<=#5 rd;

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
/*
rdataout<= rdata;
resultout<= result;
regwriteout<= regwrite;
memtoregout<=memtoreg;
rdout<=rd;
*/

rdataout<=#5 rdata;
resultout<=#5 result;
regwriteout<=#5 regwrite;
memtoregout<=#5 memtoreg;
rdout<=#5 rd;

end
endmodule 

module PCreg(PC,clk,PCout,pcwrite);

input reg [11:0] PC;
output reg [11:0] PCout;
input pcwrite, clk;

always @(posedge clk) begin
if (pcwrite) begin
//PCout<=PC;
PCout<=#5 PC;
end
end
endmodule
