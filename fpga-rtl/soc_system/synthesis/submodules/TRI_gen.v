module TRI_gen(CLK, RST, Tao_Q, write, ready);
input CLK,RST,write;
input [31:0] Tao_Q;
output reg ready=0;

reg [31:0] Tao_cnt=8'hff;
reg [31:0] tmp_cnt=0;
reg ready2;
//reg [31:0] Tao_cnt1=16'hFFFF;
always @(posedge CLK)
		if (RST) begin
			tmp_cnt<=0;
			ready<=0;
			ready2<=0;
			end
			
		else if (write) begin //update triggering time interval
			Tao_cnt<=Tao_Q;
			tmp_cnt<=0;
			ready<=0;
			ready2<=0;
			end
			
		else if (tmp_cnt!=Tao_cnt && !ready2) begin //accumulating
			tmp_cnt<=tmp_cnt+1;
			ready<=0;
			end
			
		else if (tmp_cnt==Tao_cnt &&!ready2)begin //first cycle positive on ready
			ready<=1;
			ready2<=1;
			tmp_cnt<=0;
			end	
			
		else if (tmp_cnt!=Tao_cnt && ready2) begin //second cycle positive on ready
			tmp_cnt<=tmp_cnt+1;
			ready<=1;
			ready2<=0;
			end

endmodule

