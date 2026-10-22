
`include "uart_interface.sv"
`include "uart_trans.sv"
`include "uart_gen.sv"
`include "uart_drv.sv"
`include "uart_mon.sv"
`include "uart_scoreboard.sv"
`include "uart_env.sv"
`include "uart_test.sv"
 `include "uart_assertions.sv"
`timescale 1ns/1ps
module tb_top();
  logic clk;
  uart_if intf(clk);
  test t(intf);
  uart_top dut (
    .clk      (clk),
    .reset    (intf.reset),
    .tx_start (intf.tx_start),
    .tx_data  (intf.tx_data),
    .rx_data  (intf.rx_data),
    .rx_ready (intf.rx_ready),
    .tx_busy  (intf.tx_busy)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    intf.reset    = 1'b1;
    intf.tx_start = 1'b0;
    intf.tx_data  = 8'd0;

    repeat(2)
      @(posedge clk);

    intf.reset = 1'b0;
  end

 
  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_top);
  end
  
endmodule
