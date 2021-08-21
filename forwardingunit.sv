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


module hazard_detection(memread, rs1,rs2,rd, ctrlf,pcwrite,fdwrite);

input reg memread;
input [4:0] rs2,rs1,rd;
output reg ctrlf,pcwrite,fdwrite;

always @(*) begin
#5
	if(memread && (rs1==rd || rs2==rd)) begin
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
