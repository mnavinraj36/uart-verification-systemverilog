interface uart_if (input logic clk );
  logic reset;
  logic tx_start;
  logic [7:0] tx_data;
  logic [7:0] rx_data;
  logic rx_ready;
  logic tx_busy ;
  
  clocking cb_driver @(posedge clk);
    output  reset;
    output tx_start;
    output tx_data;
    input  tx_busy;
  endclocking
    
  clocking cb_monitor @(posedge clk);
    input   reset;
    input  tx_start;
    input  tx_data;
    input rx_data;
    input rx_ready;
    input  tx_busy;
  endclocking
  
  modport DRIVER (
    clocking cb_driver
);
      
 modport MONITOR (
    clocking cb_monitor 
);
    
 endinterface      
