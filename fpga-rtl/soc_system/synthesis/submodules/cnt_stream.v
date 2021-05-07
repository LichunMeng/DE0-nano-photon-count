module PlsCnt(CLK, RST, Tao_cnt,Tao_Q,write, data,tmp_cnt,ready,read_for_slave);
input CLK,RST,write;
input [31:0] Tao_Q;
output reg [31:0] Tao_cnt=8'hff;
output reg [31:0] data=0;
output reg ready=0;
output reg read_for_slave=0;
output reg [31:0] tmp_cnt=0;
//reg [31:0] Tao_cnt1=16'hFFFF;
always @(posedge CLK)
		if (RST) begin
			tmp_cnt<=0;
			data<=0;
			ready<=0;
			read_for_slave<=0;
			end
		else if (write) begin
			Tao_cnt<=Tao_Q;
			tmp_cnt<=0;
			data<=0;
			ready<=0;
			read_for_slave<=0;
			end
		else if (tmp_cnt!=Tao_cnt) begin
			tmp_cnt<=tmp_cnt+1;
			ready<=0;
			read_for_slave<=0;
			end
			
		else if (tmp_cnt==Tao_cnt)begin
			data<=data+1;
			ready<=1;
			tmp_cnt<=0;
			read_for_slave<=1;
			end	

endmodule

