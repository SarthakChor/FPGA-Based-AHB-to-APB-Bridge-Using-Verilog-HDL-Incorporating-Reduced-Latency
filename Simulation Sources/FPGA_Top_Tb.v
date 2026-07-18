`timescale 1ns / 1ps

module FPGA_Top_Tb();
reg clk, read, write;
wire read_done, write_done, rst;
wire [2:0] state;


FPGA_Top Top(clk, read, write, read_done, write_done, rst, state);

initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end

initial begin
    #10;
    read = 1'b1;
    write = 1'b0;
    
    #70;
    read = 1'b0;
    write = 1'b1;

    #70 
    write = 1'b0;
    
    #50;
    $stop;
end

endmodule
