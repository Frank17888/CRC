`timescale 1ns/10ps
module Test_CRC32_Check();
	reg clk;
	reg rst;
	reg [7:0]data_input;
	wire [39:0]data_receive;
	parameter SYS_CLK=10;
CRC32_Check U1(.data(data_input),.rst(rst),.clk(clk),.data_crc(data_receive));
initial 
	begin 
	data_input=8'haa;
	#5 rst=1'b0;
	#10 rst=1'b1;
	#10 clk=1'b0;
	end
always #SYS_CLK clk<=~clk;

endmodule

	
