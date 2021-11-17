module datapathtest(currin);

output [31:0] currin;
reg clk;
integer i;
assign currin=0;
reg [16:0] count;
datapath dp(clk);

initial begin 
clk=0;
count=0;
end



always begin
#500 clk=~clk;

#5 
if (clk) begin
count++;
$display("count=%d",count);
end


end

endmodule 
