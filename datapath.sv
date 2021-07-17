
module datapath(clk);


reg [11:0] PCnew,PCout,PCout2;
reg [31:0]instruction,instrout;
reg signed [31:0] imm,immout;
reg [4:0] rs1,rs2,rd,rdout,rdo2,rdo3;
reg [31:0] op2;
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

mux32 aluselect(immout,data2out,op2,alusrcout);

ALU aluex(aluopout,signout,data1out,op2,result,zero,neg);

pcadder PCADD(PCout2, immout,clk, PCresult);

exmem reg3(clk,data2out,data2out2,result,resultout,zero,zeroout,neg,negout,rdout,rdo2,PCresult, PCresultout, memreadout,memreadout2,memwriteout,memwriteout2, lengthout, lengthout2, signout, signout2, regwriteout,regwriteo2, memtoregout,memtorego2,branchout,branchout2);

datamemory mem(data2out2, resultout, memreadout2,memwriteout2,lengthout2,rdata,signout2);

branchdecision branchchoice(branchout2,zeroout,negout,pcsrc);

memwb reg4(clk,resultout,resulto2, rdata,rdataout,rdo3,rdo2,memtorego2, regwriteo2,memtorego3,regwriteo3);

mux32 writeback(rdataout, resulto2,wdata, memtorego3);

mux11 pcmux(PCresultout,PC4,PCnew,pcsrc);

endmodule







