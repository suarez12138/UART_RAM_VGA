`timescale 1ns / 1ps

module simuart(  );
    
    reg clk_uart;
    reg rst;
    reg data_in;
    wire [7:0]data_out;
    wire data_out_judge;
    wire tmp;
    
    uart u1(clk_uart,rst,data_in,data_out,data_out_judge,tmp);
    
//    initial                                                
//    begin                                                  
//         #0 clk_uart = 0;
//             rst = 0;
//          #1 rst =1;
//    end                                                    
//    always                                                                 
//    begin                                                  
//         #2 clk_uart = ~clk_uart;                                       
//    end 
    
//    always                                                                 
//    begin                                                  
//          data_in = 1; 
//          #100 data_in = 0;
//          #100 data_in = 1;
//          #100 data_in = 1;
//          #100 data_in = 1;
//          #100 data_in = 0;
//          #100 data_in = 1;
//          #100 data_in = 0;
//          #100 data_in = 1;
//          #100 data_in = 1;
//          #100 data_in = 1;             
//    end                                                    
//    endmodule
    
    initial
    begin
        clk_uart=0;
        rst=0;
        #1 rst=1;      
    end
    
    initial
    begin
    data_in=1;
        forever 
        begin
           #100;
           #10 data_in=0;
           #16 data_in=1;
           #16 data_in=1;
           #16 data_in=0;
           #16 data_in=1;
           #16 data_in=1;
           #16 data_in=1;
           #16 data_in=1;
           #16 data_in=0;
        end
    end
    
    initial
    forever #(0.5/8) clk_uart=~clk_uart;
    
endmodule
