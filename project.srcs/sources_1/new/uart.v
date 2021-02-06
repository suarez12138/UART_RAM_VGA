`timescale 1ns / 1ps

module uart(
       input clk,
       input rst,
       input data_input,
       output reg [7:0]data_out,  //the recived 8 bits signal from uart
       output cnt2_end             //control the arrange of 16 bits signal
    );
    
    parameter BPS_115200=434; 
  
    wire recive;     
    wire clk_uart;   //50M hertz
    wire cnt1_start,cnt1_end,cnt2_start;   
    reg [14:0] cnt1;
    reg [3:0] cnt2;
    reg flag_add;   
    reg mes0,mes1,mes2;	
    reg data_out_judge; //show 1 when 8 bits signal arrive

    Fdiv2 u(.clk(clk),.rst(rst),.clk_out(clk_uart));

    always @ (posedge clk_uart or negedge rst)
    begin
	if(~rst)
	    begin
		mes0 <= 1;
        mes1 <= 1;
        mes2 <= 1;
	    end
	else 
	    begin
		mes0 <= data_input;
        mes1 <= mes0;
        mes2 <= mes1;
	    end
    end
    //find 0 in mes1,meaning start bit appears
    assign recive = mes2 & ~mes1;	

    always @ (posedge clk_uart or negedge rst)
    begin
	if(~rst) 
		flag_add <= 0;
	else if(recive) 		
		flag_add <= 1;
    else if(cnt2_end)	
		flag_add <= 0;
	end

    assign cnt1_start = flag_add;
    assign cnt1_end = cnt1_start && cnt1==BPS_115200-1;
    assign cnt2_start = cnt1_end;
    assign cnt2_end = cnt2_start && cnt2==8; 

    always @(posedge clk_uart or negedge rst)
    begin
    if( ~rst)
        cnt1 <= 0;
    else if(cnt1_start) 
        begin
        if(~cnt1_end)
              cnt1 <= cnt1 + 1;
        else
              cnt1 <= 0;
        end
    end

    always @(posedge clk_uart or negedge rst)
    begin 
    if(~rst)
        cnt2 <= 0;   
    else if(cnt2_start)
        begin
        if(~cnt2_end)
             cnt2 <= cnt2 + 1;
        else
             cnt2 <= 0;
        end
    end

    //sampling in middle time
    always @ (posedge clk_uart or negedge rst)
    begin
	   if(~rst) 
		   data_out <= 8'd0;
	   else if(cnt1_start && cnt2!=0 && cnt1==BPS_115200>>2-1) 	
	       data_out[cnt2-1]<= mes2;
    end

    always @ (posedge clk_uart or negedge rst)
    begin
	if(~rst) 
		data_out_judge <= 0;
    else if(cnt2_end) 
		data_out_judge <= 1;		
	else
        data_out_judge <= 0;
    end

endmodule