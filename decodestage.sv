module decoder(instruction,rs1,rs2,rd,imm);

input reg [31:0] instruction;
output reg signed [31:0] imm;
output [4:0] rs1,rs2,rd;
wire [6:0] opcode;

assign opcode=instruction[6:0];
assign rd= instruction[11:7];
assign rs1= instruction[19:15];
assign rs2= instruction[24:20];



always @ (instruction) begin

	case(opcode)
		7'b0110111: imm={instruction[31:20], {20{1'b0}}}; //lui auipc
		7'b0010111:  imm={instruction[31:20], {20{1'b0}}};
		7'b1101111: imm={{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction [24:21], 1'b0};
		7'b1100111: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b0010011: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b0000011: imm={{21{instruction[31]}}, instruction[30:20]};
		7'b1100011: imm= {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
		7'b0100011: imm={{21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7]};
		default: imm={{21{instruction[31]}}, instruction[30:20]};
endcase

end

endmodule

module registerfile(rs1,rs2,rd,write,wdata,data1,data2);

input [4:0] rs1,rs2,rd;
input reg signed [31:0] wdata;
input write;
output reg signed [31:0] data1,data2;

reg signed [31:0] rf [0:31];

always @(*) begin

rf[0]=0;
if (write) begin;
	rf[rd]=wdata;
	end
data1=rf[rs1];
data2=rf[rs2];
rf[0]=0;
end

endmodule