`timescale 1ns / 1ps
module Driver(
    input HCLK, read, write,
    //AHB
    output reg HRESETn, HREADYin, HWRITE, HSELAPB, 
    output reg [31:0] HWDATA, HADDR,
    output reg [1:0] HTRANS,
    
    //APB
    output reg [31:0] PRDATA
    );
    
    always @(posedge HCLK) begin
        if(read) begin
            HRESETn <= 1'b1;
            HREADYin <= 1'b1;
            HWRITE <= 1'b0;
            HSELAPB <= 1'b1;
            HADDR <= 32'h00241111;
            HTRANS <= 2'h3;
            PRDATA <= 32'habc51112;
        end
        else if(write) begin
            HRESETn <= 1'b1;
            HREADYin <= 1'b1;
            HWRITE <= 1'b1;
            HSELAPB <= 1'b1;
            HADDR <= 32'h00241111;
            HTRANS <= 2'h2;
            HWDATA <= 32'h1000abcd;
        end
        else HRESETn <= 1'b0;
    end
      
endmodule
