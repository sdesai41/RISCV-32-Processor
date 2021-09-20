module datamemory(wdata,cache,cachehit, address, memread, memwrite, length, rdata,sign);

input cache,cachehit;
input [31:0] wdata,address;
input memread, memwrite,sign;
input [1:0] length;
output reg [31:0] rdata;
reg [7:0] dm [0:4095];

always @ (posedge cache) begin // once cache is done
	
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
		default:begin
		dm[address]=wdata[7:0];
		dm[address+1]=wdata[15:8];
		dm[address+2]=wdata[23:16];
		dm[address+3]=wdata[31:24];
		end
	endcase
	end 
	else if (memread) begin
		if (!cachehit) begin
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
		default: begin
			rdata[7:0]=dm[address];
			rdata[15:8]=dm[address+1];
			rdata[23:16]=dm[address+2];
			rdata[31:24]=dm[address+3];
			end
			endcase
		end	
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

module cache(clk,addr,read,write,hit,dataout,evict,evictaddr,evdata,done); //4 WAY SA one level
parameter ADDRSIZE=32;
parameter TAGSIZE=28;
parameter DATASIZE=32;
parameter INDEXSIZE=4; // 2^ Indexsize rows 
parameter ROWS=16;

input clk,read,write,evict;
input [DATASIZE-1:0] evdata;
input [ADDRSIZE-1:0] addr,evictaddr;
wire [INDEXSIZE-1:0] index,evindex;
wire [TAGSIZE-1:0] tag,evtag;
output reg hit,done;
integer i;

output reg [DATASIZE-1:0] dataout;

reg [TAGSIZE:0] tag1store [ROWS-1:0];
reg [TAGSIZE:0] tag2store [ROWS-1:0];
reg [TAGSIZE:0] tag3store [ROWS-1:0];
reg [TAGSIZE:0] tag4store [ROWS-1:0];
reg [DATASIZE-1:0] data1store [ROWS-1:0];
reg [DATASIZE-1:0] data2store [ROWS-1:0];
reg [DATASIZE-1:0] data3store [ROWS-1:0];
reg [DATASIZE-1:0] data4store [ROWS-1:0];

assign index= addr[INDEXSIZE-1:0];
assign tag= addr[ADDRSIZE-1: INDEXSIZE];
assign evindex= evictaddr[INDEXSIZE-1:0];
assign evtag= evictaddr[ADDRSIZE-1: INDEXSIZE];

initial begin
for (i=0; i<ROWS; i=i+1) begin//set valid bit =0 for all entries in each tagstore
tag1store[i][TAGSIZE]=1'b0;
tag2store[i][TAGSIZE]=1'b0;
tag3store[i][TAGSIZE]=1'b0;
tag4store[i][TAGSIZE]=1'b0;
end
done=0;
end

always @ (posedge clk) begin
	done=0;
