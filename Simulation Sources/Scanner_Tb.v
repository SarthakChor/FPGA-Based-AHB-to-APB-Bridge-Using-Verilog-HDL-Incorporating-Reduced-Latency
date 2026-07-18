`timescale 1ns / 1ps
module Scanner_Tb();
reg clk;
wire read_done, write_done, rst;
wire [2:0] state;    
//AHB
reg HREADYout, HRESP;
reg [31:0] HRDATA;
    
//APB
reg PENABLE, PWRITE; 
reg [3:0] PSELx;
reg [31:0]PWDATA, PADDR;
reg [2:0]state_in;


Scanner scn(
clk,
read_done, write_done, rst,
state,    
//AHB
HREADYout, HRESP,
HRDATA,
    
//APB
PENABLE, PWRITE, 
PSELx,
PWDATA, PADDR,
state_in);


initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end

initial begin
    #4;
    HREADYout = 1'b1;
    HRESP = 1'b0;
    HRDATA = 32'habc51112;
    PENABLE = 1'b1;
    PWRITE = 1'b0;
    PSELx = 2'b01;
    PADDR = 32'h00241111;
    state_in = 3'b011;
   
    #10;
    HREADYout = 1'b1;
    HRESP = 1'b0;
    PENABLE = 1'b1;
    PWRITE = 1'b1;
    PSELx = 2'b01;
    PWDATA = 32'h1000abcd;
    PADDR = 32'h00241111;
    state_in = 3'b001;  
    
    
    #20 $stop;  
end
endmodule
