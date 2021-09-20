module datapathtest(currin);
//reg [11:0] PC;
//reg [7:0] im [0:4095];
output [31:0] currin;
reg clk;
integer i;
assign currin=0;

datapath dp(clk);

initial begin 
clk=0;
end


/*initial begin
Warning (10235): Verilog HDL Always Construct warning at decodestage.sv(20): variable "opcode" is read inside the Always Construct but isn't in the Always Construct's Event Control

//PC=0;
im[0]=8'd19; 
im[1]= 8'd6; 
im[2]=8'd80; 
im[3]=8'd0;

im[4]=8'd147;
im[5]= 8'd102; 
im[6]=8'd176; 
im[7]=8'd0;

im[8]=8'd51; 
im[9]= 8'd135; 
im[10]=8'd198; 
im[11]=8'd0;
//data_in={8'd51, 8'd135,8'd198,8'd0};
im[12]=8'd179; 
im[13]= 8'd135;
 im[14]=8'd198;
 im[15]=8'd64;
//data_in={8'd179, 8'd135,8'd198,8'd64};
im[16]=8'd19; 
im[17]= 8'd120; 
im[18]=8'd7; 
im[19]=8'd1;
//data_in={8'd147, 8'd102,8'd176,8'd0};
im[20]=8'd179; 
im[20+1]= 8'd104;
im[20+2]=8'd216;
im[20+3]=8'd0;
//data_in={8'd19, 8'd120,8'd7,8'd1};
im[24]=8'd51; 
im[24+1]= 8'd9; 
im[24+2]=8'd216; 
im[24+3]=8'd0;

//data_in={8'd179, 8'd104,8'd216,8'd0};
clk=1;

//PC=0;
//write=0;
//PC+=4;
//#500
//PC+=4;
//#500
//PC+=4;
//#500
//PC+=4;
//#500
//PC+=4;
//#500
//PC+=4;
//#500 
//PC+=4;
//#100
//PC=0;
end
*/
always begin
#500 clk=~clk;
end

endmodule 
