
module uart_top #(
    parameter CLK_FREQ   = 50_000_000,
    parameter BAUD_RATE  = 115200,
    parameter OVERSAMPLE = 16
)(
    input        clk,
    input        reset,

    input        tx_start,
    input  [7:0] tx_data,


    output [7:0] rx_data,
    output       rx_ready,


    output       tx_busy
);

   
    wire tx_enable;
    wire rx_enable;
    wire tx_wire;

    baud_generator #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLE(OVERSAMPLE)
    ) baud_gen (
        .clk(clk),
        .reset(reset),
        .tx_enable(tx_enable),
        .rx_enable(rx_enable)
    );

   
    transmitter tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_enable(tx_enable),
        .enable(tx_start),
        .datain(tx_data),
        .busy(tx_busy),
        .tx(tx_wire)
    );

    receiver rx_inst (
        .clk(clk),
        .reset(reset),
        .rx_enable(rx_enable),
        .rx(tx_wire),         
        .data_out(rx_data),
        .ready(rx_ready)
    );

endmodule
