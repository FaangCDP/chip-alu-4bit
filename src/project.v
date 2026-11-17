/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

 ALU alu_utama (
    .A  (ui_in[3:0]),   // Input A (4-bit) masuk ke pin 0..3
    .B  (ui_in[7:4]),   // Input B (4-bit) masuk ke pin 4..7
    .Sub (uio_in[0]),    // Kontrol Substractor (1-bit) ke pin IO 0
    .Op (uio_in[2:1]),  // Opcode (2-bit) ke pin IO 1..2
    .Sum  (uo_out[3:0]),  // Hasil ALU (4-bit) keluar ke pin output 0..3
    .Cout  (uo_out[4])     // Carry Out (1-bit) keluar ke pin output 4
  );

  // Matikan sisa pin yang tidak dipakai
  assign uo_out[7:5] = 3'b000;
  assign uio_out     = 8'b00000000;
  assign uio_oe      = 8'b00000000;

endmodule
