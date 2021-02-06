`timescale 1ns / 1ps

module uart_ram(
      input clk,
      input rst,
      input data_input, 
      input moveright,
      input moveleft,
      input moveup,
      input movedown,   
      output Hsync,Vsync,
      output [3:0] red_out,green_out,blue_out
    );
    
    reg[3:0]red,green,blue=4'b0000;
    parameter CounterWidth1 = 10, VisiblErea1 = 640, FrontPorch1 = 16, SyncPulse1 = 96, BackPorch1 = 48;
    parameter CounterWidth2 = 10, VisiblErea2 = 480, FrontPorch2 = 10, SyncPulse2 = 2, BackPorch2 = 33;
    parameter length  = 384, width = 384;      
    
    wire [7:0] data_out;
    wire cnt2_end;
    wire clk_uart;
    wire clk_rama;  
    wire clk_slow;  
    wire [11:0] data_a;//ram input data
    wire [11:0] data_b;//ram output data
    reg count_uart_to_ram=0;
    reg [9:0] leftspace=10'b0;
    reg [9:0] upspace=10'b0;
    reg [15:0] data=16'b0000000000000000;
    reg [17:0] addra = 18'b000000000000000000;  //ram input address
    reg [17:0] addrb = 18'b000000000000000000;  //ram output address
    reg input_to_ram;
    reg[ CounterWidth1:0] counter1 = 10'b0000000000; 
    reg[ CounterWidth2:0] counter2 = 10'b0000000000; 

    Fdiv2 u4(.rst(rst),.clk(clk),.clk_out(clk_uart));
    Fdiv u5(.rst(rst),.clk(clk),.clk_out(clk_rama));
    Fdiv_slow u6(.rst(rst),.clk(clk),.clk_out(clk_slow)); //to realize movable photo
    
    Uart_Ram_VGA u9(.addra(addra),.addrb(addrb),.dina(data_a),.doutb(data_b),.clka(clk),.clkb(clk),.wea(1));
    uart u2(.clk(clk),.rst(rst),.data_input(data_input),.data_out(data_out),.cnt2_end(cnt2_end));
    vga u3(.Vsync(Vsync),.Hsync(Hsync),.clk(clk),.rst(rst));
    
    //when find the posedge of input_to_ram, 16 bits signal arrived
    always@(negedge input_to_ram or negedge rst)
        begin
        if(!rst)
             addra=18'b000000000000000000;
        else
             addra<=addra+1;
        end
    
    // transport to higher 8 bits when count_uart_to_ram is 0, transport to lower 8 bits when count_uart_to_ram is 1
    always@(posedge clk_uart or negedge rst)
    begin
    if(!rst)
    data=16'b0000000000000000;
    else if (!count_uart_to_ram && cnt2_end)
            begin
            data[15:8]=data_out;
            count_uart_to_ram<=~count_uart_to_ram;
            input_to_ram=0;
            end
    else if (cnt2_end)
            begin
            data[7:0]=data_out+1; // fill the minus 1 of the signal before caused by illegal input 
            count_uart_to_ram<=~count_uart_to_ram; 
            input_to_ram=1;
            end
    end
   
   assign  data_a=data[15:4];//cut the last useless 4 bits
    
    //the ability to move of the photo
    always@(posedge clk_slow or negedge rst)
    begin
    if(!rst)
        begin
        leftspace<=0;
        upspace<=0;
        end
    else if (moveright)
        leftspace<=leftspace+1;
    else if (moveleft)
        leftspace<=leftspace-1;
    else if (movedown)
        upspace<=upspace+1;
    else if (moveup)
        upspace<=upspace-1;             
    end
        
    // the movable photo on the screen  
    always@(posedge clk_rama or negedge rst)
        begin
        if(!rst)
            addrb=18'b000000000000000000;
        else if(counter1>=leftspace && counter1<length+leftspace && counter2>=upspace && counter2<width+upspace )
            addrb<=addrb+1; 
        else if(counter2>width+upspace)
            addrb<=0;
        end
  
   always@(posedge clk_rama)
             begin
             if(counter1<VisiblErea1+FrontPorch1+SyncPulse1+BackPorch1)
                 counter1 <= counter1 + 1;
             else
                 counter1 <= 0;
             end  
    
    always@(posedge clk_rama)
        begin
        if(counter1==VisiblErea1+FrontPorch1+SyncPulse1+BackPorch1)
              begin
              if(counter2<VisiblErea2+FrontPorch2+SyncPulse2+BackPorch2)
                   counter2 <= counter2+1;
              else
                   counter2 <= 0;
              end 
        end    
      
    assign  {red_out,green_out,blue_out} =  counter1>leftspace && counter1<length+leftspace && counter2>upspace && counter2<width+upspace ? data_b:{red,green,blue};        
       
endmodule