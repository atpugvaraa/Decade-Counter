`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2025 01:53:12 PM
// Design Name: 
// Module Name: DecadeCounter_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DecadeCounter_TB;
    reg CKA;
    wire CKB;       // Tie to Q0 to realize ÷10
    reg MR1, MR2;
    reg MS1, MS2;
    wire [3:0] Q;

    // DUT
    DecadeCounter dut (
        .CKA(CKA),
        .CKB(CKB),
        .MR1(MR1),
        .MR2(MR2),
        .MS1(MS1),
        .MS2(MS2),
        .Q(Q)
    );

    // CKB driven from Q0 for classic 74LS90 ÷10 cascade
    assign CKB = Q[0];

    // Generate CKA clock
    initial begin
        CKA = 0;
        forever #5 CKA = ~CKA; // 100 MHz / 10 ns period in sim
    end

    // Stimulus
    initial begin
        // Initialize asynchronous controls low (inactive)
        MR1 = 0; MR2 = 0;
        MS1 = 0; MS2 = 0;

        // Apply a proper master reset (both pins high together)
        #2; MR1 = 1; MR2 = 1;
        #15; MR1 = 0; MR2 = 0;

        // Let it count 0..9 a few cycles
        repeat (40) @(posedge CKA);

        // Preset to 9 (1001) using both MS pins
        MS1 = 1; MS2 = 1;
        #10; MS1 = 0; MS2 = 0;

        // Observe a few counts from 9 -> 0
        repeat (30) @(posedge CKA);

        $finish;
    end

    // Monitor
    initial begin
        $display("time  CKA  Q");
        $monitor("%4t   %b   %b", $time, CKA, Q);
    end
endmodule