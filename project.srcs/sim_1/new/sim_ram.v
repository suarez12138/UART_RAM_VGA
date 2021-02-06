`timescale 1ns / 1ps

module sim_ram( );   
     reg clk;
     reg rst;
     reg data_input;
     reg moveright;
     reg moveleft;
     reg moveup;
     reg movedown;
     wire Hsync,Vsync;
     wire [3:0] red_out,green_out,blue_out;
     wire [7:0] data_out;
     wire count_uart_to_ram;
     wire [11:0] data_a;
     wire [11:0] data_b;
     wire [17:0] addra;
     wire [17:0] addrb;
     wire cnt2_end;
     
     uart_ram u10(clk,rst,data_input,moveright,moveleft,moveup,movedown,Hsync,Vsync,red_out,green_out,blue_out,data_a,data_b,addra,addrb,data_out,count_uart_to_ram,cnt2_end);
    
 initial
       begin       
           clk=0;
           rst=0;
           #1 rst=1;
           moveright =0;
           moveleft=0;
           moveup=0;
           movedown=0;          
       end
       
       initial
       begin
       data_input=1;
           forever 
           begin
              #1;data_input=0;
              #1 data_input=0;
              #1 data_input=1;
              #1 data_input=1;
              #1 data_input=0;
              #1 data_input=1;
              #1 data_input=1;
              #1 data_input=1;
              #1 data_input=1;
              #1 data_input=0;
              #1 data_input=1;
           end
       end
       
       initial
       forever #(0.5/8) clk=~clk;
       

endmodule
