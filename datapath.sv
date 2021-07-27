
module datapath(clk);


reg [11:0] PCnew,PCout,PCout2,PCim;
reg [31:0]instruction,instrout;
reg signed [31:0] imm,immout;
reg [4:0] rs1,rs2,rd,rdout,rdo2,rdo3;
reg [31:0] op2;
reg[6:0] funct7;
reg [2:0] funct3;
reg signed [31:0] wdata;
reg signed [31:0] data1,data1out,data2,data2out,data2out2;
reg signed [31:0] op1fin,op2fin;
reg pcsrc;
reg signed [31:0] rdata,result,resultout,resulto2,rdataout;
wire zero,neg;
reg zeroout,negout;
reg[4:0] aluop,aluopout,aluopu;
reg alusrc,alusrcout,alusrcu,memtoreg,memtoregu,memtoregout,memtorego2, memtorego3, regwrite,regwriteu,regwriteout,regwriteo2,regwriteo3,memreadu,memread,memwrite,memwriteu,signu,signout,signout2,memwriteout,memwriteout2,memreadout,memreadout2;//sign for loads if we r signextending
reg [2:0] branch,branchout,branchout2,branchu;
reg [1:0] length,lengthout,lengthout2,lengthu;
reg [11:0] PCresult,PCresultout;
reg [11:0] PC4;
input clk;
reg ctrlf,pcwrite,fdwrite;
reg [1:0] forwardA,forwardB;


initial begin 
PCnew=0; 
pcsrc=0;
ctrlf=0;
pcwrite=1;
fdwrite=1;
forwardA=0;
forwardB=0;
end

add4 pcadd4(PCnew,clk, PC4);

instructionmemory IM(PCim, clk, instruction);

fetchdecode reg1(clk, instruction, PCnew,instrout,PCout, fdwrite);

decoder decode(instrout, rs1,rs2,rd, imm, funct7,funct3);

registerfile rf(rs1,rs2,rdo3,regwriteo3, wdata,data1,data2);

controller control(instrout, aluop,alusrc, memtoreg, regwrite,branch, memread,memwrite, length,sign );

controllermux flushctrl(ctrlf, aluop,alusrc, memtoreg, regwrite,branch,memread,memwrite,length,sign,aluopu,alusrcu, memtoregu, regwriteu,branchu,memreadu,memwriteu,lengthu,signu);

decodeex reg2(clk,PCout,imm,immout,data1,data2,rd,regwriteu,signu,memtoregu,memwriteu,memreadu,lengthu, alusrcu,branchu,aluopu,PCout2,data1out,data2out,rdout,regwriteout,signout,memtoregout,memreadout,lengthout, alusrcout,branchout,aluopout,memwriteout);

mux32 aluselect(immout,data2out,op2,alusrcout);

threemux32 aluforwardA(data1out,resultout,wdata,op1fin,forwardA);

threemux32 aluforwardB(op2,resultout,wdata,op2fin,forwardB); 

ALU aluex(aluopout,signout,op1fin,op2fin,result,zero,neg);

pcadder PCADD(PCout2, immout, PCresult);

exmem reg3(clk,data2out,data2out2,result,resultout,zero,zeroout,neg,negout,rdout,rdo2,PCresult, PCresultout, memreadout,memreadout2,memwriteout,memwriteout2, lengthout, lengthout2, signout, signout2, regwriteout,regwriteo2, memtoregout,memtorego2,branchout,branchout2);

datamemory mem(data2out2, resultout, memreadout2,memwriteout2,lengthout2,rdata,signout2);

branchdecision branchchoice(branchout2,zeroout,negout,pcsrc);

memwb reg4(clk,resultout,resulto2, rdata,rdataout,rdo3,rdo2,memtorego2, regwriteo2,memtorego3,regwriteo3);

mux32 writeback(rdataout, resulto2,wdata, memtorego3);

mux11 pcmux(PCresultout,PC4,PCnew,pcsrc);

forwardingunit FU(rs1,rs2,rdo2,rdo3,regwriteo2, regwriteo3, forwardA,forwardB);

hazard_detection HD(memreadout, rs1,rs2,rdout, ctrlf,pcwrite,fdwrite);

PCreg regpc(PCnew,PCim,pcwrite);




endmodule







