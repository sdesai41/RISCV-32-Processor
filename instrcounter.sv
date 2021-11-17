module instrcounter(instr,ctrlf);
parameter instrsize=32;

input reg [instrsize-1:0] instr;
input ctrlf;

reg [16:0] rcount,icount, bcount, loadcount, storecount,jtype, jrtype, auipc, lui;  

initial begin
rcount=0;
icount=0; 
bcount=0;
loadcount=0;
storecount=0;
jtype=0;
jrtype=0;
auipc=0;
lui=0;
end
always @(*) begin
$display("rcount=%d,icount=%d,bcount=%d,loadcount=%d,storecount=%d,jtype=%d,jrtype=%d ,auipc=%d,lui=%d", rcount,icount, bcount, loadcount, storecount,jtype, jrtype, auipc, lui); 
if (!ctrlf) begin
 case(instr[6:0])
			7'b0110011: rcount++;
			7'b0010011: icount++;
			7'b0100011: storecount++;
			7'b0000011: loadcount++;
			7'b1100011: bcount++;
			7'b0110111: lui++;
			7'b0010111: auipc++;
			7'b1101111: jtype++;
			7'b1100111: jrtype++;
			default:begin
			end
			endcase
end			
end
endmodule
