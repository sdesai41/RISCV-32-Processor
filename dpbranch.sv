module dpbranch(out);

output reg [11:0] out;

reg [11:0] PC;

add4 test(PC,out);
initial begin

PC=0;
#50
PC=16;
#50
PC=24;
#50
PC=4096;
#50
PC=18;
#50
PC=44;
#50
$stop;
end
endmodule
