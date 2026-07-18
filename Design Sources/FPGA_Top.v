`timescale 1ns / 1ps
module FPGA_Top(
    input Clk, read, write,
    output read_done, write_done, rst,
    output [2:0] state
);

//AHB
wire HCLK, HRESETn, HREADYin, HWRITE, HSELAPB; 
wire [31:0] HWDATA, HADDR;
wire [1:0] HTRANS;    
//APB
wire [31:0] PRDATA;

wire [2:0] state_in;

//Clock divider
Clk_divider Dvd(Clk, HCLK);


//Driver module
Driver Drv(
.HCLK(HCLK), .read(read), .write(write),
//AHB
.HRESETn(HRESETn), .HREADYin(HREADYin), .HWRITE(HWRITE), .HSELAPB(HSELAPB), .HWDATA(HWDATA), .HADDR(HADDR), .HTRANS(HTRANS),
//APB
.PRDATA(PRDATA));


wire HREADYout, HRESP;
wire [31:0] HRDATA;

wire PENABLE, PWRITE;
wire [3:0] PSELx;
wire [31:0] PWDATA, PADDR;
 
//Bridge Module
AHB_to_APB_Bridge Bridge(
//AHB SIGNALS
HCLK, HRESETn, HREADYin, HWRITE, HSELAPB, HWDATA, HADDR, HTRANS,
HREADYout, HRESP, HRDATA,
//APB SIGNALS
PRDATA,
PENABLE, PWRITE, PSELx, PWDATA, PADDR, state_in
);


//Scanner Module
Scanner Scn(
HCLK, read, write, read_done, write_done, rst, state,    
//AHB
HREADYout, HRESP, HRDATA,
//APB
PENABLE, PWRITE, PSELx, PWDATA, PADDR, state_in   
);


endmodule
