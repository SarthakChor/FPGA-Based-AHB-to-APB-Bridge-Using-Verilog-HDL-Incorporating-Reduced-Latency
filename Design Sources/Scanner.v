`timescale 1ns / 1ps

module Scanner(
    input HCLK, read, write,
    output reg read_done, write_done, rst,
    output [2:0] state,    
    //AHB
    input HREADYout, HRESP,
    input [31:0] HRDATA,
    
    //APB
    input PENABLE, PWRITE, 
    input [3:0] PSELx,
    input [31:0] PWDATA, PADDR,
    input [2:0] state_in
    
    );
    
    
    always @(posedge HCLK) begin
    if((read != 1'b1) && (write != 1'b1))begin
        write_done <= 1'b0;
        read_done <= 1'b0;
        rst <= 1'b1;
    end
    else if((HRDATA == 32'habc51112) && (PWRITE == 1'b0) && 
    (PSELx == 2'b01) && (PADDR == 32'h00241111)) begin
        read_done <= 1'b1;
        write_done <= 1'b0;
        rst <= 1'b0;
     end
     else if((PWDATA == 32'h1000abcd) && (PWRITE == 1'b1) && 
     (PSELx == 2'b01) && (PADDR == 32'h00241111)) begin
         write_done <= 1'b1;
         read_done <= 1'b0;
         rst <= 1'b0;
      end  
    end
    
    assign state = state_in;
endmodule
