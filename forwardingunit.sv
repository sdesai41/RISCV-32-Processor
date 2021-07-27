module forwardingunit(rs1,rs2,rdexmem,rdmemwb,rwriteexmem, rwritememwb, forwardA,forwardB);

input [4:0] rs1,rs2,rdexmem,rdmemwb;
input rwriteexmem, rwritememwb;
output reg [1:0] forwardA,forwardB;

always @ (*) begin

if (rs1!=0 && rs2!=0) begin

if (rs1==rdexmem && rwriteexmem)  begin

forwardA=2'b01;
end

else if (rs1==rdmemwb && rwritememwb) begin

forwardA=2'b10;

end 
else begin
forwardA=2'b00;
end
if (rs2==rdexmem && rwriteexmem)  begin

forwardB=2'b01;
end

else if (rs2==rdmemwb && rwritememwb) begin

forwardB=2'b10;
end 
else begin
forwardB=2'b00;
end
end
end
endmodule


module hazard_detection(memread, rs1,rs2,rd, ctrlf,pcwrite,fdwrite);

input reg memread;
input [4:0] rs2,rs1,rd;
output reg ctrlf,pcwrite,fdwrite;

always @(*) begin

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
