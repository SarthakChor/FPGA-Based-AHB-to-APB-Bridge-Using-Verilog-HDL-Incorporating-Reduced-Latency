`timescale 1ns / 1ps

module Address_Decoder(
input clk, 
input [31:0] HADDR,
output reg [3:0]PSEL
    );
    
always @(posedge clk)begin
    casez(HADDR)
        32'h0024_zzzz : PSEL <= 4'b0001;
        32'h0101_zzzz : PSEL <= 4'b0010;
        32'h0111_zzzz : PSEL <= 4'b0100;
        32'hAF23_zzzz : PSEL <= 4'b1000;
        default: PSEL <= 4'b0000;
    endcase
end
endmodule
