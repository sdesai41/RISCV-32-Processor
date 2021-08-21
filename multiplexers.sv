module multiplexer(in1,in2,out,sel); // 1 bit multiplexer

input in1,in2,sel;
output out;

assign out= sel ? in1: in2;

endmodule

module mux32(in1,in2,out,sel); // 32 bit input mux

input [31:0] in1,in2;
input sel;
output [31:0] out;

assign out= sel ? in1: in2;
endmodule 

module mux11(in1,in2,out,sel); //11 bit input mux

input [11:0] in1,in2;
input sel;
output [11:0] out;

assign out= sel ? in1: in2;

endmodule

module threemux32(data1,data2,data3,out,sel);

input reg [31:0] data1,data2,data3;
input [1:0] sel; 
output reg [31:0] out;

always @(*) begin
 case(sel)
 2'b00: out=data1;
 2'b01: out=data2;
 2'b10: out=data3;
 default: out=data1;
 endcase
 end
endmodule

module controllermux(ctrlf,aluop,alusrc, memtoreg, regwrite,branch,memread,memwrite,length,sign,aluopout,alusrcout, memtoregout, regwriteout,branchout,memreadout,memwriteout,lengthout,signout);
input ctrlf;
input reg[4:0] aluop; // alu control
input reg alusrc,memtoreg,regwrite,memread,memwrite, sign;//sign for loads if we r signextending, sign=0 for unsigned operations
input reg [2:0] branch; // for branch type
input reg [1:0] length; // for loads and stores
output reg[4:0] aluopout; // alu control
output reg alusrcout,memtoregout,regwriteout,memreadout,memwriteout, signout;//sign for loads if we r signextending, sign=0 for unsigned operations
output reg [2:0] branchout; // for branch type
output reg [1:0] lengthout; // for loads and stores

always @ (*) begin
if (ctrlf) begin
aluopout<=0;
alusrcout<=0;
regwriteout<=0;
memtoregout<=0;
memreadout<=0;
memwriteout<=0;
signout<=0;
branchout<=0;
lengthout<=0;
end
else begin
aluopout<=aluop;
alusrcout<=alusrc;
regwriteout<=regwrite;
memtoregout<=memtoreg;
memreadout<=memread;
memwriteout<=memwrite;
signout<=sign;
branchout<=branch;
lengthout<=length;
end
end
endmodule
