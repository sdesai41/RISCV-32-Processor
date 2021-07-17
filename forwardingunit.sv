module forwardingunit(rs1,rs2,rdexmem,rdmemwb,rwriteexmem, rwritememwb, forwardA,forwardB);

input [4:0] rs1,rs2,rdexmem,rdmemwb;
input rwriteexmem, rwritememwb;
output reg [1:0] forwardA,forwardB;

always @ (*) begin

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
endmodule