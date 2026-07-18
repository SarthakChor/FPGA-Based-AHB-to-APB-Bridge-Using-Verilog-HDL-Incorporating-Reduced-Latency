`timescale 1ns/1ps

module Address_Decoder_tb;

    reg clk;
    reg en;
    reg [31:0] HADDR;
    wire [3:0] PSEL;

    // DUT instantiation
    Address_Decoder dut (
        .clk   (clk),
        .en    (en),
        .HADDR (HADDR),
        .PSEL  (PSEL)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Task to apply stimulus and check result
    task check;
        input [31:0] addr;
        input [3:0]  exp_psel;
        begin
            HADDR = addr;
            en    = 1'b1;
            @(posedge clk);
            #1;
            if (PSEL !== exp_psel)
                $display("ERROR: HADDR=%h | Expected=%b | Got=%b", addr, exp_psel, PSEL);
            else
                $display("PASS : HADDR=%h | PSEL=%b", addr, PSEL);
        end
    endtask

    initial begin
        // Initialize
        clk   = 0;
        en    = 0;
        HADDR = 32'h0;

        // Wait for some clocks
        repeat(2) @(posedge clk);

        // ---------------- TEST CASES ----------------

        check(32'h0024_1234, 4'b0001);
        check(32'h0024_ABCD, 4'b0001);

        check(32'h0101_0000, 4'b0010);
        check(32'h0101_FFFF, 4'b0010);

        check(32'h0111_5678, 4'b0100);
        check(32'h0111_AAAA, 4'b0100);

        check(32'hAF23_0001, 4'b1000);
        check(32'hAF23_FFEE, 4'b1000);

        // Default case
        check(32'h1234_5678, 4'b0000);
        check(32'hFFFF_0000, 4'b0000);

        // Disable enable signal
        en = 0;
        HADDR = 32'h0024_1111;
        @(posedge clk);
        #1;
        $display("EN=0 case | PSEL=%b (should retain previous value)", PSEL);

        $display("---- TEST COMPLETE ----");
        $finish;
    end

endmodule
