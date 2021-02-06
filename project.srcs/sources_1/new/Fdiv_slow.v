`timescale 1ns / 1ps

module Fdiv_slow(
input rst,clk,
output reg clk_out
    );

   parameter period =10000000;
   reg[64:0] count=0;
   always@(posedge clk,negedge rst)
   begin
   if(~rst)
      begin
      count <= 0;
      clk_out<=1'b0;
      end
   else
      begin
      if(count==(period>>1)-1)
         begin
         clk_out <= ~clk_out;
         count<=0;
         end
      else
      count <= count+1;
      end
   end
endmodule
