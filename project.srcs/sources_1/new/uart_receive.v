`timescale 1ns / 1ps
module uart_rx(
		 input				clk_50m,
		 input				rst_n,
		 input				data_in,
		 output reg[7:0]	rx_data,
		 output reg			rx_done
		 
);
parameter
		Clk_Frequency = 50_000_000,
		Baud_Rate = 9600,
		BPS_CNT = Clk_Frequency / Baud_Rate;
		
wire			start_flag;

reg			rx_d0;
reg			rx_d1;
reg			rx_flag;
reg[15:0]	clk_cnt;	
reg			bps_clk;	
reg[ 3:0]	baud_cnt;
reg[ 7:0]	data_buff;

//    Uart_Ram_Vga(
//    .(),
//    );

//通过检测下降沿判断起始位,空闲时数据线为高电平，起始位为低电平
assign	start_flag = ( !rx_d0 ) & rx_d1;
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) begin
		rx_d0 <= 1'b0;
		rx_d1 <= 1'b0;
	end
	else begin
		rx_d0 <= data_in;
		rx_d1 <= rx_d0;		
	end
end
//产生接收标志位
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) 
		rx_flag <= 1'b0;
	else if( start_flag )
		rx_flag <= 1'b1;
		else if( (baud_cnt == 4'd10) && ( clk_cnt == BPS_CNT / 2) )//这里为什么不能写else if( baud_cnt == 4'd10 )？
		rx_flag <= 1'b0;
	else
		rx_flag <= rx_flag;
end
//系数时钟计数
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) 
		clk_cnt <= 16'd0;
	else if( rx_flag ) begin
		if( clk_cnt < BPS_CNT )
			clk_cnt <= clk_cnt + 1'b1;
		else
			clk_cnt <= 16'd0;
	end
	else
		clk_cnt <= 16'd0;
end
//产生波特率时钟
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) 
		bps_clk <= 1'b0;
	else if( rx_flag ) begin
		if( clk_cnt == 16'd1 )		//这里可以是0~BPS_CNT任意一个数，但是为了减少延时，选择16'd1
			bps_clk <= 1'b1;
		else
			bps_clk <= 1'b0;
	end
	else
		bps_clk <= 1'b0;
end
//对波特率时钟计数
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) 	
		baud_cnt <= 4'd0;
	else if( bps_clk )	
		baud_cnt <= baud_cnt + 1'b1;
	else if( baud_cnt == 4'd11)
		baud_cnt <= 4'd1;			//这里不能写baud_cnt <= 4'd0;否则导致数据位和baud_cnt位置出错，从而接收不正确											
	else
		baud_cnt <= baud_cnt;
end
//接收数据并缓存
always @ ( posedge clk_50m or negedge rst_n ) begin
	if( !rst_n ) 
		data_buff <= 8'd0;
	else if( rx_flag ) begin
		if( clk_cnt == BPS_CNT / 2 )  					//每个波特率时钟中间获取数据，确保数据准确
			case( baud_cnt )
				4'd2  : data_buff[0] <=	data_in;			//其中baud_cnt=4'd1对应着起始位，也就是1'd0
				4'd3  : data_buff[1] <=	data_in;
				4'd4  : data_buff[2] <=	data_in;
				4'd5  : data_buff[3] <=	data_in;
				4'd6  : data_buff[4] <=	data_in;
				4'd7  : data_buff[5] <=	data_in;
				4'd8  : data_buff[6] <=	data_in;
				4'd9  : data_buff[7] <=	data_in;
				default : ;
			endcase
		else
			data_buff <= data_buff;
	end
	else
		data_buff <= 8'd0;
end
//数据缓存输出
always @ ( posedge clk_50m or negedge rst_n )
	if(!rst_n) 
		rx_data <= 8'd0;
	else if(baud_cnt == 4'd10)	//					
		rx_data <= data_buff;
	else
		rx_data <= rx_data;
//接收完成标志位输出
always @ ( posedge clk_50m or negedge rst_n )
	if(!rst_n) 
		rx_done <= 1'b0;
	else if( baud_cnt == 4'd10 )
		rx_done <= 1'b1;
	else 
		rx_done <= 1'b0;
endmodule
