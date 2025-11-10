`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2025 01:29:40 PM
// Design Name: 
// Module Name: DecadeCounter
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

module DecadeCounter(
    input  wire CKA,   // Clock for divide-by-2 section
    input  wire CKB,   // Clock for divide-by-5 section (tie to QA for ÷10)
    input  wire MR1,   // Master Reset 1 (use with MR2)
    input  wire MR2,   // Master Reset 2
    input  wire MS1,   // Master Set-to-9 (R9) 1 (use with MS2)
    input  wire MS2,   // Master Set-to-9 (R9) 2
    output reg  QA,    // LSB
    output reg  QB,
    output reg  QC,
    output reg  QD
);
    // Paired async controls (active-high)
    wire async_reset   = MR1 & MR2;
    wire async_preset9 = MS1 & MS2;

    // ÷2 section: QA toggles on posedge CKA
    always @(posedge CKA or posedge async_reset or posedge async_preset9) begin
        if (async_reset) begin
            QA <= 1'b0;
        end else if (async_preset9) begin
            QA <= 1'b1; // 9 => LSB is 1
        end else begin
            QA <= ~QA;
        end
    end

    // ÷5 section: clocked on negedge CKB so QA is stable when advancing
    // State machine over {QB,QC,QD}: 000→001→010→011→100→000...
    always @(negedge CKB or posedge async_reset or posedge async_preset9) begin
        if (async_reset) begin
            {QD, QC, QB} <= 3'b000;
        end else if (async_preset9) begin
            {QD, QC, QB} <= 3'b100; // with QA=1 gives 1001
        end else begin
            case ({QD, QC, QB})
                3'b000: {QD, QC, QB} <= 3'b001;
                3'b001: {QD, QC, QB} <= 3'b010;
                3'b010: {QD, QC, QB} <= 3'b011;
                3'b011: {QD, QC, QB} <= 3'b100;
                3'b100: {QD, QC, QB} <= 3'b000;
                default: {QD, QC, QB} <= 3'b000; // safety
            endcase
        end
    end

endmodule