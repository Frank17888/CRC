module CRC32_Check(data,rst,clk,data_crc);
input wire [7:0]data;
input rst;
input clk;
output reg [39:0]data_crc;
reg [39:0]crc_calc;

reg [31:0]crc_restnum;

parameter [32:0]crc_multi_item=33'b1_0000_0100_1100_0001_0001_1101_1011_0111;
reg work_flag;
reg [3:0]cnt;
always @(posedge clk or negedge rst)
	begin	
	if(!rst)
	begin
	cnt<=4'b0000;
	work_flag<=1'b0;
	end
	else if(cnt==4'h0)
		begin
		work_flag<=1'b1;//start work
		cnt<=cnt+1;
		end
	else if(cnt==4'h8)//cnt is one step earilier than calc taking action.
	work_flag<=1'b0;//stop work
	else 
	cnt<=cnt+1'b1;
	end

always @(posedge clk or negedge rst)
	begin
	if(!rst)
	begin
	crc_calc<={data[7:0],32'hFFFF_FFFF};
	end
	else if(work_flag)
	begin
		if(crc_calc[39]==1'b1)
		begin
		crc_calc[39:8]<=crc_calc[38:7]^crc_multi_item[31:0];
		crc_calc[7:0]<={crc_calc[6:0],1'b0};	
		end
		else //the last step doesn't need to be acted.
		crc_calc[39:0]<={crc_calc[38:0],1'b0};//move left
	end
	
	else if (cnt==4'h8)
	begin
	crc_restnum[31:0]<=crc_calc[39:8];
	data_crc[39:0]<={data[7:0],crc_restnum[31:0]};
	end

	end



endmodule

