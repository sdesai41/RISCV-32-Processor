module datamemory(wdata, address, memread, memwrite, length, rdata,sign);

input [31:0] wdata,address;
input memread, memwrite,sign;
input [1:0] length;
output reg [31:0] rdata;
reg [7:0] dm [0:4095];

always @ (*) begin
	
	if (memwrite) begin
		case(length)
		2'b00: begin
		dm[address]=wdata[7:0];
		dm[address+1]=wdata[15:8];
		dm[address+2]=wdata[23:16];
		dm[address+3]=wdata[31:24];
		end
		2'b01: dm[address]=wdata[7:0];
		2'b10: begin
		dm[address]=wdata[7:0];
		dm[address+1]=wdata[15:8];
		end
	endcase
	end 
	if (memread) begin
		case(length)
		2'b00: begin
		rdata[7:0]=dm[address];
		rdata[15:8]=dm[address+1];
		rdata[23:16]=dm[address+2];
		rdata[31:24]=dm[address+3];
		end
		2'b01: begin 
			if(sign) begin
			rdata={{24{dm[address][7]}},dm[address]};
			end
			else begin
			rdata={{24{1'b0}},dm[address]};
			end
		end
		2'b10: begin
		if (sign) begin
		rdata={{16{dm[address+1][7]}},dm[address+1],dm[address]};
		end
		else begin 
		rdata={{16{1'b0}},dm[address+1],dm[address]};
		end
	end	
	endcase
end	
end
endmodule

module branchdecision(branch,zero, neg,pcsrc);

input [2:0] branch;
input reg zero, neg;
output reg pcsrc;

always @(*) begin

case(branch)

3'b000: pcsrc=1'b0;
3'b001: begin
	if(zero) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b010: begin
	if(!zero) begin
		pcsrc=1;
	end
	else begin 
		pcsrc=0;
	end
end
3'b011: begin
if(neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b100:  begin
if(!neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b101: begin
if(neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b110: begin
if(!neg) begin
	pcsrc=1;
	end
	else begin 
	pcsrc=0;
	end
end
3'b111: pcsrc=1;
endcase
end
endmodule 

