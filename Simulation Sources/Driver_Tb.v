`timescale 1ns / 1ps
module Driver_Tb();
reg clk, read, write;
//AHB
wire HRESETn, HREADYin, HWRITE, HSELAPB; 
wire [31:0] HWDATA, HADDR;
wire [1:0] HTRANS;
    
//APB
wire [31:0] PRDATA;

Driver DV(
clk, read, write,
//AHB
HRESETn, HREADYin, HWRITE, HSELAPB, 
HWDATA, HADDR,
HTRANS,
    
//APB
PRDATA);


initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end

initial begin
    #5 read = 1'b1;
    #10 read = 1'b0;
    write = 1'b1;
    
    #10 $stop;
end

endmodule