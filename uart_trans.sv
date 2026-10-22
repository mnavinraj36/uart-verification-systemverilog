class transaction ;
  bit reset;
  rand bit [7:0] tx_data;
  rand bit tx_start;
  bit [7:0]rx_data;
  bit tx_busy;
  bit rx_ready;
  
  constraint start_c {
    tx_start dist {1'b1 := 8, 1'b0 := 3};
}
  constraint reset_start_c {
    reset -> !tx_start;
  }
  
  function void display();
   $display("reset=%0b, tx_start=%0b, tx_data=%0h, rx_data=%0h, rx_ready=%0b, tx_busy=%0b",
             reset, tx_start, tx_data,
             rx_data, rx_ready, tx_busy);
    endfunction
  
endclass
