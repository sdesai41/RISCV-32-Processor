module fetchdecode(clk,pcsrc,pcsrcout,instr, PC,instrout,PCout,fdwrite,flush); //reg between fetch and decode stage
parameter PCSIZE=16;

input clk, fdwrite, flush,pcsrc;
input reg [PCSIZE-1:0] PC;
input reg [31:0] instr;
output reg [PCSIZE-1:0] PCout;
output reg [31:0] instrout;
output reg pcsrcout;
always @ (posedge clk) begin
if (fdwrite && !flush) begin
PCout<=PC;
instrout<=instr;
pcsrcout<=pcsrc;
end
if (flush) begin
instrout<= 32'd0;
//PCout<= #5 PC;
//instrout<= #5 instr;


end

end
endmodule 

module decodeex(clk,rs1,rs1out,rs2,rs2out, PC,imm,immout,data1,data2,rd,regwrite,sign,memtoreg,memwrite,memread,length, alusrc,branch,aluop,PCout,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout,br,brout,instr,instrout,ctrlf,ctrlfout);
parameter PCSIZE=16;
input reg [31:0] instr;
output reg [31:0] instrout;
input clk;
input reg regwrite,sign,memtoreg,memread,alusrc,memwrite,br,ctrlf;
input reg [1:0] length;
input reg [2:0] branch;
input reg [4:0] aluop,rd, rs1,rs2;

input reg [PCSIZE-1:0] PC;
input reg signed [31:0] data1,data2,imm;

output reg regwriteout,signout,memtoregout,memreadout,alusrcout,memwriteout,brout,ctrlfout;
output reg [1:0] lengthout;
output reg [2:0] branchout;
output reg [4:0] aluopout,rdout,rs1out,rs2out;

output reg [PCSIZE-1:0] PCout;
output reg signed [31:0] data1out,data2out,immout;
always @ (posedge clk) begin

instrout<=instr;
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
brout<=br;
ctrlfout<=ctrlf;

//
//PCout<= #5 PC;
//data1out<= #5 data1;
//data2out<= #5 data2;
//regwriteout<= #5 regwrite;
//signout<= #5 sign;
//memtoregout<= #5 memtoreg;
//memwriteout<= #5 memwrite;
//memreadout<= #5 memread;
//alusrcout<= #5 alusrc;
//branchout<= #5 branch;
//lengthout<=#5 length;
//aluopout<= #5 aluop;
//rdout<= #5 rd;
//immout<=#5 imm;
//rs2out<=#5 rs2;
//rs1out<= #5 rs1;

end
endmodule

module exmem(clk,data2,data2out,result,resultout,zero,zeroout,neg,negout,rd,rdout,PCresult, PCresultout, memread,memreadout,memwrite,memwriteout, length, lengthout, sign, signout, regwrite,regwriteout, memtoreg,memtoregout,branch,branchout);
parameter PCSIZE=16;

input clk;
input reg regwrite,sign,memtoreg,memread,zero,memwrite,neg;
input reg [1:0] length;
input reg [2:0] branch;
input reg [4:0] rd;

input reg [PCSIZE-1:0] PCresult;
input reg signed [31:0] result,data2;

output reg regwriteout,signout,memtoregout,memreadout,zeroout,negout,memwriteout;
output reg [1:0] lengthout;
output reg [2:0] branchout;
output reg [4:0]  rdout;

output reg [PCSIZE-1:0] PCresultout;
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


//PCresultout<=#5 PCresult;
//resultout<= #5 result;
//data2out<=#5 data2;
//regwriteout<= #5 regwrite;
//signout<= #5 sign;
//memtoregout<= #5 memtoreg;
//memwriteout<= #5 memwrite;
//memreadout<= #5 memread;
//zeroout<= #5 zero;
//negout<=#5 neg;
//branchout<=#5 branch;
//lengthout<=#5 length;
//rdout<=#5 rd;

end
endmodule

module memwb(clk,result,resultout, rdata,rdataout,rdout,rd,memtoreg, regwrite,memtoregout,regwriteout,cachehit,cachehitout,data2out2,data2out3);

input clk;
input reg regwrite,memtoreg,cachehit;
input reg [4:0] rd;
input reg signed [31:0] rdata,result,data2out2;

output reg regwriteout,memtoregout,cachehitout;
output reg [4:0]  rdout;

output reg signed [31:0] rdataout,resultout,data2out3;

always @ (posedge clk) begin

rdataout<= rdata;
resultout<= result;
regwriteout<= regwrite;
memtoregout<=memtoreg;
rdout<=rd;
cachehitout<=cachehit;
data2out3<=data2out2;


//rdataout<=#5 rdata;
//resultout<=#5 result;
//regwriteout<=#5 regwrite;
//memtoregout<=#5 memtoreg;
//rdout<=#5 rd;

end
endmodule 

module PCreg(PC,clk,PCout,pcwrite);
parameter PCSIZE=16;
input reg [PCSIZE-1:0] PC;
output reg [PCSIZE-1:0] PCout;
input pcwrite, clk;

always @(posedge clk) begin
if (pcwrite) begin
PCout<=PC;
//PCout<=#5 PC;
end
end
endmodule
