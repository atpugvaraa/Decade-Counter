`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2025 01:29:40 PM
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
    input wire CKA,   // Clock for divide-by-2 section
    input wire CKB,   // Clock for divide-by-5 section (often fed by Q[0] for ÷10)
    input wire MR1,   // Master Reset pin 1 (use together with MR2)
    input wire MR2,   // Master Reset pin 2
    input wire MS1,   // Master Set-to-9 (R9) pin 1 (use together with MS2)
    input wire MS2,   // Master Set-to-9 (R9) pin 2
    output reg [3:0] Q // BCD output: Q[3]..Q[0]
);

    // Internal decode of paired asynchronous controls
    wire async_reset = MR1 & MR2; // active-high when both MR pins are high
    wire async_preset9 = MS1 & MS2; // active-high when both MS pins are high

    // Divide-by-2 section (Q0)
    // Asynchronous priority: reset > preset9
    // On CKA rising edge, toggle Q0.
    always @(posedge CKA or posedge async_reset or posedge async_preset9) begin
        if (async_reset) begin
            Q[0] <= 1'b0;
        end else if (async_preset9) begin
            // When preset to 9 (1001), Q0 must be 1
            Q[0] <= 1'b1;
        end else begin
            Q[0] <= ~Q[0];
        end
    end

    // Divide-by-5 section (Q3:Q1)
    // Implements a modulo-5 state machine that, together with Q0, yields BCD 0..9.
    // States for Q[3:1] across counts 0..9 (with Q0 as LSB):
    // 0:  Q3Q2Q1 = 000
    // 1:  000
    // 2:  001
    // 3:  001
    // 4:  010
    // 5:  010
    // 6:  011
    // 7:  011
    // 8:  100
    // 9:  100
    // That means on each CKB tick (which advances every second CKA in ÷10 mode),
    // Q[3:1] progresses through 000->001->010->011->100->000 ...
    // Asynchronous priority matches the ÷2 section.
    always @(negedge CKB or posedge async_reset or posedge async_preset9) begin
        if (async_reset) begin
            Q[3:1] <= 3'b000;
        end else if (async_preset9) begin
            Q[3:1] <= 3'b100; // 100 with Q0=1 => 1001 (decimal 9)
        end else begin
            // modulo-5 progression
            case (Q[3:1])
                3'b000: Q[3:1] <= 3'b001; // 0/1 -> 2/3 upper bits pattern
                3'b001: Q[3:1] <= 3'b010; // -> 4/5
                3'b010: Q[3:1] <= 3'b011; // -> 6/7
                3'b011: Q[3:1] <= 3'b100; // -> 8/9
                3'b100: Q[3:1] <= 3'b000; // wrap to 0/1
                default: Q[3:1] <= 3'b000; // safety: should never occur
            endcase
        end
    end
endmodule