module forwardingunit(rs1,rs2,rdexmem,rdmemwb,rwriteexmem, rwritememwb,memreadout,memwriteout,forwardA,forwardB,forwardC);

input reg [4:0] rs1,rs2,rdexmem,rdmemwb;
input reg rwriteexmem, rwritememwb,memreadout,memwriteout;
output reg [1:0] forwardA,forwardB,forwardC;


always @ (*) begin

if (rs1!=0) begin

if (rs1==rdexmem && rwriteexmem)  begin
forwardA=2'b01;
end

else if ((rs1==rdmemwb) && (rwritememwb)) begin

forwardA=2'b10;

end 
else begin
forwardA=2'b00;
end
end
else begin
forwardA=2'b00;
end
if (rs2!=0) begin

if ((rs2==rdexmem) && (rwriteexmem)&& ~(memreadout || memwriteout))  begin
forwardB=2'b01;
end

else if ((rs2==rdmemwb) && (rwritememwb)  && ~(memreadout|| memwriteout)) begin
forwardB=2'b10;
end 

else begin
forwardB=2'b00;
end
if ((rs2==rdexmem) && (rwriteexmem)&& (memreadout||memwriteout))  begin
forwardC=2'b01;
end

else if ((rs2==rdmemwb) && (rwritememwb) && (memreadout || memwriteout)) begin
forwardC=2'b10;
end 

else begin
forwardC=2'b00;
end
end
else begin
forwardB=2'b00;
forwardC=2'b00;
end
end
endmodule


module hazard_detection(pcsrc,branchreal, memread,rwriteidex,memreadexmem,branch,branchout, rs1,rs2,rd,rdexmem, ctrlf,pcwrite,fdwrite,ifflush);

input reg memread,rwriteidex,memreadexmem, pcsrc,branchreal;
input reg [2:0] branch,branchout;
input [4:0] rs2,rs1,rd,rdexmem;
output reg ctrlf,pcwrite,fdwrite,ifflush;

always @(*) begin
#5
	if (pcsrc!=branchreal) begin
	ifflush=1;
	end
	else begin
	ifflush=0;
	end
	if(memread && (rs1==rd || rs2==rd)) begin
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else if (branch && rwriteidex && (rs1==rd || rs2==rd))begin
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else if (branchout && memreadexmem && (rs1==rdexmem || rs2==rdexmem)) begin
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else begin
		ctrlf=0;
		pcwrite=1;
		fdwrite=1;
	end
end
endmodule

module decodeforward(rs1,rs2,rdexmem,rdmemwb,rwriteexmem,rwritememwb,forwardD,forwardE);

input reg [4:0] rs1,rs2,rdexmem,rdmemwb;
input reg rwriteexmem, rwritememwb;
output reg [1:0] forwardD,forwardE;

always @ (*) begin

if (rs1!=0) begin

if (rs1==rdexmem && rwriteexmem)  begin
forwardD=2'b01;
end

else if ((rs1==rdmemwb) && (rwritememwb)) begin

forwardD=2'b10;
end 
else begin
forwardD=2'b00;
end
end
else begin
forwardD=2'b00;

end
if (rs2!=0) begin

if ((rs2==rdexmem) && (rwriteexmem))  begin
forwardE=2'b01;
end

else if ((rs2==rdmemwb) && (rwritememwb)) begin
forwardE=2'b10;
end 

else begin
forwardE=2'b00;
end
end
else begin 
forwardE=2'b00;
end 
end
endmodule





