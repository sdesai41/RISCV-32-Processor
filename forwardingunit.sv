module forwardingunit(rs1,rs2,rdexmem,rdmemwb,rwriteexmem, rwritememwb,memreadout,memwriteout,forwardA,forwardB,forwardC);

input reg [4:0] rs1,rs2,rdexmem,rdmemwb;
input reg rwriteexmem, rwritememwb,memreadout,memwriteout;
output reg [1:0] forwardA,forwardB,forwardC;


always @ (*) begin

if (rs1!=0) begin

if (rs1==rdexmem && rwriteexmem)  begin // if we need result from exmem reg
forwardA=2'b01;
end

else if ((rs1==rdmemwb) && (rwritememwb)) begin //if we need writedata from memwb reg

forwardA=2'b10;

end 
else begin // no forwarding
forwardA=2'b00;
end
end
else begin
forwardA=2'b00;
end
if (rs2!=0) begin

if ((rs2==rdexmem) && (rwriteexmem)&& ~(memreadout || memwriteout))  begin // if we need result from exmem reg
forwardB=2'b01;
end

else if ((rs2==rdmemwb) && (rwritememwb)  && ~(memreadout|| memwriteout)) begin //if we need writedata from memwb reg

forwardB=2'b10;
end 

else begin //no forwarding
forwardB=2'b00;
end
//data2forwarding, only necessary for datawrites
if ((rs2==rdexmem) && (rwriteexmem)&& (memreadout||memwriteout))  begin //get data2 from exmem register
forwardC=2'b01;
end

else if ((rs2==rdmemwb) && (rwritememwb) && (memreadout || memwriteout)) begin // get data2 from memwb
forwardC=2'b10;
end 

else begin //no forward
forwardC=2'b00;
end
end
else begin
forwardB=2'b00;
forwardC=2'b00;
end
end
endmodule


module hazard_detection(pcsrc,branchreal, memread,rwriteidex,memreadexmem,branch,branchout, rs1,rs2,rd,rdexmem, ctrlf,pcwrite,fdwrite,ifflush,flushneg,flushpos);

input reg memread,rwriteidex,memreadexmem, pcsrc,branchreal;
input reg [2:0] branch,branchout;
input [4:0] rs2,rs1,rd,rdexmem;
output reg ctrlf,pcwrite,fdwrite,flushpos,flushneg;
output  ifflush;

assign ifflush = flushpos|flushneg; //flush if mispredicted
always @(*) begin
#5
	if (pcsrc!=branchreal && branchreal==0) begin //flush to PC+imm
	flushneg=1;
	flushpos=0;
	end
	else if (pcsrc!=branchreal && branchreal==1)  begin //flush to PC+4
	flushneg=0;
	flushpos=1;
	end
	else begin  //branch predicted correctly
	flushneg=0;
	flushpos=0;
	end
	if(memread && (rs1==rd || rs2==rd)) begin // load use stall
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else if (branch && rwriteidex && (rs1==rd || rs2==rd))begin // stall for branch comps
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else if (branchout && memreadexmem && (rs1==rdexmem || rs2==rdexmem)) begin //stall for  branch 
		ctrlf=1;
		pcwrite=0;
		fdwrite=0;
	end
	else begin //no flush
		ctrlf=0;
		pcwrite=1;
		fdwrite=1;
	end
end
endmodule

module decodeforward(rs1,rs2,rdexmem,rdmemwb,rwriteexmem,rwritememwb,forwardD,forwardE);
//branch forwarding
input reg [4:0] rs1,rs2,rdexmem,rdmemwb;
input reg rwriteexmem, rwritememwb;
output reg [1:0] forwardD,forwardE;

always @ (*) begin

if (rs1!=0) begin

if (rs1==rdexmem && rwriteexmem)  begin // get result from exmem reg
forwardD=2'b01;
end

else if ((rs1==rdmemwb) && (rwritememwb)) begin //get wdata from memwb reg

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
 // same setup as forward D
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





