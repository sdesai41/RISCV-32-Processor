module controller(instruction, aluop,alusrc, memtoreg, regwrite,branch,memread,memwrite,length,sign);

input [31:0] instruction;
output reg[4:0] aluop; // alu control
output reg alusrc,memtoreg,regwrite,memread,memwrite, sign;//sign for loads if we r signextending, sign=0 for unsigned operations
output reg [2:0] branch; // for branch type
output reg [1:0] length; // for loads and stores


always @ (instruction) begin
	case(instruction[6:0])
		7'b0110011: begin //rtype
						regwrite=1;
						alusrc=0;
						branch=0;
						memwrite=0;
						memread=0;
						memtoreg=0;
						length=2'b00;
						
						if (instruction[14:12]==3'b000 && instruction[31:25]==7'b0000000) begin//add
							aluop=5'b00000;
							sign=1;
							end
						else if (instruction[14:12]==3'b000 && instruction[31:25]==7'b0100000) begin//subtract
							aluop=5'b00001;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//shift left logical
							aluop=5'b00010;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//compare signed (sub)
							aluop=5'b01000;
							sign=1;
							end
						else if (instruction[14:12]==3'b011) begin//compare unsigned (sub)
							aluop=5'b01000;
							sign=0;
							end
						else if (instruction[14:12]==3'b100) begin // xor
							aluop=5'b00011;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0000000) begin //SRL
							aluop=5'b00100;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0100000) begin //SRA
							aluop=5'b00101;
							sign=1;
							end
						else if (instruction[14:12]==3'b110) begin// or
							aluop=5'b00110;
							sign=1;
							end
						else if (instruction[14:12]==3'b111) begin // and
							aluop=5'b00111;
							sign=1;
							end
							end
			7'b0010011:  begin //itype
						regwrite=1;
						alusrc=1;
						branch=0;
						memwrite=0;
						memread=0;
						memtoreg=0;
						length=2'b00;
						
						if (instruction[14:12]==3'b000) begin//add
							aluop=5'b00000;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//shift left logical
							aluop=5'b00010;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//compare signed (sub)
							aluop=5'b01000;
							sign=1;
							end
						else if (instruction[14:12]==3'b011) begin//compare unsigned (sub)
							aluop=5'b01000;
							sign=0;
							end
						else if (instruction[14:12]==3'b100) begin // xor
							aluop=5'b00011;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0000000) begin //SRL
							aluop=5'b00100;
							sign=1;
							end
						else if (instruction[14:12]==3'b101 && instruction[31:25]==7'b0100000) begin //SRA
							aluop=5'b00101;
							sign=1;
							end
						else if (instruction[14:12]==3'b110) begin// or
							aluop=5'b00110;
							sign=1;
							end
						else if (instruction[14:12]==3'b111) begin // and
							aluop=5'b00111;
							sign=1;
							end
							end
			7'b0100011:  begin //stype
						regwrite=0;
						alusrc=1;
						branch=0;
						memwrite=1;
						memread=0;
						memtoreg=0;
						sign=1;
						aluop=5'b00000;
						if (instruction[14:12]==3'b000) begin//1 byte
							length=2'b01;
							end
						else if (instruction[14:12]==3'b001) begin//halfword
							length=2'b10;
							end
						else if (instruction[14:12]==3'b010) begin//word
							length=2'b00;
							end
					end
			7'b0000011:  begin //loadtype
						regwrite=1;
						alusrc=1;
						branch=0;
						memwrite=0;
						memread=1;
						memtoreg=1;
						aluop=5'b00000;
						if (instruction[14:12]==3'b000) begin//1 byte
							length=2'b01;
							sign=1;
							end
						else if (instruction[14:12]==3'b001) begin//halfword
							length=2'b10;
							sign=1;
							end
						else if (instruction[14:12]==3'b010) begin//word
							length=2'b00;
							sign=1;
							end
						else if (instruction[14:12]==3'b100) begin//byte unsigned
							length=2'b01;
							sign=0;
							end
						else if (instruction[14:12]==3'b101) begin//halfword unsigned
							length=2'b10;
							sign=0;
							end
					end
			7'b1100011:  begin //branchtype
						regwrite=0;
						alusrc=0;
						
						memwrite=0;
						memread=1;
						memtoreg=1;
						length=0;
						aluop=5'b00001;
						if (instruction[14:12]==(3'b000)) begin // BEQ
							sign=1;
							branch=3'b001;
						end
						else if (instruction[14:12]==(3'b001)) begin //BNE
						sign=1;
						branch=3'b010;
						end
						else if (instruction[14:12]==(3'b100)) begin// BLT
						sign=1;
						branch=3'b011;
						end
						else if (instruction[14:12]==(3'b101)) begin // BGE
						sign=1;
						branch=3'b100;
						end
						else if (instruction[14:12]==(3'b111)) begin // BGEU
						sign=0;
						branch=3'b110;
						end
						else if (instruction[14:12]==(3'b110)) begin// BLTU
						sign=0;
						branch=3'b101;
						end
					end
			7'b0110111: begin //LUI
							regwrite=1;
							alusrc=1;
							branch=0;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b01001;
							sign=1;
							end
			7'b0010111: begin //AUIPC
							regwrite=0;
							alusrc=1;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			7'b1101111: begin //JAL
							regwrite=0;
							alusrc=0;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			7'b1100111: begin //JALR
							regwrite=1;
							alusrc=0;
							branch=3'b111;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			default:	begin
							regwrite=0;
							alusrc=0;
							branch=3'b000;
							memwrite=0;
							memread=0;
							memtoreg=0;
							length=0;
							aluop=5'b00000;
							sign=1;
							end
			endcase
		end
endmodule