#5
	 if (read && evict && evictaddr!=addr) begin// check if cache hits
	 $display("read/evict, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);
		if (tag1store[index][TAGSIZE]==1'b1 && tag1store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data1store[index];
		hit<=1;
		//done<=1;
		end
		else if (tag2store[index][TAGSIZE]==1'b1 && tag2store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data2store[index];
		hit<=1;
		//done<=1;
		end
		else if (tag3store[index][TAGSIZE]==1'b1 && tag3store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data3store[index];
		hit<=1;
		//done<=1;
		end
		else if (tag4store[index][TAGSIZE]==1'b1 && tag4store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data4store[index];
		hit<=1;
		//done<=1;
		end
		else begin //cache miss--evict (or write if compulsory miss)  is coming
		hit<=0;
		//done<=1;
		end
		//invalidate any matching tags for eviction
		if (tag1store[evindex][TAGSIZE]==1'b1 && tag1store[evindex][TAGSIZE-1:0]==evtag) begin
			tag1store[evindex][TAGSIZE]=1'b0;
			end
		if (tag2store[evindex][TAGSIZE]==1'b1 && tag2store[evindex][TAGSIZE-1:0]==evtag) begin
			tag2store[evindex][TAGSIZE]=1'b0;
			end
		if (tag3store[evindex][TAGSIZE]==1'b1 && tag3store[evindex][TAGSIZE-1:0]==evtag) begin
			tag3store[evindex][TAGSIZE]=1'b0;
			end
	#5
	//update tagstore and datastore
	tag4store[evindex]=tag3store[evindex];
	tag3store[evindex]=tag2store[evindex];
	tag2store[evindex]=tag1store[evindex];
	tag1store[evindex]={1'b1,tag};
	data4store[evindex]=data3store[evindex];
	data3store[evindex]=data2store[evindex];
	data2store[evindex]=data1store[evindex];
	data1store[evindex]=evdata;
	done=1;
	end
	else if (read && evict && evictaddr==addr) begin//if we are reading the addr that is being evicted forward data
	 $display("read/evict same, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);
		dataout<=evdata;
		hit<=1;
		done<=1;
	//invalidate data with matching tags (regular eviction procedure)
		if (tag1store[evindex][TAGSIZE]==1'b1 && tag1store[evindex][TAGSIZE-1:0]==evtag) begin
			tag1store[evindex][TAGSIZE]=1'b0;
			end
		if (tag2store[evindex][TAGSIZE]==1'b1 && tag2store[evindex][TAGSIZE-1:0]==evtag) begin
			tag2store[evindex][TAGSIZE]=1'b0;
			end
		if (tag3store[evindex][TAGSIZE]==1'b1 && tag3store[evindex][TAGSIZE-1:0]==evtag) begin
			tag3store[evindex][TAGSIZE]=1'b0;
			end
	#5		
	//FIFO eviction policy
		tag4store[index]=tag3store[index]; //shift down the line
		tag3store[index]=tag2store[index];
		tag2store[index]=tag1store[index];
		tag1store[index]={1'b1,tag}; //update tag1store
		data4store[index]=data3store[index]; //shift data down the line
		data3store[index]=data2store[index];
		data2store[index]=data1store[index];
		data1store[index]=evdata; //update data1store
	
	end 
	else if (read) begin
		 $display("read, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);
		if (tag1store[index][TAGSIZE]==1'b1 && tag1store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data1store[index];
		hit<=1;
		done<=1;
		end
		else if (tag2store[index][TAGSIZE]==1'b1 && tag2store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data2store[index];
		hit<=1;
		done<=1;
		end
		else if (tag3store[index][TAGSIZE]==1'b1 && tag3store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data3store[index];
		hit<=1;
		done<=1;
		end
		else if (tag4store[index][TAGSIZE]==1'b1 && tag4store[index][TAGSIZE-1:0]==tag) begin
		dataout<=data4store[index];
		hit<=1;
		done<=1;
		end
		else begin //cache miss--evict (or write if compulsory miss)  is coming
		hit<=0;
		done<=1;
		end
	end
	else if (evict && evictaddr!=addr && write  )begin //different procedure if we writing
		$display("EVICT/write, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);
		hit<=1;
		done=1;	
		if (tag1store[index][TAGSIZE]==1'b1 && tag1store[index][TAGSIZE-1:0]==tag) begin
			tag1store[index][TAGSIZE]=1'b0;
			end
		if (tag2store[index][TAGSIZE]==1'b1 && tag2store[index][TAGSIZE-1:0]==tag) begin
			tag2store[index][TAGSIZE]=1'b0;
			end
		if (tag3store[index][TAGSIZE]==1'b1 && tag3store[index][TAGSIZE-1:0]==tag) begin
			tag3store[index][TAGSIZE]=1'b0;
			end
		if (tag4store[index][TAGSIZE]==1'b1 && tag4store[index][TAGSIZE-1:0]==tag) begin
			tag4store[index][TAGSIZE]=1'b0;
			end
		if (tag1store[evindex][TAGSIZE]==1'b1 && tag1store[evindex][TAGSIZE-1:0]==evtag) begin
			tag1store[evindex][TAGSIZE]=1'b0;
			end
		if (tag2store[evindex][TAGSIZE]==1'b1 && tag2store[evindex][TAGSIZE-1:0]==evtag) begin
			tag2store[evindex][TAGSIZE]=1'b0;
			end
		if (tag3store[evindex][TAGSIZE]==1'b1 && tag3store[evindex][TAGSIZE-1:0]==evtag) begin
			tag3store[evindex][TAGSIZE]=1'b0;
			end
	#5
	//update tagstore and datastore based on eviction
	tag4store[evindex]=tag3store[evindex];
	tag3store[evindex]=tag2store[evindex];
	tag2store[evindex]=tag1store[evindex];
	tag1store[evindex]={1'b1,tag};
	data4store[evindex]=data3store[evindex];
	data3store[evindex]=data2store[evindex];
	data2store[evindex]=data1store[evindex];
	data1store[evindex]=evdata;

	end
	/*
	else if (write && evict && evictaddr==addr) begin //if we are reading the addr that is being evicted forward data
		//not necessary as write takes priority at same addr
	
		done<=1;
	//invalidate data with matching tags (regular eviction procedure)
		if (tag1store[evindex][TAGSIZE]==1'b1 && tag1store[evindex][TAGSIZE-1:0]==evtag) begin
			tag1store[evindex][TAGSIZE]=1'b0;
			end
		if (tag2store[evindex][TAGSIZE]==1'b1 && tag2store[evindex][TAGSIZE-1:0]==evtag) begin
			tag2store[evindex][TAGSIZE]=1'b0;
			end
		if (tag3store[evindex][TAGSIZE]==1'b1 && tag3store[evindex][TAGSIZE-1:0]==evtag) begin
			tag3store[evindex][TAGSIZE]=1'b0;
			end
		if (tag4store[evindex][TAGSIZE]==1'b1 && tag4store[evindex][TAGSIZE-1:0]==evtag) begin
			tag4store[evindex][TAGSIZE]=1'b0;
			end
		
	/*
	#5		
	//FIFO eviction policy
		tag4store[index]=tag3store[index]; //shift down the line
		tag3store[index]=tag2store[index];
		tag2store[index]=tag1store[index];
		tag1store[index]={1'b1,tag}; //update tag1store
		data4store[index]=data3store[index]; //shift data down the line
		data3store[index]=data2store[index];
		data2store[index]=data1store[index];
		data1store[index]=evdata; //update data1store
	
	end 
	*/
	else if (write) begin 
		//when store command is called, writes take priorirt over eviction
		//invalidate any matching tags before we put in new data
	 $display("write, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);
	
	done<=1;
	hit<=1;	
		if (tag1store[index][TAGSIZE]==1'b1 && tag1store[index][TAGSIZE-1:0]==tag) begin
			tag1store[index][TAGSIZE]=1'b0;
			end
		if (tag2store[index][TAGSIZE]==1'b1 && tag2store[index][TAGSIZE-1:0]==tag) begin
			tag2store[index][TAGSIZE]=1'b0;
			end
		if (tag3store[index][TAGSIZE]==1'b1 && tag3store[index][TAGSIZE-1:0]==tag) begin
			tag3store[index][TAGSIZE]=1'b0;
			end
		if (tag4store[index][TAGSIZE]==1'b1 && tag4store[index][TAGSIZE-1:0]==tag) begin
			tag4store[index][TAGSIZE]=1'b0;
			end
	/*		
	#5
	//FIFO Replacement policy 
	tag4store[index]=tag3store[index];
	tag3store[index]=tag2store[index];
	tag2store[index]=tag1store[index];
	tag1store[index]={1'b1,tag};
	data4store[index]=data3store[index];
	data3store[index]=data2store[index];
	data2store[index]=data1store[index];
	data1store[index]=wdata;
	*/
	end
	else if (evict)begin //if evict, make sure doesnt match write addr
		//invalidate data with if tag matches
	 $display("evict, evindex=%b,index=%b,ADDR=%h,evaddr=%h",evindex,index,addr,evictaddr);

		if (tag1store[evindex][TAGSIZE]==1'b1 && tag1store[evindex][TAGSIZE-1:0]==evtag) begin
			tag1store[evindex][TAGSIZE]=1'b0;
			end
		if (tag2store[evindex][TAGSIZE]==1'b1 && tag2store[evindex][TAGSIZE-1:0]==evtag) begin
			tag2store[evindex][TAGSIZE]=1'b0;
			end
		if (tag3store[evindex][TAGSIZE]==1'b1 && tag3store[evindex][TAGSIZE-1:0]==evtag) begin
			tag3store[evindex][TAGSIZE]=1'b0;
			end
	#5
	//update tagstore and datastore
	tag4store[evindex]=tag3store[evindex];
	tag3store[evindex]=tag2store[evindex];
	tag2store[evindex]=tag1store[evindex];
	tag1store[evindex]={1'b1,tag};
	data4store[evindex]=data3store[evindex];
	data3store[evindex]=data2store[evindex];
	data2store[evindex]=data1store[evindex];
	data1store[evindex]=evdata;
	done=1;
	hit=1;
	end

	
end

endmodule

