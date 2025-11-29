`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2025 01:53:12 PM
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
    reg  CKA;
    wire CKB;
    reg  MR1, MR2;
    reg  MS1, MS2;
    wire QA, QB, QC, QD;

    DecadeCounter dut (
        .CKA(CKA), .CKB(CKB),
        .MR1(MR1), .MR2(MR2),
        .MS1(MS1), .MS2(MS2),
        .QA(QA), .QB(QB), .QC(QC), .QD(QD)
    );

    // ÷10 wiring
    assign CKB = QA;

    // Master clock
    initial begin
        CKA = 0;
        forever #5 CKA = ~CKA;
    end

    integer dec;
    always @(*) dec = {QD, QC, QB, QA};

    initial begin
        MR1 = 0; MR2 = 0; MS1 = 0; MS2 = 0;

        // Proper reset
        #2; MR1 = 1; MR2 = 1;
        #10; MR1 = 0; MR2 = 0;

        // Observe 0..9 a few cycles
        repeat (40) @(posedge CKA);

        // Preset to 9
        MS1 = 1; MS2 = 1;
        #10; MS1 = 0; MS2 = 0;

        repeat (30) @(posedge CKA);
        $finish;
    end

    initial begin
        $display("time  CKA  QDQCQBQA  dec");
        $monitor("%4t   %b     %b%b%b%b    %0d",
                 $time, CKA, QD, QC, QB, QA, dec);
    end
endmodule