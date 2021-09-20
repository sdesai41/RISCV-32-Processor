module instructionmemory(PCn,data_out);

reg [7:0] im [0:4095];
//input clk;
input reg [11:0] PCn;
output reg [31:0] data_out;

initial begin // setting instruction memory
//PC=0;
//r-type
/*
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
im[16]=8'd19; 
im[17]= 8'd120; 
im[18]=8'd7; 
im[19]=8'd1;
im[20]=8'd179; 
im[20+1]= 8'd104;
im[20+2]=8'd216;
im[20+3]=8'd0;
im[24]=8'd51; 
im[24+1]= 8'd9; 
im[24+2]=8'd216; 
im[24+3]=8'd0;
*/
////lw/sw
/*
im[0]=8'd19; im[1]= 8'd6; im[2]=8'd80; im[3]=8'd0;

im[4]=8'd147; im[4+1]= 8'd102; im[4+2]=8'd176; im[4+3]=8'd0;

im[8]=8'd35; im[8+1]= 8'd34; im[8+2]=8'd192; im[8+3]=8'd0;

im[12]=8'd35; im[12+1]= 8'd36; im[12+2]=8'd208; im[12+3]=8'd0;

im[16]=8'd19; im[16+1]= 8'd118; im[16+2]=8'd6; im[16+3]=8'd0;

im[20]=8'd3; im[20+1]= 8'd38; im[20+2]=8'd70; im[20+3]=8'd0;

//copied line
im[24]=8'd3; im[24+1]= 8'd38; im[24+2]=8'd64; im[24+3]=8'd0;

im[28]=8'd51; im[28+1]= 8'd135; im[28+2]=8'd198; im[28+3]=8'd0;

im[32]=8'd179; im[32+1]= 8'd246; im[32+2]=8'd6; im[32+3]=8'd0;

im[36]=8'd179; im[36+1]= 8'd135; im[36+2]=8'd198; im[36+3]=8'd64;

im[40]=8'd131; im[40+1]= 8'd38; im[40+2]=8'd128; im[40+3]=8'd0;

im[44]=8'd51; im[44+1]= 8'd136; im[44+2]=8'd198; im[44+3]=8'd64;

im[48]=8'd179; im[48+1]= 8'd8; im[48+2]=8'd248; im[48+3]=8'd64;

im[52]=8'd131; im[52+1]= 8'd38; im[52+2]=8'd128; im[52+3]=8'd0;

*/


//branch

im[0]=8'd19; im[1]= 8'd6; im[2]=8'd80; im[3]=8'd0;

im[4]=8'd99; im[4+1]= 8'd4; im[4+2]=8'd6; im[4+3]=8'd6;

im[8]=8'd35; im[8+1]= 8'd34; im[8+2]=8'd192; im[8+3]=8'd0;

im[12]=8'd147; im[12+1]= 8'd6; im[12+2]=8'd112; im[12+3]=8'd0;

im[16]=8'd99; im[16+1]= 8'd4; im[16+2]=8'd198; im[16+3]=8'd0;

im[20]=8'd147; im[20+1]= 8'd102; im[20+2]=8'd240; im[20+3]=8'd0;

im[24]=8'd3; im[24+1]= 8'd39; im[24+2]=8'd64; im[24+3]=8'd0;

im[28]=8'd179; im[28+1]= 8'd135; im[28+2]=8'd230; im[28+3]=8'd64;

im[32]=8'd35; im[32+1]= 8'd36; im[32+2]=8'd240; im[32+3]=8'd00;

im[36]=8'd19; im[36+1]= 8'd8; im[36+2]=8'd0; im[36+3]=8'd0;

im[40]=8'd51; im[40+1]= 8'd8; im[40+2]=8'd6; im[40+3]=8'd1;

im[44]=8'd19; im[44+1]= 8'd6; im[44+2]=8'd246; im[44+3]=8'd255;

im[48]=8'd99; im[48+1]= 8'd14; im[48+2]=8'd6; im[51]=8'd2;

im[52]=8'd227 ; im[52+1]= 8'd10; im[54]=8'd198; im[55]=8'd254;
//*/
end
always @ (*) begin //reSading pc to output instruction
data_out={im[PCn+3],im[PCn+2],im[PCn+1],im[PCn]};
//data_out=#5 {im[PCn+3],im[PCn+2],im[PCn+1],im[PCn]};
end

endmodule 

module add4(PC,PC4); //incrementing PC by 4
//input clk;
input [11:0] PC;
output  [11:0] PC4;
assign PC4=PC+12'd4;

endmodule 