`timescale 1ns / 1ps
module Clk_divider(
    input clk,
    output reg HCLK = 1'b0
    );
    
reg [31:0] count = 0;

always @(posedge clk) begin
    if(count == 32'd50_000_000)begin
    //if(count == 32'd1)begin     
        HCLK <= ~HCLK;
        count <= 32'd0;
    end
    else count <= count + 1'b1;

end    
endmodule
