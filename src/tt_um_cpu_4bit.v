`default_nettype none

module tt_um_cpu_4bit (
    input  wire [7:0] ui_in,    // ROM_Data[7:0]
    output wire [7:0] uo_out,   // [3:0] Hasil_acc, [7:4] ROM_Addr
    input  wire [7:0] uio_in,   // [3:0] ROM_Data[11:8]
    output wire [7:0] uio_out,  // [4] Carry_flag, [5] RAM_WE
    output wire [7:0] uio_oe,   // 0 = input, 1 = output
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [11:0] rom_data = {uio_in[3:0], ui_in[7:0]};
    wire [3:0]  hasil_acc;
    wire        carry_flag;
    wire [3:0]  rom_addr;
    wire [3:0]  ram_addr;
    wire        ram_we;

    // RAM internal 16x4-bit (64 Flip-Flop)
    reg [3:0] ram [0:15];
    wire [3:0] ram_data = ram[ram_addr];

    always @(posedge clk) begin
        if (!rst_n) begin
            ram[0] <= 4'h0; ram[1] <= 4'h0; ram[2] <= 4'h0; ram[3] <= 4'h0;
        end else if (ram_we) begin
            ram[ram_addr] <= hasil_acc;
        end
    end

    CPU_4bit_chip core (
        .rst        (~rst_n),
        .clk        (clk),
        .ROM_Data   (rom_data),
        .RAM_data   (ram_data),
        .Hasil_acc  (hasil_acc),
        .Carry_flag (carry_flag),
        .ROM_Addr   (rom_addr),
        .RAM_Addr   (ram_addr),
        .RAM_WE     (ram_we)
    );

    assign uo_out  = {rom_addr, hasil_acc};
    assign uio_out = {2'b00, ram_we, carry_flag, 4'b0000};
    assign uio_oe  = 8'b1111_0000; // [3:0] input ROM, [7:4] output flag

    wire _unused = &{ena, uio_in[7:4], 1'b0};

endmodule
