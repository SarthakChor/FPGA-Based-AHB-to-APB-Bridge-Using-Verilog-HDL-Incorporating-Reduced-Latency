`timescale 1ns / 1ps

module AHB_to_APB_Bridge_tb();
//AHB SIGNALS
reg hclk, HRESETn, HREADYin, HWRITE, HSELAPB; 
reg [31:0] HWDATA, HADDR;
reg [1:0] HTRANS;
wire HREADYout, HRESP;
wire [31:0] HRDATA;
    
//APB SIGNALS
reg [31:0] PRDATA;
wire PENABLE, PWRITE; 
wire [3:0] PSELx;
wire [31:0] PWDATA, PADDR;
wire [2:0] state_in;


AHB_to_APB_Bridge DUT(
//AHB SIGNALS
.HCLK(hclk), .HRESETn(HRESETn), .HREADYin(HREADYin), .HWRITE(HWRITE), .HSELAPB(HSELAPB), .HWDATA(HWDATA), .HADDR(HADDR), .HTRANS(HTRANS), .HREADYout(HREADYout), .HRESP(HRESP), .HRDATA(HRDATA),
//APB SIGNALS
.PRDATA(PRDATA), .PENABLE(PENABLE), .PWRITE(PWRITE), .PSELx(PSELx), .PWDATA(PWDATA), .PADDR(PADDR),

.state_in(state_in)
);

//clk generator
initial begin
    hclk = 1'b0;
    forever #5 hclk = ~hclk;
end

/*
//Read transfer
initial begin
#7 HRESETn = 1'b0;

@(posedge hclk);
if(HREADYout) begin
    //Read transfer
    HRESETn = 1'b1;
    HREADYin = 1'b1;
    HWRITE = 1'b0;
    HSELAPB = 1'b1;
    HADDR = 32'h0024_1111;
    HTRANS = 2'b11;
end

@(posedge HREADYout); 
PRDATA = 32'hABC5_1112;
HREADYin = 1'bX;
HWRITE = 1'bX;
HSELAPB = 1'bX;
HADDR = 32'hX;
HTRANS = 2'bX; 

#20 $stop;
end
*/


//for piplined read
/*
initial begin
@(posedge PENABLE);
HRESETn = 1'b1;
HREADYin = 1'b1;
HWRITE = 1'b0;
HSELAPB = 1'b1;
HADDR = 32'hAF23_ABCD;
HTRANS = 2'b11;

@(posedge HREADYout); 
PRDATA = 32'hABCD_EF12;

@(posedge PENABLE);

#20 $stop;
end

*/

//write transfer


initial begin
#7 HRESETn = 1'b0;

@(posedge hclk);
//Address phase
if(HREADYout)begin
    HRESETn = 1'b1;
    HREADYin = 1'b1;
    HWRITE = 1'b1;
    HSELAPB = 1'b1;
    HADDR = 32'h0024_1111;
    HTRANS = 2'b10; 
end

//Data phase
@(posedge hclk)
HWDATA = 32'h1000_ABCD;
HRESETn = 1'bX;
HREADYin = 1'bX;
HWRITE = 1'bX;
HSELAPB = 1'bX;
HADDR = 32'hX;
HTRANS = 2'bX; 


#20 $stop; 
end



endmodule
