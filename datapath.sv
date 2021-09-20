
module datapath(clk);

input clk;
reg [11:0] PCnew,PCout,PCout2,PCim,PC4;
wire [11:0] PC4out;
reg [11:0] addrout,PCresult,PCresultout;
reg [31:0]instruction,instrout;
reg signed [31:0] imm,immout;
reg [4:0] rs1,rs2,rd,rdout,rdo2,rdo3,rs1out,rs2out;
reg [31:0] op2;
reg signed [31:0] wdata;
reg signed [31:0] data1,data1out,data2,data2out,data2out2,cacherdata,data2out3;
reg signed [31:0] op1fin,op2fin,data2fin;
reg pcsrc,branchdecide,pcsrcout,brout,cachehit,cachedone,cacheevict,cachehitout;
reg signed [31:0] result,resultout,resulto2,rdata, rdataout,rdatafin;
reg signed [31:0] comp1,comp2;
reg zero,neg,flush,flushneg,flushpos;
reg zeroout,negout;
reg[4:0] aluop,aluopout,aluopu;
reg alusrc,alusrcout,alusrcu,memtoreg,memtoregu,memtoregout,memtorego2, memtorego3, regwrite,regwriteu,regwriteout,regwriteo2,regwriteo3,memreadu,memread,memwrite,memwriteu,sign,signu,signout,signout2,memwriteout,memwriteout2,memreadout,memreadout2;//sign for loads if we r signextending
reg [2:0] branch,branchout,branchout2,branchu;
reg [1:0] length,lengthout,lengthout2,lengthu;
reg ctrlf,pcwrite,fdwrite;
reg [1:0] forwardA,forwardB,forwardC,forwardD,forwardE;




initial begin 
PCim=0; 
pcsrc=0;
pcsrcout=0;
branchdecide=0;
pcwrite=1;
fdwrite=1;
ctrlf=0;
forwardA=0;
forwardB=0;
forwardC=0;
forwardD=0;
forwardE=0;
end

assign cacheevict = ~cachehitout;

add4 pcadd4out(PCout,PC4out);
add4 pcadd4(PCim,PC4);

instructionmemory IM(PCim,instruction);

fetchdecode reg1(clk,pcsrc,pcsrcout,instruction, PCim,instrout,PCout, fdwrite,flush);

decoder decode(instrout, rs1,rs2,rd,imm);

registerfile rf(rs1,rs2,rdo3,regwriteo3, wdata,data1,data2);

controller control(instrout, aluop,alusrc, memtoreg, regwrite,branch, memread,memwrite, length,sign );

controllermux flushctrl(ctrlf, aluop,alusrc, memtoreg, regwrite,branch,memread,memwrite,length,sign,aluopu,alusrcu, memtoregu, regwriteu,branchu,memreadu,memwriteu,lengthu,signu);

decodeex reg2(clk,rs1,rs1out,rs2,rs2out,PCout,imm,immout,data1,data2,rd,regwriteu,signu,memtoregu,memwriteu,memreadu,lengthu, alusrcu,branchu,aluopu,PCout2,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout,branchdecide,brout);

mux32 aluselect(immout,data2out,op2,alusrcout);

threemux32 aluforwardA(data1out,resultout,wdata,op1fin,forwardA);

threemux32 aluforwardB(op2,resultout,wdata,op2fin,forwardB); 

threemux32 data2forward(data2out, resultout,wdata,data2fin,forwardC);

ALU aluex(aluopout,signout,op1fin,op2fin,result,zero,neg);

pcadder PCADD(PCout, imm, PCresult);

exmem reg3(clk,data2fin,data2out2,result,resultout,zero,zeroout,neg,negout,rdout,rdo2,PCresult, PCresultout, memreadout,memreadout2,memwriteout,memwriteout2, lengthout, lengthout2, signout, signout2, regwriteout,regwriteo2, memtoregout,memtorego2,branchout,branchout2);

datamemory mem(data2out2,cachedone,cachehit, resultout, memreadout2,memwriteout2,lengthout2,rdata,signout2);

cache cachemem(clk,resultout,memreadout2,memwriteout2,cachehit,cacherdata,cacheevict,resulto2,rdataout,cachedone);
//branchdecision branchchoice(branchout2,zeroout,negout,pcsrc);

mux32 cacheormem(cacherdata,rdata,rdatafin,cachehit);

memwb reg4(clk,resultout,resulto2,rdatafin,rdataout,rdo3,rdo2,memtorego2, regwriteo2,memtorego3,regwriteo3,cachehit,cachehitout,data2out2,data2out3);

mux32 writeback(rdataout, resulto2,wdata, memtorego3);

mux11 pcmux(addrout,PC4,PCresult,PC4out,PCnew,pcsrc,flushpos,flushneg);

forwardingunit FU(rs1out,rs2out,rdo2,rdo3,regwriteo2,regwriteo3,memreadout,memwriteout, forwardA,forwardB,forwardC);

hazard_detection HD(pcsrcout,branchdecide,memreadout,regwriteout,memreadout2,branch,branchout, rs1,rs2,rdout,rdo2, ctrlf,pcwrite,fdwrite,flush,flushneg,flushpos);

decodeforward DFU(rs1,rs2, rdo2,rdo3, regwriteo2, regwriteo3,forwardD,forwardE);

threemux32 decodeforward1(data1,resultout,wdata,comp1,forwardD);

threemux32 decodeforward2(data2,resultout,wdata,comp2,forwardE); 

comparator comp(comp1, comp2, branchu, branchdecide);

branchpred BP(clk,brout, branchout, PCim,PCout2, pcsrc);

btb branchtar(clk,PCim,PCout2,branchout,PCresultout,addrout);

PCreg regpc(PCnew,clk,PCim,pcwrite);




endmodule







