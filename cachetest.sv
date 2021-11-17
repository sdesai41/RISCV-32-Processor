module cachetest(out);

parameter ADDRSIZE=32;
parameter TAGSIZE=28;
parameter DATASIZE=32;
parameter INDEXSIZE=4; // 2^ Indexsize rows 
parameter ROWS=16;

reg clk;
reg read,write,evict;
reg [DATASIZE-1:0] evdata;
reg [ADDRSIZE-1:0] addr,evaddr;
reg hit,done;
reg [DATASIZE-1:0] dataout;
output reg out;

assign out=0;

cache test(clk,addr,read,write,hit,dataout,evict,evaddr,evdata,done);

initial begin 

clk=0;
#5
write=1;
read=0;
addr=4;
evaddr=19;
evict=0;
evdata=20;
#190
read=1;
write=0;
addr=4;
evaddr=4;
evict=1;
evdata=5;
#190
read=1;
write=0;
addr=8;
evaddr=4;
evict=0;
evdata=5;
#190
read=0;
write=0;
addr=4;
evaddr=8;
evict=1;
evdata=11;
#190
read=1;
write=0;
addr=8;
evaddr=4;
evict=0;
evdata=5;

end

always begin 
#100 clk=~clk; 
end

endmodule
