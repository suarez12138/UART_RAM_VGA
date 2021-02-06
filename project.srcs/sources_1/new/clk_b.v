`timescale 1ns / 1ps

module clk_b(
input rst,clk,
output reg clk_out
    );
   reg counttmp=0;
   parameter period = 2;
   reg[3:0] count=4'b0000;
   always@(posedge clk,negedge rst)
   begin
   if(~rst)
      begin
      count <= 4'b0000;
      clk_out<=1'b0;
      end
   else
      begin
      if(counttmp<2)
      counttmp=counttmp+1;
      else if(count==(period>>1)-1)
         begin
         clk_out <= ~clk_out;
         count<=4'b0000;
         end
      else
      count <= count+1;
      end
   end
endmodule
