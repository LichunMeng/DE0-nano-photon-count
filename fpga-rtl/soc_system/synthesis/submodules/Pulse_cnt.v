module PlsCnt(CLK, RESET, TRIIN, PHO, write,Tao_Q, Cnt_Stream,RDY);
input CLK,RESET, write,TRIIN,PHO;//clock, trigger for starting, photon count(signal from SPC)
input [31:0] Tao_Q; //how many clock generate one data
output reg [63:0] Cnt_Stream=0;//data for fifo
output reg RDY=1'b0;
reg [31:0] Tao;
reg [31:0] PHO_cnt=0;
reg [1:0]tri_1=2'b0;
always @(posedge CLK)
	if (TRIIN==1'b1 && tri_1==2'b0)begin
		tri_1<=tri_1+1;	
		end
	else if	(TRIIN==1'b1 && tri_1!=2'b0)begin
		tri_1<=tri_1+1;
		end
	else begin
		tri_1=0;
		end

always @(posedge PHO) begin
		PHO_cnt<=PHO_cnt+1'b1;
end	

reg tmp=0;
reg [31:0] CLK_cnt=1'b1,Cnt_tmp1=1'b0,Cnt_tmp2=1'b0;

always @(posedge CLK)
		if (RESET) begin
			RDY<=1'b0;
			Cnt_Stream[63:0]<=0;
			CLK_cnt<=1'b1;
			Cnt_tmp1<=0;
			Cnt_tmp2<=0;
			tmp<=0;
			Tao<=16'hffff;
			end
		
		else if (write) begin
			//RDY<=1'b0;
			//Cnt_Stream[63:0]<=0;
			//Cnt_tmp1<=0;
			//Cnt_tmp2<=0;
			//tmp<=0;
			Tao<=Tao_Q;
			end	
		else if (tri_1==2'b01 && (CLK_cnt)%Tao!=1'b0) begin
			CLK_cnt<=CLK_cnt+1'b1;
			RDY<=1'b0;
			Cnt_Stream[63]<=1'b1;
			tmp<=1'b1;
			end
			
		else if (tri_1==2'b01 && (CLK_cnt)%Tao==1'b0)begin
			Cnt_tmp2=PHO_cnt-Cnt_tmp1;
			Cnt_tmp1=PHO_cnt;
			Cnt_Stream[63:32]=Cnt_tmp2;
			Cnt_Stream[31:0]=CLK_cnt;
			CLK_cnt=CLK_cnt+1'b1;
			Cnt_Stream[63]=1'b1;
			CLK_cnt=1'b1;		
			RDY=1'b1;
			end
			
		else if (tri_1!=2'b01 && (CLK_cnt)%Tao!=1'b0)begin
			CLK_cnt<=CLK_cnt+1'b1;
			RDY<=1'b0;
			//Cnt_Stream[63]<=1'b0;
			end	
		
		else if (tri_1!=2'b01 && (CLK_cnt)%Tao==1'b0 && tmp==1'b0) begin
			Cnt_tmp2=PHO_cnt-Cnt_tmp1;
			Cnt_tmp1=PHO_cnt;
			Cnt_Stream[63:32]=Cnt_tmp2;
			Cnt_Stream[31:0]=CLK_cnt;
			Cnt_Stream[63]=1'b0;
			RDY=1'b1;
			CLK_cnt=CLK_cnt+1'b1;
			end
		else if (tri_1!=2'b01 && (CLK_cnt)%Tao==1'b0 && tmp==1'b1) begin
			tmp=1'b0;
			Cnt_tmp2=PHO_cnt-Cnt_tmp1;
			Cnt_tmp1=PHO_cnt;
			RDY=1'b1;
			Cnt_Stream[63:32]=Cnt_tmp2;
			Cnt_Stream[31:0]=CLK_cnt;
			Cnt_Stream[63]=1'b1;
			CLK_cnt=1'b1;		
			end

endmodule

