module multiplexer(in1,in2,out,sel); // 1 bit multiplexer

input in1,in2,sel;
output out;

assign out= sel ? in1: in2;

endmodule

module mux32(in1,in2,out,sel); // 32 bit input mux

input [31:0] in1,in2;
input sel;
output [31:0] out;

assign out= sel ? in1: in2;
endmodule 

module mux11(in1,in2,out,sel); //11 bit input mux

input [11:0] in1,in2;
input sel;
output [11:0] out;

assign out= sel ? in1: in2;

endmodule

module threemux32(data1,data2,data3,out,sel);

input reg [31:0] data1,data2,data3;
input [2:0] sel; 
output reg [31:0] out;

always @(*) begin
 case(sel)
 2'b00: out=data1;
 2'b01: out=data2;
 2'b10: out=data3;
 default: out=data1;
 endcase
 end
endmodule

